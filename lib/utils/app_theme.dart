import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors from logo
  static const Color cream = Color(0xFFF5E6C8);
  static const Color warmBrown = Color(0xFF6B3A2A);
  static const Color darkBrown = Color(0xFF3D1F10);
  static const Color caramel = Color(0xFFB8733A);
  static const Color gold = Color(0xFFD4A853);
  static const Color lightCream = Color(0xFFFAF3E0);
  static const Color accent = Color(0xFF8B4513);
  static const Color textDark = Color(0xFF2C1A0E);
  static const Color textMid = Color(0xFF5C3317);
  static const Color cardBg = Color(0xFFFFF8EC);
  static const Color border = Color(0xFFD4B896);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: warmBrown,
        secondary: caramel,
        tertiary: gold,
        background: lightCream,
        surface: cardBg,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: textDark,
        onSurface: textDark,
      ),
      scaffoldBackgroundColor: lightCream,
      fontFamily: 'Cairo',
      appBarTheme: const AppBarTheme(
        backgroundColor: warmBrown,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: warmBrown,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 3,
        shadowColor: warmBrown.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border.withOpacity(0.5), width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: warmBrown, width: 2),
        ),
        labelStyle: const TextStyle(color: textMid, fontFamily: 'Cairo'),
        hintStyle: TextStyle(color: textMid.withOpacity(0.6), fontFamily: 'Cairo'),
      ),
    );
  }
}
