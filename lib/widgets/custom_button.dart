import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isLoading;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 400;
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : onPressed,
            icon:
                icon != null
                    ? Icon(icon, size: isWide ? 26 : 20)
                    : const SizedBox.shrink(),
            label:
                isLoading
                    ? SizedBox(
                      width: isWide ? 26 : 20,
                      height: isWide ? 26 : 20,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : Text(label, style: TextStyle(fontSize: isWide ? 18 : 15)),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isPrimary ? const Color(0xFF2563EB) : Colors.grey[300],
              foregroundColor: isPrimary ? Colors.white : Colors.black,
              padding: EdgeInsets.symmetric(
                vertical: isWide ? 20 : 16,
                horizontal: isWide ? 32 : 24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isWide ? 12 : 8),
              ),
              textStyle: TextStyle(fontSize: isWide ? 18 : 15),
              elevation: isWide ? 4 : 2,
            ),
          ),
        );
      },
    );
  }
}
