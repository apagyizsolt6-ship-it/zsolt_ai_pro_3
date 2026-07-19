// ===========================================
// ZSOLT AI PRO 3
// Version: v0.0.2
// File: lib/core/theme/app_colors.dart
// ===========================================

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ===== Elsődleges színek =====

  static const Color primary = Color(0xFF1976D2);
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color secondary = Color(0xFF29B6F6);

  // ===== Gradient =====

  static const Color gradientStart = Color(0xFF42A5F5);
  static const Color gradientMiddle = Color(0xFF1E88E5);
  static const Color gradientEnd = Color(0xFF1565C0);

  // ===== Háttér =====

  static const Color background = Color(0xFFF5F8FC);
  static const Color surface = Colors.white;
  static const Color card = Colors.white;

  // ===== Szövegek =====

  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);

  // ===== AI / Állapot =====

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFFF9800);
  static const Color danger = Color(0xFFE53935);
  static const Color info = Color(0xFF29B6F6);

  // ===== Egyéb =====

  static const Color divider = Color(0xFFE5E7EB);
  static const Color shadow = Color(0x14000000);

  // ===== AI Score =====

  static const Color aiExcellent = Color(0xFF22C55E);
  static const Color aiGood = Color(0xFF8BC34A);
  static const Color aiMedium = Color(0xFFFFC107);
  static const Color aiLow = Color(0xFFFF9800);
  static const Color aiBad = Color(0xFFE53935);

  // ===== League Colors =====

  static const Color premierLeague = Color(0xFF7B1FA2);
  static const Color laLiga = Color(0xFFE53935);
  static const Color serieA = Color(0xFF1E88E5);
  static const Color bundesliga = Color(0xFFD32F2F);
  static const Color ligue1 = Color(0xFF00897B);
  static const Color nb1 = Color(0xFF2E7D32);
}
