import 'dart:io';

class StorageService {
  // Simulate file upload
  Future<String> uploadFile(File file) async {
    await Future.delayed(const Duration(seconds: 2));
    return 'https://example.com/files/${file.path.split('/').last}';
  }

  // Simulate file download
  Future<bool> downloadFile(String url) async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }
}
