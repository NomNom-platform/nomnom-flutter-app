import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Core brand colors
  static const Color primary = Color(0xFFAB3500);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFFF6B35);
  static const Color onPrimaryContainer = Color(0xFF5F1900);
  
  // Secondary brand colors (health/success)
  static const Color secondary = Color(0xFF006A62);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFF70F8E8);
  static const Color onSecondaryContainer = Color(0xFF007168);
  
  // Tertiary colors (accents/warnings)
  static const Color tertiary = Color(0xFF785A00);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFBC942F);
  static const Color onTertiaryContainer = Color(0xFF412F00);
  
  // Error colors
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
  
  // Surfaces and Backgrounds
  static const Color background = Color(0xFFF7F9FF);
  static const Color onBackground = Color(0xFF181C20);
  
  static const Color surface = Color(0xFFF7F9FF);
  static const Color onSurface = Color(0xFF181C20);
  static const Color surfaceVariant = Color(0xFFE0E3E8);
  static const Color onSurfaceVariant = Color(0xFF594139);
  
  // Outline
  static const Color outline = Color(0xFF8D7168);
  static const Color outlineVariant = Color(0xFFE1BFB5);
  
  // Custom fixed/dim colors for gradients/special states
  static const Color primaryFixed = Color(0xFFFFDBD0);
  static const Color primaryFixedDim = Color(0xFFFFB59D);
  static const Color tertiaryFixed = Color(0xFFFFDF9B);
  static const Color tertiaryFixedDim = Color(0xFFEDC157);
}
