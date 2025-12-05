import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App theme configuration with calm, aesthetic colors
class AppTheme {
  // Light mode color palette - soft, calming tones
  static const Color primaryColor = Color(0xFF8B9D83); // Soft sage green
  static const Color secondaryColor = Color(0xFFE8DCC4); // Warm beige
  static const Color accentColor = Color(0xFFC5B3D5); // Soft lavender
  static const Color backgroundColor = Color(0xFFFAF8F5); // Off-white
  static const Color surfaceColor = Color(0xFFFFFFFF); // Pure white
  static const Color textPrimary = Color(0xFF2C2C2C); // Charcoal
  static const Color textSecondary = Color(0xFF6B6B6B); // Gray
  static const Color timerActive = Color(0xFF7A8F72); // Darker sage
  
  // Dark mode color palette - calm, muted dark tones
  static const Color darkPrimaryColor = Color(0xFF9FB396); // Lighter sage for contrast
  static const Color darkSecondaryColor = Color(0xFF6B5D4F); // Muted brown
  static const Color darkAccentColor = Color(0xFFB5A0C8); // Muted lavender
  static const Color darkBackgroundColor = Color(0xFF1A1A1A); // Deep charcoal
  static const Color darkSurfaceColor = Color(0xFF2D2D2D); // Dark gray
  static const Color darkTextPrimary = Color(0xFFE8E8E8); // Off-white text
  static const Color darkTextSecondary = Color(0xFFB0B0B0); // Light gray
  static const Color darkTimerActive = Color(0xFFA8BDA0); // Lighter sage for visibility
  
  /// Creates the light theme for the app
  static ThemeData get lightTheme {
    return _buildTheme(
      brightness: Brightness.light,
      primary: primaryColor,
      secondary: secondaryColor,
      accent: accentColor,
      background: backgroundColor,
      surface: surfaceColor,
      textPrimary: textPrimary,
      textSecondary: textSecondary,
    );
  }
  
  /// Creates the dark theme for the app
  static ThemeData get darkTheme {
    return _buildTheme(
      brightness: Brightness.dark,
      primary: darkPrimaryColor,
      secondary: darkSecondaryColor,
      accent: darkAccentColor,
      background: darkBackgroundColor,
      surface: darkSurfaceColor,
      textPrimary: darkTextPrimary,
      textSecondary: darkTextSecondary,
    );
  }
  
  /// Build theme with given colors
  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primary,
    required Color secondary,
    required Color accent,
    required Color background,
    required Color surface,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        secondary: secondary,
        surface: surface,
        onSurface: textPrimary,
        tertiary: accent,
        onPrimary: brightness == Brightness.light ? Colors.white : darkBackgroundColor,
        onSecondary: brightness == Brightness.light ? textPrimary : darkTextPrimary,
        error: brightness == Brightness.light ? const Color(0xFFD32F2F) : const Color(0xFFEF5350),
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: background,
      
      // Typography using Google Fonts
      textTheme: TextTheme(
        displayLarge: GoogleFonts.raleway(
          fontSize: 72,
          fontWeight: FontWeight.w300,
          letterSpacing: -1.5,
          color: textPrimary,
        ),
        displayMedium: GoogleFonts.raleway(
          fontSize: 56,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5,
          color: textPrimary,
        ),
        displaySmall: GoogleFonts.raleway(
          fontSize: 48,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        headlineLarge: GoogleFonts.raleway(
          fontSize: 34,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.raleway(
          fontSize: 28,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.raleway(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: textPrimary,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          color: textPrimary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
          color: textPrimary,
        ),
      ),
      
      // Card theme
      cardTheme: CardTheme(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(brightness == Brightness.light ? 0.1 : 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: surface,
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: brightness == Brightness.light ? Colors.white : darkBackgroundColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      // Icon theme
      iconTheme: IconThemeData(
        color: primary,
        size: 24,
      ),
    );
  }
}
