import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:school_attendance/config/app_colors.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.accent,
      error: AppColors.error,
      background: AppColors.backgroundLight,
      surface: AppColors.surfaceLight,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
      displayMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
      displaySmall: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      titleLarge: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      bodyLarge: GoogleFonts.roboto(
        color: AppColors.textDark,
      ),
      bodyMedium: GoogleFonts.roboto(
        color: AppColors.textDark,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primary,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: AppColors.surfaceLight,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceLight,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textLight.withOpacity(0.6),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.borderLight,
      thickness: 1,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.accent,
      error: AppColors.error,
      background: AppColors.backgroundDark,
      surface: AppColors.surfaceDark,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: AppColors.textLight,
      ),
      displayMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: AppColors.textLight,
      ),
      displaySmall: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: AppColors.textLight,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: AppColors.textLight,
      ),
      titleLarge: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: AppColors.textLight,
      ),
      bodyLarge: GoogleFonts.roboto(
        color: AppColors.textLight,
      ),
      bodyMedium: GoogleFonts.roboto(
        color: AppColors.textLight,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.textLight,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primary,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: AppColors.surfaceDark,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceDark,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textLight.withOpacity(0.6),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.borderDark,
      thickness: 1,
    ),
  );
}
