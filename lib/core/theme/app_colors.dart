import 'package:flutter/material.dart';

class AppColors {
  static const Color gradientStart = Color(0xFF4A90E2);
  static const Color gradientEnd = Color(0xFF87CEEB);
  static const Color white = Colors.white;
  static LinearGradient sunny = const LinearGradient(
    colors: [Color(0xFFFFC371), Color(0xFFFFA751)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient rainy = const LinearGradient(
    colors: [Color(0xFF4A90E2), Color(0xFF87CEEB)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
