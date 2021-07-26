import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:manager/app/constants/constants.dart';
import 'package:manager/app/providers/multi_ptoviders.dart';
import 'package:manager/core/libraries/notifiers.dart';
import 'package:manager/meta/utils/app_theme.dart';
import 'package:manager/meta/utils/shared_pref.dart';
import 'package:manager/meta/views/startup.dart';
import 'package:provider/provider.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref.init();
  if (SharedPref().prefs.getString('platform') == null) {
    await SharedPref()
        .prefs
        .setString('platform', Platform.operatingSystem)
        .then((_) => platform = SharedPref().prefs.getString('platform'));
  } else {
    platform = SharedPref().prefs.getString('platform');
  }
  runApp(
    MultiProviders(
      MyApp(),
    ),
  );
  doWhenWindowReady(() {
    appWindow.minSize = const Size(300, 380);
    appWindow.size = const Size(300, 380);
    appWindow.alignment = Alignment.center;
    appWindow.title = 'Flutter App Checks';
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeChangeNotifier>(
      builder: (BuildContext context, ThemeChangeNotifier themeChangeNotifier,
          Widget? child) {
        return MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeChangeNotifier.isDarkTheme
              ? ThemeMode.dark
              : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home: Startup(themeChangeNotifier),
          // home: const ThemeToggle(),
        );
      },
    );
  }
}
