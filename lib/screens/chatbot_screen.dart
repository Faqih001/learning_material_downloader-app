import 'package:flutter/material.dart';
// import '../services/grok_api_service.dart';
import '../services/auth_service.dart';
import '../services/gemini_api_service.dart';
import '../services/chatbot_crud_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/chat_bubble.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _sending = false;
  ChatbotCrudService? _chatCrud;
  Map<String, String?> _user = {};
  bool _loadingUser = true;
  bool _loadingHistory = true;
  final GeminiApiService _geminiService = GeminiApiService();

  @override
  void initState() {
    super.initState();
  // _grokService = GrokApiService();
    _chatCrud = ChatbotCrudService(Supabase.instance.client);
    _loadUser();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() => _loadingHistory = true);
    try {
      final user = Supabase.instance.client.auth.currentUser;
      final userId = user?.id;
      final history = await _chatCrud!.fetchMessages(userId: userId);
      if (!mounted) return;
      setState(() {
        _messages.clear();
        _messages.addAll(history);
        _loadingHistory = false;
      });
    } catch (e, st) {
      debugPrint('Error fetching chat history: $e\n$st');
      if (!mounted) return;
      setState(() => _loadingHistory = false);
    }
  }

  Future<void> _loadUser() async {
    try {
      final user = await AuthService().getCurrentUser();
      if (!mounted) return;
      setState(() {
        _user = user;
        _loadingUser = false;
      });
    } catch (e, st) {
      debugPrint('Error loading user: $e\n$st');
      if (!mounted) return;
      setState(() {
        _user = {};
        _loadingUser = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load user data.')),
      );
    }
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final user = Supabase.instance.client.auth.currentUser;
    final userId = user?.id;
    final now = DateTime.now();
    setState(() {
      _messages.add(
        ChatMessage(
          id: UniqueKey().toString(),
          userId: userId,
          role: 'user',
          content: text,
          createdAt: now,
        ),
      );
      _controller.clear();
      _sending = true;
    });
    try {
      await _chatCrud?.addMessage(role: 'user', content: text, userId: userId);
      // Streaming Gemini response
      final aiMsg = ChatMessage(
        id: UniqueKey().toString(),
        userId: userId,
        role: 'ai',
        content: '',
        createdAt: DateTime.now(),
      );
      setState(() {
        _messages.add(aiMsg);
      });
      int aiMsgIndex = _messages.length - 1;
      await for (final partial in _geminiService.streamResponse(text)) {
        if (!mounted) return;
        setState(() {
          _messages[aiMsgIndex] = ChatMessage(
            id: aiMsg.id,
            userId: aiMsg.userId,
            role: aiMsg.role,
            content: partial,
            createdAt: aiMsg.createdAt,
          );
        });
      }
      await _chatCrud?.addMessage(
        role: 'ai',
        content: _messages[aiMsgIndex].content,
        userId: userId,
      );
      if (!mounted) return;
      setState(() {
        _sending = false;
      });
    } catch (e, st) {
      debugPrint('Error sending message: $e\n$st');
      if (!mounted) return;
      setState(() {
        _sending = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to get AI response.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Study Assistant'),
        backgroundColor: const Color(0xFF2563EB),
      ),
      body:
          _loadingUser || _loadingHistory
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 700;
                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isWide ? 700 : double.infinity,
                      ),
                      child: Column(
                        children: [
                          if ((_user['name']?.isNotEmpty ?? false) ||
                              (_user['email']?.isNotEmpty ?? false))
                            Container(
                              width: double.infinity,
                              color: Colors.blue.shade50,
                              padding: EdgeInsets.symmetric(
                                vertical: isWide ? 18 : 12,
                                horizontal: isWide ? 32 : 16,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.account_circle,
                                    color: Color(0xFF2563EB),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (_user['name'] != null &&
                                            _user['name']!.isNotEmpty)
                                          Text(
                                            _user['name']!,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        if (_user['email'] != null &&
                                            _user['email']!.isNotEmpty)
                                          Text(
                                            _user['email']!,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isWide ? 32 : 12,
                                vertical: isWide ? 24 : 8,
                              ),
                              child: ListView.builder(
                                itemCount: _messages.length,
                                itemBuilder: (context, i) {
                                  final msg = _messages[i];
                                  return ChatBubble(
                                    text: msg.content,
                                    isUser: msg.role == 'user',
                                    timestamp: msg.createdAt,
                                  );
                                },
                              ),
                            ),
                          ),
                          if (_sending)
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: CircularProgressIndicator(),
                            ),
                          Padding(
                            padding: EdgeInsets.all(isWide ? 24 : 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _controller,
                                    decoration: InputDecoration(
                                      hintText:
                                          'Ask a question... (English or Swahili)',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: isWide ? 20 : 14,
                                        horizontal: isWide ? 20 : 12,
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: isWide ? 18 : 15,
                                    ),
                                    onSubmitted: (_) => _sendMessage(),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.send,
                                      color: Color(0xFF2563EB),
                                      size: isWide ? 32 : 24,
                                    ),
                                    onPressed: _sending ? null : _sendMessage,
                                    tooltip: 'Send',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
