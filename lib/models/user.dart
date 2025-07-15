class User {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final int downloads;
  final int uploads;
  final double rating;
  final List<String> achievements;
  final List<String> recentActivity;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    this.downloads = 0,
    this.uploads = 0,
    this.rating = 0.0,
    this.achievements = const [],
    this.recentActivity = const [],
  });
}
