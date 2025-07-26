import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/community_comment.dart';

final SupabaseClient _client = Supabase.instance.client;

Future<List<CommunityComment>> fetchComments() async {
  final response = await _client
      .from('community_forum')
      .select()
      .order('created_at', ascending: false);
  return (response as List)
      .map((e) => CommunityComment.fromMap(e as Map<String, dynamic>))
      .toList();
}

Future<void> postComment(String comment, String name) async {
  await _client.from('community_forum').insert({
    'comment': comment,
    'name': name,
    'reactions': {},
  });
}

class CommunityForumScreen extends StatefulWidget {
  const CommunityForumScreen({super.key});

  @override
  State<CommunityForumScreen> createState() => CommunityForumScreenState();
}

class CommunityForumScreenState extends State<CommunityForumScreen> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final List<CommunityComment> _comments = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    setState(() => _loading = true);
    final comments = await fetchComments();
    setState(() {
      _comments.clear();
      _comments.addAll(comments);
      _loading = false;
    });
  }

  Future<void> _addComment() async {
    final comment = _commentController.text.trim();
    final name =
        _nameController.text.trim().isEmpty
            ? 'Anonymous'
            : _nameController.text.trim();
    if (comment.isNotEmpty) {
      _commentController.clear();
      await postComment(comment, name);
      await _loadComments();
    }
  }

  Future<void> _addReaction(CommunityComment comment, String emoji) async {
    final reactions = Map<String, int>.from(comment.reactions);
    reactions[emoji] = (reactions[emoji] ?? 0) + 1;
    await _client
        .from('community_forum')
        .update({'reactions': reactions})
        .eq('id', comment.id);
    await _loadComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Forum')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Your name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 80,
                  child: TextField(
                    controller: _commentController,
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _loading ? null : _addComment,
                  child: const Text('Post'),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      reverse: false,
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        final comment = _comments[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: ListTile(
                            title: Text(comment.comment),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('By: ${comment.name}'),
                                Text(comment.createdAt.toLocal().toString()),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    ...['👍', '❤️', '😂', '🎉'].map((emoji) {
                                      final count =
                                          comment.reactions[emoji] ?? 0;
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8.0,
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            await _addReaction(comment, emoji);
                                          },
                                          child: Row(
                                            children: [
                                              Text(emoji),
                                              if (count > 0) Text(' $count'),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
