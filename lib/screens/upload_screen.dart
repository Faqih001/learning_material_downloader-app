import 'package:flutter/material.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload'),
        backgroundColor: const Color(0xFF2563EB),
      ),
      body: Center(
        child: Text('Upload Screen'),
      ),
    );
  }
}
