import 'package:flutter/material.dart';
import '../services/grok_api_service.dart';
import '../services/auth_service.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _sending = false;
  GrokApiService? _grokService;

  Map<String, String?> _user = {};
  bool _loadingUser = true;

  @override
  void initState() {
    super.initState();
    _grokService = GrokApiService();
    _loadUser();
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
    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _controller.clear();
      _sending = true;
    });
    try {
      final aiResponse = await _grokService!.sendMessage(text);
      if (!mounted) return;
      setState(() {
        _messages.add({'role': 'ai', 'text': aiResponse});
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
          _loadingUser
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
                                  final isUser = msg['role'] == 'user';
                                  return Align(
                                    alignment:
                                        isUser
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                    child: MouseRegion(
                                      cursor:
                                          isUser
                                              ? SystemMouseCursors.basic
                                              : SystemMouseCursors.click,
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isWide ? 24 : 16,
                                          vertical: isWide ? 16 : 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              isUser
                                                  ? const Color(0xFF2563EB)
                                                  : Colors.grey[200],
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                          boxShadow:
                                              isWide && isUser
                                                  ? [
                                                    BoxShadow(
                                                      color: Colors.blue
                                                          .withAlpha(
                                                            (0.08 * 255)
                                                                .toInt(),
                                                          ),
                                                      blurRadius: 8,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ]
                                                  : [],
                                        ),
                                        child: Text(
                                          msg['text']!,
                                          style: TextStyle(
                                            color:
                                                isUser
                                                    ? Colors.white
                                                    : Colors.black,
                                            fontSize: isWide ? 18 : 15,
                                          ),
                                        ),
                                      ),
                                    ),
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
