import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'custom_border.dart';

class CustomThemes {
  static final ThemeData darkTheme = ThemeData(
      tooltipTheme: const TooltipThemeData(
          textStyle: TextStyle(fontSize: 8.0, color: Colors.black)),
      dialogTheme: const DialogTheme(
          backgroundColor: Color(0xFF1A1A1A),
          contentTextStyle: TextStyle(
              height: 1.5,
              fontFamily: "PressStart2P",
              fontSize: 8.5,
              color: Colors.white)),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color.fromRGBO(36, 36, 62, 1),
        shape: CustomBorder(),
      ),
      primaryColor: const Color.fromRGBO(36, 36, 62, 1),
      fontFamily: "PressStart2P",
      textTheme: const TextTheme(
          labelLarge: TextStyle(fontSize: 8.5),
          titleMedium: TextStyle(fontSize: 8.5, height: 1.5),
          titleLarge: TextStyle(fontSize: 12)),
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      cardColor: Colors.black,
      canvasColor: const Color(0xFF1A1A1A),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(fontSize: 8.5),
        fillColor: Color(0xFF1A1A1A),
        errorStyle: TextStyle(fontSize: 8.5),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 0.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 0.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 0.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 0.0),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
          actionTextColor: Colors.deepPurple,
          contentTextStyle: TextStyle(
              fontSize: 8,
              fontFamily: "PressStart2P",
              height: 1.5,
              color: Colors.black)),
      colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.deepPurple, brightness: Brightness.dark)
          .copyWith(secondary: Colors.grey));

  static final ThemeData lightTheme = ThemeData(
    tooltipTheme: const TooltipThemeData(
        textStyle: TextStyle(fontSize: 8.0, color: Colors.white)),
    dialogTheme: const DialogTheme(
        backgroundColor: Color(0xFFF2F2F2),
        contentTextStyle: TextStyle(
            height: 1.5,
            fontFamily: "PressStart2P",
            fontSize: 8.5,
            color: Colors.black)),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color.fromRGBO(36, 36, 62, 1),
      shape: CustomBorder(),
    ),
    primaryColor: const Color.fromRGBO(36, 36, 62, 1),
    canvasColor: const Color(0xFFF2F2F2),
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "PressStart2P",
    textTheme: const TextTheme(
        labelLarge: TextStyle(fontSize: 8.5),
        titleMedium: TextStyle(fontSize: 8.5, height: 1.5),
        titleLarge: TextStyle(fontSize: 12)),
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(fontSize: 8.5, color: Color(0xFF6C6C6C)),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 0.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 0.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 0.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 0.0),
        ),
        fillColor: Color(0xFFF2F2F2),
        errorStyle: TextStyle(fontSize: 8.5)),
    snackBarTheme: const SnackBarThemeData(
        actionTextColor: Colors.deepPurple,
        contentTextStyle: TextStyle(
            fontSize: 8,
            fontFamily: "PressStart2P",
            height: 1.5,
            color: Colors.white)),
    colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.deepPurple, brightness: Brightness.light)
        .copyWith(secondary: Colors.grey),
  );

  bool isDarkTheme(BuildContext context) {
    if (AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark) {
      return true;
    }
    return false;
  }

  bool isBarPinned(int length, num width, bool focus) {
    if (length <= width || focus) {
      return true;
    }
    return false;
  }
}
