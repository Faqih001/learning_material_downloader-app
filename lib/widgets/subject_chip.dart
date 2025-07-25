import 'package:flutter/material.dart';

class SubjectChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  const SubjectChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 400;
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: Chip(
              label: Text(label, style: TextStyle(fontSize: isWide ? 16 : 14)),
              backgroundColor: selected ? const Color(0xFF2563EB) : Colors.grey[200],
              labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
              padding: EdgeInsets.symmetric(horizontal: isWide ? 18 : 12, vertical: isWide ? 8 : 4),
              elevation: isWide && selected ? 4 : 0,
              side: selected ? BorderSide(color: const Color(0xFF2563EB), width: 1.5) : null,
            ),
          ),
        );
      },
    );
  }
}
