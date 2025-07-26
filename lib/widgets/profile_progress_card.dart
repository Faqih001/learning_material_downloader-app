import 'package:flutter/material.dart';

class ProfileProgressCard extends StatelessWidget {
  final String userName;
  final double progress; // 0.0 - 1.0

  const ProfileProgressCard({
    Key? key,
    required this.userName,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text('Progress'),
            SizedBox(height: 8),
            LinearProgressIndicator(value: progress),
            SizedBox(height: 8),
            Text('${(progress * 100).toStringAsFixed(1)}% completed'),
          ],
        ),
      ),
    );
  }
}
