import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color accent = Color(0xFFE91E63);
  static const Color background = Color(0xFFF2F2F2);
  static const Color columnHeader = Color(0xFF1976D2);
  static const Color columnBody = Color(0xFFEEEEEE);
  static const Color error = Color(0xFFD32F2F);
  static const Color destructive = Color(0xFFFE4A49);
  static const Color info = Color(0xFF21B7CA);
  static const Color archive = Color(0xFF7BC043);
  static const Color save = Color(0xFF0392CF);
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accent),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}
