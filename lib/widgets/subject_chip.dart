import 'package:flutter/material.dart';

class SubjectChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  const SubjectChip({super.key, required this.label, this.selected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        backgroundColor: selected ? const Color(0xFF2563EB) : Colors.grey[200],
        labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }
}
