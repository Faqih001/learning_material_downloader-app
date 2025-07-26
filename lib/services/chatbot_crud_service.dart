import 'package:supabase_flutter/supabase_flutter.dart';

class ChatMessage {
  final String id;
  final String? userId;
  final String role;
  final String content;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.userId,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      userId: map['user_id'],
      role: map['role'],
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
    );
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

  Future<List<ChatMessage>> fetchMessages({String? userId, int limit = 50}) async {
    final query = client.from('chatbot_messages').select().order('created_at', ascending: false).limit(limit);
    if (userId != null) {
      query.eq('user_id', userId);
    }
    final response = await query;
    return (response as List).map((e) => ChatMessage.fromMap(e)).toList().reversed.toList();
  }
}
