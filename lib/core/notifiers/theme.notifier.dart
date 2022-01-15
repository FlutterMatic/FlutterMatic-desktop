// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// 📦 Package imports:
import 'package:shared_preferences/shared_preferences.dart';

// 🌎 Project imports:
import 'package:manager/app/constants/shared_pref.dart';
import 'package:manager/core/services/logs.dart';
import 'package:manager/meta/utils/shared_pref.dart';

class ThemeChangeNotifier with ChangeNotifier {
  /// [_isDarkTheme] boolean value that indicates
  /// whether the app is currently in DarkTheme mode.
  bool _isDarkTheme = true;
  bool _isSystemTheme = false;

  ThemeChangeNotifier() {
    loadThemePref();
  }

  Future<void> loadThemePref() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _isSystemTheme = _pref.getBool(SPConst.isSystemTheme) ?? false;
    if (_isSystemTheme) {
      Brightness brightness =
          SchedulerBinding.instance!.window.platformBrightness;
      _isDarkTheme = brightness == Brightness.dark;
    } else {
      if (_pref.containsKey(SPConst.isDarkTheme)) {
        darkTheme = _pref.getBool(SPConst.isDarkTheme)!;
      } else {
        darkTheme = true;
        await _pref.setBool(SPConst.isDarkTheme, true);
      }
    }
  }

  /// DarkTheme getter
  bool get isDarkTheme => _isDarkTheme;
  bool get isSystemTheme => _isSystemTheme;

  /// DarkTheme setter
  set darkTheme(bool value) {
    _isDarkTheme = value;
    notifyListeners();
    logger.file(LogTypeTag.info, 'Dark theme setter set to $value.');
  }

  Future<void> updateTheme(bool isDarkTheme) async {
    _isDarkTheme = isDarkTheme;
    notifyListeners();
    await SharedPref().pref.setBool(SPConst.isDarkTheme, _isDarkTheme);
    await logger.file(LogTypeTag.info, 'Dark theme updated to $_isDarkTheme.');
  }

  Future<void> updateSystemTheme(bool isSystemTheme) async {
    _isSystemTheme = isSystemTheme;
    notifyListeners();
    await SharedPref().pref.setBool(SPConst.isSystemTheme, _isSystemTheme);
    await logger.file(
        LogTypeTag.info, 'System theme updated to $_isSystemTheme.');
  }
}
