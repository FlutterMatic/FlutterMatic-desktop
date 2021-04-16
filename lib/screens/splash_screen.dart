import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_installer/utils/constants.dart';
import 'package:flutter_installer/utils/responsive_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> future() async {
    await Future<void>.delayed(
        const Duration(
          seconds: 3,
        ), () {
      Navigator.pushReplacementNamed(context, PageRoutes.routeState);
    });
  }

  @override
  void initState() {
    super.initState();
    future();
  }

  @override
  Widget build(BuildContext context) => ResponsiveLayout(
        child: Center(
          child: Hero(
            tag: 'logo',
            child: Image.asset(
              Assets.flutterIcon,
              height: 0.2 * MediaQuery.of(context).size.height,
            ),
          ),
        ),
      );
}
