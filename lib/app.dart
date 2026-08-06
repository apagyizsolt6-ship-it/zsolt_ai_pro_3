// ===========================================
// ZSOLT AI PRO 3
// Version: v0.1.0
// File: lib/app.dart
// ===========================================

import 'package:flutter/material.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash_screen.dart';

class ZsoltAiProApp extends StatelessWidget {
  const ZsoltAiProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
