// 🎯 Dart imports:
import 'dart:isolate';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';

// 🌎 Project imports:
import 'package:fluttermatic/app/constants.dart';
import 'package:fluttermatic/app/shared_pref.dart';
import 'package:fluttermatic/components/dialog_templates/settings/settings.dart';
import 'package:fluttermatic/components/widgets/buttons/rectangle_button.dart';
import 'package:fluttermatic/core/notifiers/models/state/general/theme.dart';
import 'package:fluttermatic/core/notifiers/out.dart';
import 'package:fluttermatic/core/services/logs.dart';
import 'package:fluttermatic/meta/utils/general/clear_old_logs.dart';
import 'package:fluttermatic/meta/utils/general/shared_pref.dart';
import 'package:fluttermatic/meta/views/tabs/search/search.dart';
import 'package:fluttermatic/meta/views/tabs/sections/home/home.dart';
import 'package:fluttermatic/meta/views/tabs/sections/projects/projects.dart';
import 'package:fluttermatic/meta/views/tabs/sections/pub/pub.dart';
import 'package:fluttermatic/meta/views/tabs/sections/workflows/workflow.dart';

enum HomeTab { home, projects, pub, workflow }

class HomeScreen extends StatefulWidget {
  final HomeTab? tab;
  const HomeScreen({Key? key, this.tab}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Isolate Receive Ports
  static final ReceivePort _clearLogsPort = ReceivePort('CLEAR_OLD_LOGS_PORT');

  // Utils
  late bool _collapse =
      SharedPref().pref.getBool(SPConst.homePageTabsShow) ?? false;
  bool _animateFinish = false;

  // Tabs
  late HomeTabObject _selectedTab;

  static const List<HomeTabObject> _tabs = <HomeTabObject>[
    HomeTabObject('Home', Assets.home, HomeMainSection()),
    HomeTabObject('Projects', Assets.project, HomeProjectsSection()),
    HomeTabObject('Pub Packages', Assets.package, HomePubSection()),
    HomeTabObject('Workflows', Assets.workflow, HomeWorkflowSections()),
  ];

  Future<void> _cleanLogs() async {
    try {
      // After a second when everything has settled, we will clear logs that are
      // old to avoid clogging up the FlutterMatic app data space.
      await Future<void>.delayed(const Duration(seconds: 5));

      Isolate i = await Isolate.spawn(clearOldLogs, <dynamic>[
        _clearLogsPort.sendPort,
        (await getApplicationSupportDirectory()).path
      ]);

      _clearLogsPort.asBroadcastStream().listen((_) {
        i.kill();
        _clearLogsPort.close();
      });
    } catch (e, s) {
      await logger.file(LogTypeTag.error, 'Couldn\'t clear logs.',
          error: e, stackTrace: s);
    }
  }

  @override
  void initState() {
    setState(() {
      if (widget.tab != null) {
        switch (widget.tab) {
          case HomeTab.home:
            _selectedTab = _tabs[0];
            break;
          case HomeTab.projects:
            _selectedTab = _tabs[1];
            break;
          case HomeTab.pub:
            _selectedTab = _tabs[2];
            break;
          case HomeTab.workflow:
            _selectedTab = _tabs[3];
            break;
          default:
            _selectedTab = _tabs[0];
            break;
        }
      } else {
        _selectedTab = _tabs.first;
      }
    });

    Future<void>.delayed(const Duration(milliseconds: 100),
        () => setState(() => _animateFinish = true));

    _cleanLogs();
    super.initState();
  }

  @override
  void dispose() {
    _clearLogsPort.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool showShortView = size.width < 900 || _collapse;

    return Consumer(
      builder: (_, ref, __) {
        ThemeState themeState = ref.watch(themeStateController);

        return SafeArea(
          child: Scaffold(
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onDoubleTap: () {
                      setState(() => _collapse = !_collapse);
                      SharedPref()
                          .pref
                          .setBool(SPConst.homePageTabsShow, _collapse);
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                          width: showShortView ? 50 : 230,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10)),
                            child: ColoredBox(
                              color: Colors.blueGrey.withOpacity(0.08),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: showShortView ? 5 : 15,
                                  vertical: showShortView ? 5 : 20,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    ..._tabs.map((e) {
                                      return _tabTile(
                                        context,
                                        _collapse,
                                        stageType: e.stageType,
                                        icon: SvgPicture.asset(
                                          e.icon,
                                          color: themeState.darkTheme
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        name: e.name,
                                        onPressed: () =>
                                            setState(() => _selectedTab = e),
                                        selected: _selectedTab == e,
                                      );
                                    }),
                                    const Spacer(),
                                    // Short view
                                    if (showShortView)
                                      _tabTile(
                                        context,
                                        _collapse,
                                        stageType: null,
                                        icon: SvgPicture.asset(
                                          Assets.settings,
                                          color: themeState.darkTheme
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        name: 'Settings',
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) =>
                                                const SettingDialog(),
                                          );
                                        },
                                        selected: false,
                                      )
                                    else
                                      _tabTile(
                                        context,
                                        _collapse,
                                        stageType: null,
                                        icon: SvgPicture.asset(
                                          Assets.settings,
                                          color: themeState.darkTheme
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        name: 'Settings',
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) =>
                                                const SettingDialog(),
                                          );
                                        },
                                        selected: false,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 60),
                              child: _selectedTab.child,
                            ),
                            AnimatedOpacity(
                              opacity: _animateFinish ? 1 : 0.1,
                              duration: const Duration(milliseconds: 200),
                              child: const HomeSearchComponent(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _tabTile(
  BuildContext context,
  bool forceShort, {
  required Widget icon,
  required String name,
  required Function() onPressed,
  required String? stageType,
  required bool selected,
}) {
  Size size = MediaQuery.of(context).size;

  bool showShortView = forceShort || size.width < 900;

  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Tooltip(
      message: showShortView
          ? (name + (stageType == null ? '' : ' - $stageType'))
          : '',
      waitDuration: const Duration(seconds: 1),
      child: RectangleButton(
        width: 200,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        color: selected
            ? Theme.of(context).colorScheme.secondary.withOpacity(0.2)
            : Colors.transparent,
        padding: EdgeInsets.all(showShortView ? 5 : 10),
        onPressed: onPressed,
        child: Align(
          alignment: Alignment.centerLeft,
          child: !showShortView
              ? Row(
                  children: <Widget>[
                    icon,
                    HSeparators.small(),
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .color!
                              .withOpacity(selected ? 1 : .4),
                        ),
                      ),
                    ),
                    if (stageType != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(stageType,
                            style: const TextStyle(color: kGreenColor)),
                      ),
                  ],
                )
              : Center(child: icon),
        ),
      ),
    ),
  );
}

class HomeTabObject {
  final String name;
  final String icon;
  final Widget child;
  final String? stageType;

  const HomeTabObject(this.name, this.icon, this.child, [this.stageType]);
}
