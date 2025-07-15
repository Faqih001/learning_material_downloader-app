class Library {
  final String id;
  final String name;
  final String address;
  final String hours;
  final List<String> availableBooks;
  final double latitude;
  final double longitude;
  final double distance;

  Library({
    required this.id,
    required this.name,
    required this.address,
    required this.hours,
    required this.availableBooks,
    required this.latitude,
    required this.longitude,
    this.distance = 0.0,
  });
}
