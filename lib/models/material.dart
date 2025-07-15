class LearningMaterial {
  final String id;
  final String title;
  final String subject;
  final String description;
  final String fileUrl;
  final double rating;
  final int downloads;
  final int size;
  final String uploaderId;
  final List<String> tags;

  LearningMaterial({
    required this.id,
    required this.title,
    required this.subject,
    required this.description,
    required this.fileUrl,
    this.rating = 0.0,
    this.downloads = 0,
    this.size = 0,
    required this.uploaderId,
    this.tags = const [],
  });
}
