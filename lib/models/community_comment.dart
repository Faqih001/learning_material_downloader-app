class CommunityComment {
  final String id;
  final String comment;
  final DateTime createdAt;

  CommunityComment({
    required this.id,
    required this.comment,
    required this.createdAt,
  });

  factory CommunityComment.fromMap(Map<String, dynamic> map) {
    return CommunityComment(
      id: map['id'] as String,
      comment: map['comment'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
