import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart' as ai;
import 'package:http/http.dart' as http;
import 'dart:convert';

class DbChatMessage {
  final String id;
  final String? userId;
  final String role;
  final String content;
  final DateTime createdAt;

  DbChatMessage({
    required this.id,
    required this.userId,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  factory DbChatMessage.fromMap(Map<String, dynamic> map) {
    return DbChatMessage(
      id: map['id'],
      userId: map['user_id'],
      role: map['role'],
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'role': role,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class ChatbotCrudService {
  final SupabaseClient client;
  ChatbotCrudService(this.client);

  Future<void> addMessage({
    required String role,
    required String content,
    String? userId,
  }) async {
    await client.from('chatbot_messages').insert({
      'user_id': userId,
      'role': role,
      'content': content,
    });
  }

  Future<List<DbChatMessage>> fetchMessages({
    String? userId,
    int limit = 50,
  }) async {
    final builder =
        userId != null
            ? client.from('chatbot_messages').select().eq('user_id', userId)
            : client.from('chatbot_messages').select();
    final response = await builder
        .order('created_at', ascending: false)
        .limit(limit);
    return (response as List)
        .map((e) => DbChatMessage.fromMap(e))
        .toList()
        .reversed
        .toList();
  }
}

class GeminiService {
  final String apiKey;
  final String endpoint;
  final ChatbotCrudService chatService;
  final String? userId;

  GeminiService({
    required this.apiKey,
    required this.endpoint,
    required this.chatService,
    this.userId,
  });

  Future<String> sendMessage(String prompt) async {
    await chatService.addMessage(role: 'user', content: prompt, userId: userId);

    final url = Uri.parse(
      '$endpoint/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
    );
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt},
          ],
        },
      ],
      'generationConfig': {'maxOutputTokens': 1000},
    });

    final response = await http.post(url, headers: headers, body: body);
    debugPrint('Gemini API Response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content =
          data['candidates']?[0]?['content']?['parts']?[0]?['text'] ??
          'No response.';
      if (content == 'No response.') {
        debugPrint(
          'Warning: Unexpected Gemini API response structure: ${response.body}',
        );
        return 'Unexpected response structure';
      }
      await chatService.addMessage(
        role: 'assistant',
        content: content,
        userId: userId,
      );
      return content;
    } else {
      final error = 'Gemini API error: ${response.statusCode} ${response.body}';
      debugPrint('Error: $error');
      return error;
    }
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final GeminiService _geminiService;
  late final ChatbotCrudService _chatService;
  List<DbChatMessage> _messages = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _controller = TextEditingController();
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      final endpoint =
          dotenv.env['GEMINI_API_ENDPOINT'] ??
          'https://generativelanguage.googleapis.com';
      if (apiKey == null) {
        throw Exception('Gemini API key not set in .env');
      }
      final user = Supabase.instance.client.auth.currentUser;
      _chatService = ChatbotCrudService(Supabase.instance.client);
      _geminiService = GeminiService(
        apiKey: apiKey,
        endpoint: endpoint,
        chatService: _chatService,
        userId: user?.id,
      );
      await _loadHistory();
      setState(() => _isLoading = false);
    } catch (e, st) {
      debugPrint('Error initializing services: $e\n$st');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to initialize chat: $e';
      });
    }
  }

  Future<void> _loadHistory() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      final messages = await _chatService.fetchMessages(userId: user?.id);
      setState(() {
        _messages = messages;
      });
    } catch (e, st) {
      debugPrint('Error loading chat history: $e\n$st');
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _sending = true;
      _messages.add(
        DbChatMessage(
          id: UniqueKey().toString(),
          userId: Supabase.instance.client.auth.currentUser?.id,
          role: 'user',
          content: text,
          createdAt: DateTime.now(),
        ),
      );
      _controller.clear();
    });
    try {
      final aiResponse = await _geminiService.sendMessage(text);
      setState(() {
        _messages.add(
          DbChatMessage(
            id: UniqueKey().toString(),
            userId: Supabase.instance.client.auth.currentUser?.id,
            role: 'assistant',
            content: aiResponse,
            createdAt: DateTime.now(),
          ),
        );
        _sending = false;
      });
    } catch (e, st) {
      debugPrint('Error sending message: $e\n$st');
      setState(() {
        _sending = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to get AI response.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example: Google Gemini AI with Supabase'),
        backgroundColor: const Color(0xFF2563EB),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, i) {
                        final msg = _messages[i];
                        final isUser = msg.role == 'user';
                        return Align(
                          alignment:
                              isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  isUser ? Colors.blue[100] : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(msg.content),
                          ),
                        );
                      },
                    ),
                  ),
                  if (_sending)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: CircularProgressIndicator(),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              hintText:
                                  'Ask a question... (English or Swahili)',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: Color(0xFF2563EB),
                          ),
                          onPressed: _sending ? null : _sendMessage,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}

// --- END CLEAN CHAT PAGE ---
