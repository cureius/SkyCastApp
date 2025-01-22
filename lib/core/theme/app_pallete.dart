import 'package:flutter/material.dart';

class AppPalette {
  static Color backgroundColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkBackgroundColor
          : lightBackgroundColor;

  static Color onBackgroundColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkOnBackgroundColor
          : lightOnBackgroundColor;

  static Color gradient1(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkGradient1
          : lightGradient1;

  static Color gradient2(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkGradient2
          : lightGradient2;

  static Color gradient3(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkGradient3
          : lightGradient3;

  static Color borderColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkBorderColor
          : lightBorderColor;

  static Color cardColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkCardColor
          : lightCardColor;

  static Color whiteColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkWhiteColor
          : lightWhiteColor;

  static Color greyColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkGreyColor
          : lightGreyColor;

  static Color errorColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkErrorColor
          : lightErrorColor;

  static Color transparentColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkTransparentColor
          : lightTransparentColor;

  //light theme colors
  static const Color lightBackgroundColor = Colors.white;
  static const Color lightOnBackgroundColor = Colors.black;
  static const Color lightGradient1 = Color.fromRGBO(180, 40, 221, 1.0);
  static const Color lightGradient2 = Color.fromRGBO(251, 109, 169, 1);
  static const Color lightGradient3 = Color.fromRGBO(255, 159, 124, 1);
  static const Color lightBorderColor = Color.fromRGBO(52, 51, 67, 1);
  static const Color lightCardColor =
      Color.fromRGBO(55, 46, 255, 0.2980392156862745);
  static const Color lightWhiteColor = Colors.white;
  static const Color lightGreyColor = Colors.grey;
  static const Color lightErrorColor = Colors.redAccent;
  static const Color lightTransparentColor = Colors.transparent;

  //dark theme colors
  static const Color darkBackgroundColor = Color.fromRGBO(5, 5, 7, 1.0);
  static const Color darkOnBackgroundColor = Color.fromRGBO(248, 248, 255, 1.0);
  static const Color darkGradient1 = Color.fromRGBO(194, 77, 227, 1.0);
  static const Color darkGradient2 = Color.fromRGBO(251, 109, 169, 1);
  static const Color darkGradient3 = Color.fromRGBO(255, 159, 124, 1);
  static const Color darkBorderColor = Color.fromRGBO(52, 51, 67, 1);
  static const Color darkCardColor =
      Color.fromRGBO(58, 56, 92, 0.2980392156862745);
  static const Color darkWhiteColor = Colors.white;
  static const Color darkGreyColor = Colors.grey;
  static const Color darkErrorColor = Colors.redAccent;
  static const Color darkTransparentColor = Colors.transparent;
}