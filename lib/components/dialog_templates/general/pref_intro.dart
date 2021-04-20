import 'package:flutter/material.dart';
import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter_installer/components/dialog_templates/dialog_header.dart';
import 'package:flutter_installer/components/widgets/dialog_template.dart';
import 'package:flutter_installer/components/widgets/rectangle_button.dart';
import 'package:flutter_installer/components/widgets/round_container.dart';
import 'package:flutter_installer/services/themes.dart';
import 'package:flutter_installer/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class PrefIntroDialog extends StatefulWidget {
  @override
  _PrefIntroDialogState createState() => _PrefIntroDialogState();
}

class _PrefIntroDialogState extends State<PrefIntroDialog> {
  //Utils
  late SharedPreferences _pref;
  bool _dirPathError = false;
  bool _loading = false;

  //User Inputs
  String? _dirPath;

  @override
  Widget build(BuildContext context) {
    ThemeData customTheme = Theme.of(context);
    return DialogTemplate(
      outerTapExit: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DialogHeader(title: 'Welcome to Flutter Installer!', canClose: false),
          const SizedBox(height: 15),
          const Text(
            'Let\'s get you started. We will need to know just a couple things from you.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          //Theme
          const Text('Theme', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: RectangleButton(
                  hoverColor: const Color(0xFF22272E),
                  splashColor: Colors.transparent,
                  height: 100,
                  highlightColor: const Color(0xFF22272E),
                  color: const Color(0xFF22272E),
                  onPressed: () async {
                    if (!currentTheme.isDarkTheme) currentTheme.toggleTheme();
                  },
                  child: Column(
                    children: [
                      if (currentTheme.isDarkTheme)
                        const Expanded(
                          child: Icon(Icons.check_circle_rounded,
                              color: Colors.white),
                        )
                      else
                        const Spacer(),
                      const Text('Dark Theme',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: RectangleButton(
                  height: 100,
                  highlightColor: Colors.white,
                  hoverColor: Colors.white,
                  splashColor: Colors.transparent,
                  color: Colors.white,
                  onPressed: () async {
                    if (currentTheme.isDarkTheme) currentTheme.toggleTheme();
                  },
                  child: Column(
                    children: [
                      if (!currentTheme.isDarkTheme)
                        const Expanded(
                          child: Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF22272E),
                          ),
                        )
                      else
                        const Spacer(),
                      const Text('Light Theme',
                          style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          //Project Location
          const Text('Projects Location',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          RoundContainer(
            borderColor: _dirPathError ? kRedColor : Colors.transparent,
            borderWith: 2,
            width: double.infinity,
            radius: 5,
            color: Colors.blueGrey.withOpacity(0.2),
            child: Row(
              children: [
                const Expanded(
                  child: Text('Where do you want us to find your projects?'),
                ),
                const SizedBox(width: 8),
                RectangleButton(
                  onPressed: () async {
                    OpenFilePicker file = OpenFilePicker()
                      // ..filterSpecification = {'Directory': '*.dir'}
                      ..defaultFilterIndex = 0
                      ..title = 'Select projects path';
                    File _result = file.getFile()!;
                    setState(() => _dirPath = _result.path);
                  },
                  color: Colors.blueGrey.withOpacity(0.2),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.blueGrey.withOpacity(0.8),
                  hoverColor: Colors.blueGrey.withOpacity(0.5),
                  child: Text(
                    'Choose Path',
                    style: TextStyle(
                        color: customTheme.textTheme.bodyText1!.color),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          RectangleButton(
            loading: _loading,
            onPressed: () async {
              setState(() {
                _dirPathError = false;
                _loading = false;
              });
              if (_dirPath == null) {
                setState(() => _dirPathError = true);
              } else {
                setState(() => _loading = true);
                _pref = await SharedPreferences.getInstance();
                await _pref.setString('projects_path', _dirPath!);
                await Navigator.pushNamedAndRemoveUntil(
                    context, PageRoutes.routeHome, (route) => false);
              }
            },
            width: double.infinity,
            color: Colors.blueGrey,
            splashColor: Colors.blueGrey.withOpacity(0.5),
            focusColor: Colors.blueGrey.withOpacity(0.5),
            hoverColor: Colors.grey.withOpacity(0.5),
            highlightColor: Colors.blueGrey.withOpacity(0.5),
            child: const Text('Get Started'),
          ),
        ],
      ),
    );
  }
}
