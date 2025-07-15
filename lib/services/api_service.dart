
class ApiService {
  // Simulate fetching materials
  Future<List<Map<String, dynamic>>> fetchMaterials() async {
    await Future.delayed(const Duration(seconds: 1));
    // Return mock data
    return [
      {
        'id': '1',
        'title': 'Algebra Basics',
        'subject': 'Math',
        'description': 'Learn the basics of algebra.',
        'fileUrl': 'https://example.com/algebra.pdf',
        'rating': 4.5,
        'downloads': 120,
        'size': 1024,
        'uploaderId': 'u1',
        'tags': ['math', 'algebra'],
      },
      // Add more mock materials
    ];
  }

  // Simulate fetching libraries
  Future<List<Map<String, dynamic>>> fetchLibraries() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        'id': 'lib1',
        'name': 'Central Library',
        'address': '123 Main St',
        'hours': '9am - 6pm',
        'availableBooks': ['Algebra Basics', 'Physics 101'],
        'latitude': 3.139,
        'longitude': 101.6869,
        'distance': 1.2,
      },
      // Add more mock libraries
    ];
  }
}
