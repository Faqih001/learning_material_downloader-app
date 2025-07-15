import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        backgroundColor: const Color(0xFF2563EB),
      ),
      body: Center(child: Text('Map Screen')),
    );
  }
}
