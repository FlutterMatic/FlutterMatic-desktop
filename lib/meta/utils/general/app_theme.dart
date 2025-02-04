// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  static const Color darkBackgroundColor = Color(0xFF181C1E);
  static const Color darkCardColor = Color(0xFF262F34);
  static const Color darkLightColor = Color(0xFF656D77);
  static const Color lightBackgroundColor = Color(0xFFFFFFFF);
  static const Color lightComponentsColor = Color(0xFF40CAFF);
  static const Color lightCardColor = Color(0xFFF4F8FA);
  static const Color primaryColor = Color(0xFF206BC4);
  static const Color errorColor = Color(0xFFD73A49);

  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'NotoSans',
      primaryColor: lightBackgroundColor,
      scaffoldBackgroundColor: lightBackgroundColor,
      primaryColorLight: const Color(0xFFF1F1F1),
      splashColor: Colors.transparent,
      
      highlightColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.black),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: Colors.black),
        headlineMedium: TextStyle(color: Colors.black),
        headlineSmall: TextStyle(color: Colors.black),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: const Color(0xFF79A6DC),
        brightness: Brightness.light,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      fontFamily: 'NotoSans',
      canvasColor: darkBackgroundColor,
      primaryColor: darkBackgroundColor,
      unselectedWidgetColor: Colors.blueGrey.withOpacity(0.3),
      scaffoldBackgroundColor: darkBackgroundColor,
      primaryColorLight: const Color(0xFF2D333A),
      focusColor: const Color(0xFF444C56),
      // errorColor: errorColor,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.white),
      dividerColor: Colors.white,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Color(0xffFAFAFA),
        ),
        headlineMedium: TextStyle(
          color: Color(0xffFAFAFA),
        ),
        headlineSmall: TextStyle(
          color: Color(0xffFAFAFA),
        ),
        bodyMedium: TextStyle(
          color: Color(0xffFAFAFA),
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: const Color(0xFF6E7681),
        brightness: Brightness.dark,
      ),
    );
  }
}
