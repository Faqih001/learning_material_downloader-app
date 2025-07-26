import 'package:flutter/material.dart';
import '../models/material.dart';

class MaterialCard extends StatelessWidget {
  final LearningMaterial material;
  final VoidCallback? onDownload;
  const MaterialCard({super.key, required this.material, this.onDownload});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 400;
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Card(
            margin: EdgeInsets.symmetric(
              vertical: isWide ? 14 : 8,
              horizontal: isWide ? 8 : 4,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isWide ? 18 : 12),
            ),
            elevation: isWide ? 6 : 2,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: isWide ? 18 : 8,
                horizontal: isWide ? 18 : 8,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.insert_drive_file,
                    color: Colors.blue[700],
                    size: isWide ? 38 : 28,
                  ),
                  SizedBox(width: isWide ? 18 : 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          material.title,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontSize: isWide ? 18 : 15,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: isWide ? 8 : 4),
                        Text(
                          '${material.subject} • ${material.size} KB',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            fontSize: isWide ? 15 : 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: isWide ? 18 : 8),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: IconButton(
                      icon: Icon(Icons.download, size: isWide ? 28 : 22),
                      color: const Color(0xFF2563EB),
                      onPressed: onDownload,
                      tooltip: 'Download',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
