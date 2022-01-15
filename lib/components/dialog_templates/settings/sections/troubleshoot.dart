// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:manager/components/dialog_templates/logs/build_logs.dart';
import 'package:manager/core/libraries/constants.dart';
import 'package:manager/core/libraries/widgets.dart';

class TroubleShootSettingsSection extends StatefulWidget {
  const TroubleShootSettingsSection({Key? key}) : super(key: key);

  @override
  _TroubleShootSettingsSectionState createState() =>
      _TroubleShootSettingsSectionState();
}

class _TroubleShootSettingsSectionState
    extends State<TroubleShootSettingsSection> {
  bool _requireTruShoot = false;

  //Troubleshoot
  bool truShootFullApp = false;
  bool truShootFlutter = false;
  bool truShootStudio = false;
  bool truShootVSC = false;

  void _checkTroubleShoot() {
    setState(() => _requireTruShoot = false);
    if (truShootFullApp) {
      setState(() {
        truShootFlutter = false;
        truShootStudio = false;
        truShootVSC = false;
      });
    }
  }

  void _startTroubleshoot() {
    setState(() => _requireTruShoot = false);
    if (truShootFlutter == false &&
        truShootFullApp == false &&
        truShootStudio == false &&
        truShootVSC == false) {
      setState(() => _requireTruShoot = true);
    } else {
      // TODO: Start troubleshooting for the selected service(s).
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData customTheme = Theme.of(context);
    return TabViewTabHeadline(
      title: 'Troubleshoot',
      allowContentScroll: false,
      content: <Widget>[
        if (_requireTruShoot)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: informationWidget(
              'You need to choose at least one troubleshoot option.',
              type: InformationType.error,
            ),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CheckBoxElement(
                onChanged: (bool? val) {
                  setState(() => truShootFullApp = !truShootFullApp);
                  _checkTroubleShoot();
                },
                value: truShootFullApp,
                text: 'All Applications',
              ),
              CheckBoxElement(
                onChanged: (bool? val) {
                  setState(() {
                    truShootFlutter = !truShootFlutter;
                    truShootFullApp = false;
                  });
                  _checkTroubleShoot();
                },
                value: truShootFlutter,
                text: 'Flutter',
              ),
              CheckBoxElement(
                onChanged: (bool? val) {
                  setState(() {
                    truShootStudio = !truShootStudio;
                    truShootFullApp = false;
                  });
                  _checkTroubleShoot();
                },
                value: truShootStudio,
                text: 'Android Studio',
              ),
              CheckBoxElement(
                onChanged: (bool? val) {
                  setState(() {
                    truShootVSC = !truShootVSC;
                    truShootFullApp = false;
                  });
                  _checkTroubleShoot();
                },
                value: truShootVSC,
                text: 'Visual Studio Code',
              ),
            ],
          ),
        ),
        ActionOptions(
          actions: <ActionOptionsObject>[
            ActionOptionsObject(
              'Generate Report',
              () {
                showDialog(
                  context: context,
                  builder: (_) => const BuildLogsDialog(),
                );
              },
            ),
            ActionOptionsObject(
              'Flutter Doctor',
              () {}, // TODO: Show flutter doctor result. Run doctor to get result.
            ),
          ],
        ),
        VSeparators.normal(),
        Align(
          alignment: Alignment.centerRight,
          child: RectangleButton(
            width: 150,
            onPressed: _startTroubleshoot,
            child: Text(
              'Start Troubleshoot',
              style: TextStyle(color: customTheme.textTheme.bodyText1!.color),
            ),
          ),
        ),
      ],
    );
  }
}
