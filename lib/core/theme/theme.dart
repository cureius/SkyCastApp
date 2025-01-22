import 'package:flutter/material.dart';
import 'package:sky_cast/core/theme/app_pallete.dart';

class AppTheme {
  static OutlineInputBorder border(
      [Color color = AppPalette.lightBorderColor]) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: 3,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }

  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPalette.lightBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.lightBackgroundColor,
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: AppPalette.lightBackgroundColor,
      side: BorderSide.none,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      border: border(),
      enabledBorder: border(),
      focusedBorder: border(AppPalette.lightGradient2),
      errorBorder: border(AppPalette.lightErrorColor),
    ),
  );

  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPalette.darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.darkBackgroundColor,
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: AppPalette.darkBackgroundColor,
      side: BorderSide.none,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      border: border(AppPalette.darkBorderColor),
      enabledBorder: border(AppPalette.darkBorderColor),
      focusedBorder: border(AppPalette.darkGradient2),
      errorBorder: border(AppPalette.darkErrorColor),
    ),
  );
}
