import 'package:flutter/material.dart';
import 'package:flutter_installer/components/widgets/inputs/check_box_element.dart';
import 'package:flutter_installer/components/widgets/ui/warning_widget.dart';
import 'package:flutter_installer/utils/constants.dart';

class ProjectPlatformsSection extends StatefulWidget {
  final Function(bool ios, bool android, bool web, bool windows, bool macos,
      bool linux) onChanged;

  ProjectPlatformsSection({required this.onChanged});

  @override
  _ProjectPlatformsSectionState createState() =>
      _ProjectPlatformsSectionState();
}

class _ProjectPlatformsSectionState extends State<ProjectPlatformsSection> {
  // Platforms
  bool _ios = true;
  bool _android = true;
  bool _web = true;
  bool _windows = true;
  bool _macos = true;
  bool _linux = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
            'Choose which enviroments you want to enable for your new Flutter project.'),
        const SizedBox(height: 10),
        CheckBoxElement(
          onChanged: (val) {
            setState(() => _ios = !_ios);
            widget.onChanged(_ios, _android, _web, _windows, _macos, _linux);
          },
          value: _ios,
          text: 'iOS',
        ),
        CheckBoxElement(
          onChanged: (val) {
            setState(() => _android = !_android);
            widget.onChanged(_ios, _android, _web, _windows, _macos, _linux);
          },
          value: _android,
          text: 'Android',
        ),
        CheckBoxElement(
          onChanged: (val) {
            setState(() => _web = !_web);
            widget.onChanged(_ios, _android, _web, _windows, _macos, _linux);
          },
          value: _web,
          text: 'Web',
        ),
        CheckBoxElement(
          onChanged: (val) {
            setState(() => _windows = !_windows);
            widget.onChanged(_ios, _android, _web, _windows, _macos, _linux);
          },
          value: _windows,
          text: 'Windows',
        ),
        CheckBoxElement(
          onChanged: (val) {
            setState(() => _macos = !_macos);
            widget.onChanged(_ios, _android, _web, _windows, _macos, _linux);
          },
          value: _macos,
          text: 'MacOS',
        ),
        CheckBoxElement(
          onChanged: (val) {
            setState(() => _linux = !_linux);
            widget.onChanged(_ios, _android, _web, _windows, _macos, _linux);
          },
          value: _linux,
          text: 'Linux',
        ),
        if (!validatePlatformSelection(
          ios: _ios,
          android: _android,
          web: _web,
          windows: _windows,
          macos: _macos,
          linux: _linux,
        ))
          warningWidget(
            'You will need to choose at least one platform. You will be able to change it later.',
            Assets.error,
            kRedColor,
          ),
      ],
    );
  }
}

bool validatePlatformSelection({
  required bool ios,
  required bool android,
  required bool web,
  required bool windows,
  required bool macos,
  required bool linux,
}) {
  return !(ios == false &&
      android == false &&
      web == false &&
      windows == false &&
      macos == false &&
      linux == false);
}
