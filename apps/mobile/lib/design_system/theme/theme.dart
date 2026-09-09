import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

ThemeData noryvaTheme({Brightness brightness = Brightness.light}) {
  final dark = brightness == Brightness.dark;
  final scheme =
      ColorScheme.fromSeed(
        seedColor: NoryvaColors.primary,
        brightness: brightness,
      ).copyWith(
        primary: dark ? NoryvaColors.darkPrimary : NoryvaColors.primary,
        onPrimary: dark ? NoryvaColors.darkBackground : NoryvaColors.surface,
        primaryContainer: dark
            ? NoryvaColors.darkPrimarySoft
            : NoryvaColors.primarySoft,
        onPrimaryContainer: dark
            ? NoryvaColors.darkPrimary
            : NoryvaColors.primaryDark,
        surface: dark ? NoryvaColors.darkSurface : NoryvaColors.surface,
        onSurface: dark ? NoryvaColors.darkText : NoryvaColors.text,
        onSurfaceVariant: dark
            ? NoryvaColors.darkTextSecondary
            : NoryvaColors.textSecondary,
        outline: dark ? NoryvaColors.darkBorder : NoryvaColors.border,
        outlineVariant: dark ? NoryvaColors.darkBorder : NoryvaColors.border,
        error: dark ? NoryvaColors.darkError : NoryvaColors.error,
      );
  final background = dark
      ? NoryvaColors.darkBackground
      : NoryvaColors.background;
  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
  );
  return base.copyWith(
    scaffoldBackgroundColor: background,
    textTheme: base.textTheme.copyWith(
      displaySmall: NoryvaType.calorie.copyWith(color: scheme.onSurface),
      headlineMedium: NoryvaType.headline.copyWith(color: scheme.onSurface),
      titleLarge: NoryvaType.title.copyWith(color: scheme.onSurface),
      titleMedium: NoryvaType.label.copyWith(
        fontSize: 16,
        color: scheme.onSurface,
      ),
      bodyLarge: NoryvaType.body.copyWith(color: scheme.onSurface),
      bodyMedium: NoryvaType.body.copyWith(
        fontSize: 14,
        color: scheme.onSurface,
      ),
      bodySmall: NoryvaType.small.copyWith(color: scheme.onSurfaceVariant),
      labelLarge: NoryvaType.label.copyWith(color: scheme.onSurface),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: NoryvaType.title.copyWith(color: scheme.onSurface),
    ),
    cardTheme: CardThemeData(
      color: scheme.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(NoryvaRadius.card),
        side: BorderSide(color: scheme.outlineVariant),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant,
      thickness: 1,
      space: 24,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surface,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(NoryvaRadius.control),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(NoryvaRadius.control),
        borderSide: BorderSide(color: scheme.outline),
      ),
    ),
    searchBarTheme: SearchBarThemeData(
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStatePropertyAll(scheme.surface),
      side: WidgetStatePropertyAll(BorderSide(color: scheme.outlineVariant)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NoryvaRadius.control),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 52),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NoryvaRadius.control),
        ),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surface,
      indicatorColor: scheme.primaryContainer,
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
