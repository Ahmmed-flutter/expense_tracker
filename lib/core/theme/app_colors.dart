import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF00C853);
  static const Color secondary = Color(0xFF2979FF);
  static const Color background = Color(0xFFF8F9FE);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFD32F2F);
  
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  
  static const Color cardGradientStart = Color(0xFF1B5E20);
  static const Color cardGradientEnd = Color(0xFF4CAF50);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [cardGradientStart, cardGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
}
