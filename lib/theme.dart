import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const brown       = Color(0xFF6B2D0E);
  static const darkBrown   = Color(0xFF2C1810);
  static const lightBrown  = Color(0xFF8B5E3C);
  static const cream       = Color(0xFFFFF8F0);
  static const softCream   = Color(0xFFFFF0E6);
  static const border      = Color(0xFFE8D5C0);
  static const sand        = Color(0xFFD4A882);
  static const gold        = Color(0xFFF5A623);
  static const green       = Color(0xFF2C7A4B);
  static const red         = Color(0xFFC0392B);
  static const whatsapp    = Color(0xFF25D366);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brown,
      background: AppColors.cream,
    ),
    scaffoldBackgroundColor: AppColors.cream,
    textTheme: GoogleFonts.latoTextTheme().copyWith(
      displayLarge: GoogleFonts.playfairDisplay(color: AppColors.darkBrown, fontWeight: FontWeight.w700),
      displayMedium: GoogleFonts.playfairDisplay(color: AppColors.brown, fontWeight: FontWeight.w700),
      headlineLarge: GoogleFonts.playfairDisplay(color: AppColors.brown, fontWeight: FontWeight.w700),
      headlineMedium: GoogleFonts.playfairDisplay(color: AppColors.brown),
      headlineSmall: GoogleFonts.playfairDisplay(color: AppColors.darkBrown),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brown,
        foregroundColor: AppColors.cream,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: GoogleFonts.lato(fontWeight: FontWeight.w700, letterSpacing: 1.2, fontSize: 13),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.brown,
        side: const BorderSide(color: AppColors.brown, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: GoogleFonts.lato(fontWeight: FontWeight.w700, letterSpacing: 1.2, fontSize: 13),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFFFFDF9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppColors.sand),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppColors.sand, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppColors.brown, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.cream,
      foregroundColor: AppColors.darkBrown,
      elevation: 0,
      titleTextStyle: GoogleFonts.playfairDisplay(
        color: AppColors.brown,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppColors.border),
      ),
    ),
  );
}