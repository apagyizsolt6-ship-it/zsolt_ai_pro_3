// ===========================================
// ZSOLT AI PRO 3
// Version: v0.3.1
// File: lib/screens/matches/widgets/search_bar.dart
// ===========================================

import 'package:flutter/material.dart';

class MatchesSearchBar extends StatelessWidget {
  const MatchesSearchBar({
    super.key,
    this.onChanged,
  });

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: "Csapat vagy bajnokság keresése...",
        prefixIcon: const Icon(
          Icons.search,
          color: Color(0xFF1976D2),
        ),
        suffixIcon: const Icon(
          Icons.tune,
          color: Colors.grey,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFF1976D2),
            width: 2,
          ),
        ),
      ),
    );
  }
}
