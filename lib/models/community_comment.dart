class CommunityComment {
  final String id;
  final String comment;
  final String name; // Name of the poster
  final DateTime createdAt;
  final Map<String, int> reactions; // Emoji reactions

  CommunityComment({
    required this.id,
    required this.comment,
    required this.name,
    required this.createdAt,
    this.reactions = const {},
  });

  factory CommunityComment.fromMap(Map<String, dynamic> map) {
    return CommunityComment(
      id: map['id'].toString(),
      comment: map['comment'].toString(),
      name: map['name']?.toString() ?? 'Anonymous',
      createdAt: DateTime.parse(map['created_at'].toString()),
      reactions:
          (map['reactions'] is Map)
              ? Map<String, int>.from(map['reactions'])
              : {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'comment': comment,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'reactions': reactions,
    };
  }
}
