import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/coding.png', height: 200),
                const Text('Wait till we complete developing...'),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: WindowTitleBarBox(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: MoveWindow(),
                  ),
                  const WindowControls()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WindowControls extends StatelessWidget {
  const WindowControls({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(
          onPressed: () => appWindow.minimize(),
          splashColor: Colors.transparent,
          splashRadius: 0.01,
          focusColor: Colors.grey,
          hoverColor: Colors.grey,
          highlightColor: Colors.grey,
          color: Colors.black,
          icon: const Icon(
            Icons.remove_rounded,
            size: 15,
          ),
        ),
        IconButton(
          onPressed: () => appWindow.maximizeOrRestore(),
          splashColor: Colors.transparent,
          splashRadius: 0.01,
          focusColor: Colors.grey,
          hoverColor: Colors.grey,
          highlightColor: Colors.grey,
          color: Colors.black,
          icon: const Icon(
            Icons.crop_square_rounded,
            size: 15,
          ),
        ),
        IconButton(
          onPressed: () => appWindow.close(),
          splashColor: Colors.transparent,
          splashRadius: 0.01,
          focusColor: Colors.red,
          hoverColor: Colors.red,
          highlightColor: Colors.red,
          color: Colors.red,
          icon: const Icon(
            Icons.close_rounded,
            size: 15,
          ),
        ),
      ],
    );
  }
}
