import '../services/supabase_crud_service.dart';

// Function to fetch comments from backend
Future<List<String>> fetchComments() async {
  // TODO: Implement backend fetch logic
  return [];
}

// Function to post a comment to backend
Future<void> postComment(String comment) async {
  // TODO: Implement backend post logic
  await SupabaseCrudService().insert('community_forum', {'comment': comment});
}
import 'package:flutter/material.dart';

class CommunityForumScreen extends StatefulWidget {
  @override
  _CommunityForumScreenState createState() => _CommunityForumScreenState();
}

class _CommunityForumScreenState extends State<CommunityForumScreen> {
  final TextEditingController _commentController = TextEditingController();
  List<String> _comments = [];

  void _addComment() async {
    final comment = _commentController.text.trim();
    if (comment.isNotEmpty) {
      setState(() {
        _comments.insert(0, comment);
        _commentController.clear();
      });
      await postComment(comment);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Community Forum')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addComment,
                  child: Text('Post'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(_comments[index]),
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
