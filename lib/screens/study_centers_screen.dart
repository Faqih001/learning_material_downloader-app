import 'package:flutter/material.dart';

class StudyCenter {
  final String name;
  final String city;
  final String address;
  final String description;

  StudyCenter({
    required this.name,
    required this.city,
    required this.address,
    required this.description,
  });
}

final List<StudyCenter> studyCenters = [
  StudyCenter(
    name: 'Lagos Study Center',
    city: 'Lagos',
    address: '123 Allen Avenue, Ikeja',
    description: 'A modern study center in Lagos with free WiFi and resources.',
  ),
  StudyCenter(
    name: 'Abuja Study Center',
    city: 'Abuja',
    address: '456 Central Area, Abuja',
    description: 'Spacious center with group study rooms and a library.',
  ),
  StudyCenter(
    name: 'Kano Study Center',
    city: 'Kano',
    address: '789 Zaria Road, Kano',
    description: 'Well-equipped center for collaborative learning.',
  ),
];

class StudyCentersScreen extends StatelessWidget {
  const StudyCentersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Study Centers')),
      body: ListView.builder(
        itemCount: studyCenters.length,
        itemBuilder: (context, index) {
          final center = studyCenters[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(center.name),
              subtitle: Text(
                '${center.city}\n${center.address}\n${center.description}',
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
