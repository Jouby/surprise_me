import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF1A3A5C);
  static const Color primaryLight = Color(0xFF2E6DA4);
  static const Color accent = Color(0xFF4A9FD4);
  static const Color accentLight = Color(0xFFADD8F0);
  static const Color surface = Color(0xFFF0F7FF);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF0D2035);
  static const Color textMid = Color(0xFF4A6580);
  static const Color textLight = Color(0xFF8AAABF);
  static const Color divider = Color(0xFFD6E8F5);
  static const Color blurOverlay = Color(0xFFE8F3FB);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
          surface: surface,
        ),
        scaffoldBackgroundColor: surface,
        textTheme: GoogleFonts.dmSansTextTheme().copyWith(
          displayLarge: GoogleFonts.dmSerifDisplay(
            color: textDark,
            fontWeight: FontWeight.w400,
          ),
          headlineMedium: GoogleFonts.dmSerifDisplay(
            color: textDark,
            fontWeight: FontWeight.w400,
          ),
          titleLarge: GoogleFonts.dmSans(
            color: textDark,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: GoogleFonts.dmSans(
            color: textDark,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: GoogleFonts.dmSans(color: textMid),
          bodyMedium: GoogleFonts.dmSans(color: textMid),
          labelLarge: GoogleFonts.dmSans(
            color: cardBg,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: surface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: GoogleFonts.dmSerifDisplay(
            color: textDark,
            fontSize: 22,
          ),
          iconTheme: const IconThemeData(color: textDark),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: cardBg,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: divider, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: divider, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryLight, width: 2),
          ),
          hintStyle: GoogleFonts.dmSans(color: textLight),
          labelStyle: GoogleFonts.dmSans(color: textMid),
        ),
      );
}
