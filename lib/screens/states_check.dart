import 'package:flutter/material.dart';
import 'package:flutter_installer/components/dialog_templates/general/pref_intro.dart';
import 'package:flutter_installer/screens/home_screen.dart';
import 'package:flutter_installer/services/checks.dart';
import 'package:flutter_installer/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusCheck extends StatefulWidget {
  const StatusCheck({Key? key}) : super(key: key);

  @override
  _StatusCheckState createState() => _StatusCheckState();
}

class _StatusCheckState extends State<StatusCheck> {
  late SharedPreferences _pref;
  Future<void> _loadServices() async {
    _pref = await SharedPreferences.getInstance();
    if (mounted) {
      CheckDependencies checkDependencies = CheckDependencies();
      flutterInstalled = await checkDependencies.checkFlutter();
      javaInstalled = await checkDependencies.checkJava();
      vscInstalled = await checkDependencies.checkVSC();
      vscInsidersInstalled = await checkDependencies.checkVSCInsiders();
      studioInstalled = await checkDependencies.checkAndroidStudios();
      await _pref.clear();
      if (!_pref.containsKey('projects_path')) {
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => PrefIntroDialog(),
        );
      }
    }
    if (mounted) {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
        ),
      ),
    );
  }
}
