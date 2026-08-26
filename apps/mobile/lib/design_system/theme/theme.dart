import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

ThemeData noryvaTheme() => ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: NoryvaColors.background,
  colorScheme: ColorScheme.fromSeed(
    seedColor: NoryvaColors.primary,
    surface: NoryvaColors.surface,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: NoryvaColors.text),
    bodySmall: TextStyle(color: NoryvaColors.textSecondary),
  ),
  cardTheme: const CardThemeData(
    color: NoryvaColors.surface,
    margin: EdgeInsets.zero,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(minimumSize: const Size(48, 52)),
  ),
);
