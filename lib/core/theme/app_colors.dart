import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFFE91E63); // Signature Pink
  static const Color primaryLight = Color(0xFFF06292);
  static const Color primaryDark = Color(0xFFC2185B);

  // Accent/Secondary
  static const Color accent = Color(0xFF9C27B0); // Deep Purple
  static const Color accentLight = Color(0xFFBA68C8);

  // Neutral Colors
  static const Color background = Color(0xFFFBFBFD); // Elite gray-white
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1D1D1F); // Apple-style dark gray
  static const Color textSecondary = Color(0xFF6E6E73);
  static const Color divider = Color(0xFFE5E5E7);
  static const Color border = Color(0xFFD1D1D6);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFB300);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
