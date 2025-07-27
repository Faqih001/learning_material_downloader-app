import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart' as ai;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_markdown/flutter_markdown.dart';

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
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _controller = TextEditingController();
  bool _sending = false;
  final List<String> _defaultPrompts = [
    'I want to download specific learning materials. Here is the topic or URL: [paste here]. Can you help me find them online?',
    'What is the best way to download learning materials?',
    'How can I use this app to find resources?',
    'Can you recommend study tips?',
    'How do I contact support?',
    'Tell me about LMD Chatbot.',
  ];

  @override
  void initState() {
    super.initState();
    _initializeServices();
    // Add welcome message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _messages.insert(
          0,
          DbChatMessage(
            id: UniqueKey().toString(),
            userId: null,
            role: 'assistant',
            content:
                '👋 Welcome to LMD Chatbot!\n\nI am here to help you download learning materials, answer your questions, and provide support.\n\nFor further assistance, contact: fakiiahmad001@gmail.com or 0741140250.',
            createdAt: DateTime.now(),
          ),
        );
      });
    });
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
      // Scroll to bottom after user sends
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    });
    try {
      // Show 'thinking...' bubble
      setState(() {
        _messages.add(
          DbChatMessage(
            id: UniqueKey().toString(),
            userId: null,
            role: 'assistant',
            content: 'Thinking...',
            createdAt: DateTime.now(),
          ),
        );
      });
      _scrollToBottom();
      final aiResponse = await _geminiService.sendMessage(text);
      setState(() {
        // Remove 'Thinking...' bubble
        _messages.removeWhere(
          (m) => m.role == 'assistant' && m.content == 'Thinking...',
        );
        _messages.add(
          DbChatMessage(
            id: UniqueKey().toString(),
            userId: null,
            role: 'assistant',
            content: aiResponse,
            createdAt: DateTime.now(),
          ),
        );
        _sending = false;
      });
      _scrollToBottom();
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

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LMD Chatbot'),
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
                  // Default prompt chips
                  if (_messages.length <= 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Wrap(
                        spacing: 8,
                        children:
                            _defaultPrompts
                                .map(
                                  (prompt) => ActionChip(
                                    label: Text(prompt),
                                    onPressed:
                                        _sending
                                            ? null
                                            : () {
                                              _controller.text = prompt;
                                              _sendMessage();
                                            },
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _messages.length,
                      itemBuilder: (context, i) {
                        final msg = _messages[i];
                        final isUser = msg.role == 'user';
                        final isThinking =
                            msg.role == 'assistant' &&
                            msg.content == 'Thinking...';
                        return Align(
                          alignment:
                              isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            padding: const EdgeInsets.all(0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (!isUser)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.blue[700],
                                      child: const Text(
                                        'L',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                Flexible(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isUser
                                              ? Colors.blue[100]
                                              : isThinking
                                              ? Colors.grey[300]
                                              : Colors.grey[200],
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(16),
                                        topRight: const Radius.circular(16),
                                        bottomLeft: Radius.circular(
                                          isUser ? 16 : 4,
                                        ),
                                        bottomRight: Radius.circular(
                                          isUser ? 4 : 16,
                                        ),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(
                                            (0.04 * 255).round(),
                                          ),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child:
                                        isThinking
                                            ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const SizedBox(
                                                  width: 18,
                                                  height: 18,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                ),
                                                const SizedBox(width: 8),
                                                const Text('Thinking...'),
                                              ],
                                            )
                                            : (isUser
                                                ? Text(
                                                    msg.content,
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  )
                                                : Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                                                    child: MarkdownBody(
                                                      data: msg.content,
                                                      styleSheet: MarkdownStyleSheet(
                                                        p: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                                                        strong: const TextStyle(fontWeight: FontWeight.bold),
                                                        listBullet: const TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  )
                                              ),
                                  ),
                                ),
                                if (isUser)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[600],
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
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
