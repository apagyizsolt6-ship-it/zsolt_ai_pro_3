// ===========================================
// ZSOLT AI PRO 3
// Version: v0.3.2
// File: lib/screens/matches/widgets/day_selector.dart
// ===========================================

import 'package:flutter/material.dart';

class DaySelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const DaySelector({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const List<String> _days = [
    "Ma",
    "Holnap",
    "Kedd",
    "Szerda",
    "Csüt.",
    "Péntek",
    "Szombat",
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final selected = index == selectedIndex;

          return GestureDetector(
            onTap: () => onSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF1976D2)
                    : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _days[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: selected
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
