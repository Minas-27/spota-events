import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: const Color(0xFF2563EB),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF2563EB),
        secondary: Color(0xFF10B981),
        surface: Color(0xFFF8FAFC),
      ),
      fontFamily: GoogleFonts.poppins().fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: const Color(0xFF2563EB),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF2563EB),
        secondary: Color(0xFF10B981),
        surface: Color(0xFF0F172A),
      ),
      fontFamily: GoogleFonts.poppins().fontFamily,
    );
  }
}