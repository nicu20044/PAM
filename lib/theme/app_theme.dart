import 'package:flutter/material.dart';

class AppColors {
  static const ink = Color(0xFF1A1A1C);
  static const dark = Color(0xFF2E2E31);
  static const green = Color(0xFF5B8372);
  static const grey = Color(0xFF9B9BA3);
  static const light = Color(0xFFF7F7F9);
  static const line = Color(0xFFEDEDF0);
  static const body = Color(0xFF55555C);
  static const cream = Color(0xFFFBF6F1);
  static const placeholder = Color(0xFFEDEDF0);
}

String money(double v) => '\$ ${v.toStringAsFixed(2)}';

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: AppColors.dark,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),
  );
}