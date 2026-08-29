import 'package:flutter/material.dart';

/// App-wide color palette adhering to the dark cinema aesthetic.
class AppColors {
  AppColors._();

  // Main background dark theme colors
  static const Color background = Color(0xFF0D0F14);
  static const Color surface = Color(0xFF161922);
  static const Color surfaceLight = Color(0xFF202532);
  static const Color cardBackground = Color(0xFF1C202C);

  // Accent & Brand Colors
  static const Color primary = Color(0xFFE50914); // Netflix / Crimson Red
  static const Color primaryGradientEnd = Color(0xFFFF3E3D);
  static const Color secondary = Color(0xFF6C5CE7); // Purple accent
  static const Color accentCyan = Color(0xFF00CEC9); // Cyan accent

  // Neutral colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A7B5);
  static const Color textMuted = Color(0xFF6C7584);
  static const Color border = Color(0xFF2A2F3D);

  // Status & Utility Colors
  static const Color starRating = Color(0xFFFFC107);
  static const Color error = Color(0xFFFF5252);
  static const Color success = Color(0xFF4CAF50);
  static const Color shimmerBase = Color(0xFF1E222D);
  static const Color shimmerHighlight = Color(0xFF2A3040);

  // Bottom Navigation Colors
  static const Color activeBottomIconColor = Color(0xFFFFFFFF);
  static const Color inactiveBottomIconColor = Color(0xFF8C8787);

  // Search Bar
  static const Color searchBarBg = Color(0xFF424242);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryGradientEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient heroOverlayGradient = LinearGradient(
    colors: [
      Colors.transparent,
      Color(0x800D0F14),
      Color(0xFF0D0F14),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
