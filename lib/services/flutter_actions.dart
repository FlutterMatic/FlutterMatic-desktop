import 'package:process_run/shell_run.dart';

class FlutterActions {
  Shell shell = Shell();

  //Create project
  Future<void> flutterCreate(
      String projName, String projDesc, String projOrg) async {
    await shell.run(
      'flutter create --project-name $projName --description $projDesc --org $projOrg',
    );
  }

  //Change channel
  Future<void> changeChannel(String channel) async {
    await shell.run('flutter channel $channel').then((value) => upgrade());
  }

  //Upgrade Channel
  Future<bool> upgrade() async {
    try {
      await shell.run('flutter upgrade');
      await shell.run('flutter doctor');
      return true;
    } catch (_) {
      return false;
    }
  }
}
