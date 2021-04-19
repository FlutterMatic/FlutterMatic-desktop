import 'package:flutter/material.dart';

CustomTheme currentTheme = CustomTheme();

class CustomTheme with ChangeNotifier {
  static bool _isDarkTheme = false;
  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;
  ThemeMode get systemTheme => ThemeMode.system;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  static ThemeData get lightTheme => ThemeData(
        primaryColor: Colors.white,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        primaryColorLight: const Color(0xFFF1F1F1),
        buttonColor: const Color(0xFFF6F8FA),
        accentColor: const Color(0xFF6E7681),
        splashColor: Colors.transparent,
        errorColor: const Color(0xFFD73A49),
        highlightColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        textTheme: const TextTheme(
          headline1: TextStyle(color: Colors.black),
          headline2: TextStyle(color: Colors.black),
          bodyText1: TextStyle(color: Colors.black),
          bodyText2: TextStyle(color: Colors.black),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        primaryColor: Colors.black,
        backgroundColor: const Color(0xFF22272E),
        scaffoldBackgroundColor: const Color(0xFF22272E),
        primaryColorLight: const Color(0xFF2D333A),
        buttonColor: const Color(0xFF373E47),
        focusColor: const Color(0xFF444C56),
        accentColor: const Color(0xFF6E7681),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        dividerColor: Colors.white,
        textTheme: const TextTheme(
          headline1: TextStyle(color: Colors.white),
          headline2: TextStyle(color: Colors.white),
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white),
        ),
      );
}
