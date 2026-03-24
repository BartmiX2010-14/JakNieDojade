import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Jasny motyw (Premium Aurora)
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: const Color(0xFF6366F1), // Indigo
    scaffoldBackgroundColor: const Color(0xFFF1F5F9), 
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6366F1),
      primary: const Color(0xFF6366F1),
      secondary: const Color(0xFF8B5CF6),
      surface: Colors.white,
      background: const Color(0xFFF1F5F9),
    ),
    textTheme: GoogleFonts.outfitTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(color: Color(0xFF0F172A), fontSize: 22, fontWeight: FontWeight.w800),
      iconTheme: IconThemeData(color: Color(0xFF0F172A)),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      color: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );

  // Ciemny motyw (Ultra-Premium Obsidian)
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF818CF8),
    scaffoldBackgroundColor: const Color(0xFF020617), // Very Deep Blue
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF818CF8),
      secondary: Color(0xFFC084FC),
      surface: Color(0xFF0F172A),
      background: Color(0xFF020617),
      onPrimary: Colors.white,
      onSurface: Color(0xFFF1F5F9),
    ),
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Colors.white.withOpacity(0.05)),
      ),
      color: const Color(0xFF0F172A),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: const Color(0xFF6366F1).withOpacity(0.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}
