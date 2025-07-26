import 'package:flutter/material.dart';

class AppNavBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  const AppNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<AppNavBar> createState() => _AppNavBarState();
}

class _AppNavBarState extends State<AppNavBar> {
  int? _hoveredIndex;

  static const List<_NavBarItemData> _items = [
    _NavBarItemData(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
    ),
    _NavBarItemData(
      icon: Icons.search_outlined,
      selectedIcon: Icons.search,
      label: 'Search',
    ),
    _NavBarItemData(
      icon: Icons.upload_file_outlined,
      selectedIcon: Icons.upload_file,
      label: 'Upload',
    ),
    _NavBarItemData(
      icon: Icons.smart_toy,
      selectedIcon: Icons.smart_toy,
      label: 'Chatbot',
    ),
    _NavBarItemData(
      icon: Icons.map_outlined,
      selectedIcon: Icons.map,
      label: 'Map',
    ),
    _NavBarItemData(
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (i) {
          final item = _items[i];
          final bool isSelected = widget.selectedIndex == i;
          final bool isHovered = _hoveredIndex == i;
          final Color bgColor =
              isSelected || isHovered
                  ? const Color(0xFF2563EB)
                  : Colors.transparent;
          final Color iconColor =
              isSelected || isHovered ? Colors.white : Colors.black54;
          final Color textColor =
              isSelected || isHovered ? Colors.white : Colors.black87;
          return Expanded(
            child: MouseRegion(
              onEnter: (_) => setState(() => _hoveredIndex = i),
              onExit: (_) => setState(() => _hoveredIndex = null),
              child: GestureDetector(
                onTap: () => widget.onItemTapped(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: 68,
                  color: bgColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isSelected ? item.selectedIcon : item.icon,
                        color: iconColor,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: textColor,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavBarItemData {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  const _NavBarItemData({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
