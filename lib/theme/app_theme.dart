import 'package:flutter/material.dart';

/// Cores e tema visual do aplicativo.
class AppTheme {
  AppTheme._();

  static const Color primaria = Color(0xFF6C3BFF);
  static const Color secundaria = Color(0xFFFF4D8D);
  static const Color fundo = Color(0xFFF4F1FF);

  /// Gradiente usado nas barras de topo e destaques.
  static const LinearGradient gradiente = LinearGradient(
    colors: [primaria, secundaria],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get tema {
    final cores = ColorScheme.fromSeed(
      seedColor: primaria,
      primary: primaria,
      secondary: secundaria,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: cores,
      scaffoldBackgroundColor: fundo,
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 3,
        shadowColor: primaria.withValues(alpha: 0.25),
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primaria.withValues(alpha: 0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaria, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cores.error),
        ),
        prefixIconColor: primaria,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: secundaria,
        foregroundColor: Colors.white,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF2E7D32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }
}
