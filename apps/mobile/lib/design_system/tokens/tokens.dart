import 'package:flutter/material.dart';

abstract final class NoryvaColors {
  static const background = Color(0xFFF7F9F7);
  static const surface = Color(0xFFFFFFFF);
  static const primary = Color(0xFF167A5A);
  static const primaryDark = Color(0xFF105B44);
  static const primarySoft = Color(0xFFDDF3E9);
  static const text = Color(0xFF17201D);
  static const textSecondary = Color(0xFF5E6B66);
  static const border = Color(0xFFDCE4E0);
  static const error = Color(0xFFB42318);
  static const warning = Color(0xFF875A12);
  static const success = primary;

  static const darkBackground = Color(0xFF111916);
  static const darkSurface = Color(0xFF1B2621);
  static const darkPrimary = Color(0xFF83D9B3);
  static const darkPrimarySoft = Color(0xFF263E33);
  static const darkText = Color(0xFFEDF3EF);
  static const darkTextSecondary = Color(0xFFAFBDB5);
  static const darkBorder = Color(0xFF3A4C42);
  static const darkError = Color(0xFFFFB4AB);
  static const darkWarning = Color(0xFFE8C17A);
  static const darkSuccess = darkPrimary;
}

abstract final class NoryvaSpace {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

abstract final class NoryvaRadius {
  static const card = 24.0;
  static const control = 16.0;
}

abstract final class NoryvaType {
  static const calorie = TextStyle(
    fontSize: 48,
    height: 1.1,
    fontWeight: FontWeight.w600,
    letterSpacing: -2,
  );
  static const headline = TextStyle(
    fontSize: 28,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: -.7,
  );
  static const title = TextStyle(
    fontSize: 20,
    height: 1.3,
    fontWeight: FontWeight.w600,
  );
  static const body = TextStyle(fontSize: 16, height: 1.45);
  static const small = TextStyle(fontSize: 13, height: 1.4);
  static const label = TextStyle(
    fontSize: 14,
    height: 1.3,
    fontWeight: FontWeight.w600,
  );
}
