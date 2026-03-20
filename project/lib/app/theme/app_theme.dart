import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const base = Color(0xFFF4EFE5);
  const ink = Color(0xFF1F2A37);
  const accent = Color(0xFF0F766E);

  final scheme = ColorScheme.fromSeed(
    seedColor: accent,
    brightness: Brightness.light,
    surface: Colors.white,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: base,
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: ink,
        height: 1.05,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF455468), height: 1.5),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Color(0xFF5B667A),
        height: 1.45,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: accent,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: const BorderSide(color: Color(0xFFE7DECE)),
      ),
    ),
  );
}
