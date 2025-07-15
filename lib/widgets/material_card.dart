import 'package:flutter/material.dart';
import '../models/material.dart';

class MaterialCard extends StatelessWidget {
  final LearningMaterial material;
  final VoidCallback? onDownload;
  const MaterialCard({super.key, required this.material, this.onDownload});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.insert_drive_file, color: Colors.blue[700]),
        title: Text(material.title),
        subtitle: Text('${material.subject} • ${material.size} KB'),
        trailing: IconButton(
          icon: const Icon(Icons.download),
          onPressed: onDownload,
        ),
      ),
    );
  }
}
