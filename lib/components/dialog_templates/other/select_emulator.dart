import 'package:flutter/material.dart';
import 'package:manager/components/dialog_templates/dialog_header.dart';
import 'package:manager/core/libraries/widgets.dart';

class SelectEmulatorDialog extends StatelessWidget {
  const SelectEmulatorDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogTemplate(
      child: Column(
        children: const <Widget>[
          DialogHeader(title: 'Select Emulator'),
          // TODO: Implement an emulator selection interface
        ],
      ),
    );
  }
}
