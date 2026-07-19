// ===========================================
// ZSOLT AI PRO 3
// Version: v0.3.3
// File: lib/screens/matches/widgets/filter_bar.dart
// ===========================================

import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const FilterBar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const List<_FilterItem> _filters = [
    _FilterItem(Icons.public, "Összes"),
    _FilterItem(Icons.psychology, "AI"),
    _FilterItem(Icons.trending_up, "Value"),
    _FilterItem(Icons.star, "Kedvencek"),
    _FilterItem(Icons.live_tv, "Élő"),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final selected = index == selectedIndex;
          final item = _filters[index];

          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => onSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF1976D2)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF1976D2)
                      : Colors.grey.shade300,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.icon,
                    size: 18,
                    color: selected
                        ? Colors.white
                        : Colors.black87,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FilterItem {
  final IconData icon;
  final String label;

  const _FilterItem(this.icon, this.label);
}
