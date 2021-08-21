import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:manager/app/constants/constants.dart';
import 'package:manager/app/constants/enum.dart';
import 'package:manager/core/libraries/notifiers.dart';
import 'package:manager/core/libraries/services.dart';
import 'package:manager/core/libraries/models.dart';
import 'package:manager/meta/utils/bin/studio.bin.dart';
import 'package:manager/meta/utils/shared_pref.dart';
import 'package:process_run/shell.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
// ignore: implementation_imports
import 'package:pub_semver/src/version.dart';

/// [AndroidStudioNotifier] class is a [ChangeNotifier]
/// for Android Studio checks.
class AndroidStudioNotifier extends ChangeNotifier {
  /// [studioVersion] value holds Android Studio version information
  Version? studioVersion;
  Directory? jetBrainStudioDir;
  Progress _progress = Progress.NONE;
  Progress get progress => _progress;
  Future<void> checkAStudio(BuildContext context, FluttermaticAPI? api) async {
    _progress = Progress.STARTED;
    notifyListeners();

    /// The comppressed archive type.
    String? archiveType = Platform.isLinux ? 'tar.gz' : 'zip';
    try {
      /// Make a fake delay of 1 second such that UI looks cool.
      await Future<dynamic>.delayed(const Duration(seconds: 1));
      _progress = Progress.CHECKING;
      notifyListeners();
      String? studioPath = await which('studio');
      Directory tempDir = await getTemporaryDirectory();
      Directory applicationDir = await getApplicationSupportDirectory();
      Directory? jetbrainsDir =
          Directory(tempDir.path.replaceAll('Temp', 'JetBrains'));

      /// Check if studio path is null.
      if (studioPath == null) {
        /// Check in Program Files Directory
        bool checkPF = await checkProgramFiles();
        if (!checkPF && await jetbrainsDir.exists()) {
          bool checkJB = await checkJetBrains(
              jetbrainsDir.path + '\\Toolbox\\apps\\AndroidStudio',
              appDir: applicationDir.path);
          if (!checkJB) {
            /// Check for AndroidStudio Directory to extract Android studio files
            bool studioDir = await checkDir('C:\\fluttermatic\\',
                subDirName: 'AndroidStudio');
            bool fmaticDir = await checkDir('C:\\', subDirName: 'fluttermatic');
            if (!studioDir) {
              if (!fmaticDir) {
                await Directory('C:\\fluttermatic').create(recursive: true);
              }
              await Directory('C:\\fluttermatic\\AndroidStudio')
                  .create(recursive: true);
              await logger.file(LogTypeTag.INFO,
                  'Created Android studio directory in fluttermatic folder.');
            }
            _progress = Progress.DOWNLOADING;
            notifyListeners();
            await installAndroidStudio(
              context,
              api: api,
              appDir: applicationDir.path,
              archiveType: archiveType,
            );
          }
          _progress = Progress.DONE;
          notifyListeners();
        }
      } else if (!SharedPref().prefs.containsKey('Studio path') ||
          !SharedPref().prefs.containsKey('Studio version')) {
        await SharedPref().prefs.setString('Studio path', studioPath);
        await logger.file(
            LogTypeTag.INFO, 'Android Studio found at - $studioPath');

        /// Fetch the version of Android Studio.
        studioVersion = await getAStudioBinVersion();
        versions.studio = studioVersion.toString();
        await logger.file(
            LogTypeTag.INFO, 'Android Studio version : ${versions.studio}');
        await SharedPref().prefs.setString('Studio version', versions.studio!);
        _progress = Progress.DONE;
        notifyListeners();
      } else {
        await logger.file(LogTypeTag.INFO,
            'Loading Android Studio details from shared preferences');
        studioPath = SharedPref().prefs.getString('Studio path');
        await logger.file(
            LogTypeTag.INFO, 'Android Studio found at - $studioPath');
        versions.studio = SharedPref().prefs.getString('studio Version');
        await logger.file(
            LogTypeTag.INFO, 'Studio version : ${versions.studio}');
        _progress = Progress.DONE;
        notifyListeners();
      }
    } on ShellException catch (shellException) {
      _progress = Progress.FAILED;
      notifyListeners();
      await logger.file(LogTypeTag.ERROR, shellException.message);
    } catch (err) {
      _progress = Progress.FAILED;
      notifyListeners();
      await logger.file(LogTypeTag.ERROR, err.toString());
    }
  }

  /// This function will check if the Android Studio
  /// is installed in the Program Files directory.
  Future<bool> checkProgramFiles() async {
    await logger.file(LogTypeTag.INFO, 'Checking Program Files');
    Directory? programFilesDir = Directory('C:\\Program Files\\Android');
    try {
      if (await programFilesDir.exists()) {
        await logger.file(LogTypeTag.INFO, 'Program Files Directory Exists');
        await logger.file(
            LogTypeTag.INFO, 'Checking in Program Files for Android studio');
        String? studio64PFPath =
            await getFilePath('C:\\Program Files\\Android\\', 'studio64.exe');
        if (studio64PFPath != null) {
          await logger.file(
              LogTypeTag.INFO, 'Studio64.exe found in Program Files');
          await Future<dynamic>.delayed(const Duration(seconds: 1));
          await SharedPref().prefs.setString('Studio path', studio64PFPath);
          await setPath(studio64PFPath);
          return true;
        } else {
          await logger.file(LogTypeTag.INFO,
              'Studio64.exe not found in Program Files folder');
          return false;
        }
      } else {
        return false;
      }
    } on FileSystemException catch (fileException) {
      await logger.file(
          LogTypeTag.ERROR, 'Extracting failed - File System Exception',
          stackTraces: null);
      await logger.file(LogTypeTag.ERROR, fileException.message.toString());
      return false;
    } catch (err) {
      await logger.file(LogTypeTag.ERROR, err.toString());
      return false;
    }
  }

  /// This function will check if the Android Studio
  /// is installed in the Jetbrains directory.
  Future<bool> checkJetBrains(String? jetbrainsDir, {String? appDir}) async {
    await logger.file(LogTypeTag.INFO, 'Checking JetBrains');
    Directory? jetBrainsDir = Directory(jetbrainsDir!);
    if (await jetBrainsDir.exists()) {
      await logger.file(LogTypeTag.INFO, 'JetBrains Directory Exists');
      await logger.file(
          LogTypeTag.INFO, 'Checking in JetBrains for Android studio');
      String? studio64JBPath = await getFilePath(jetbrainsDir, 'studio64.exe');
      if (studio64JBPath != null) {
        paths.studio = studio64JBPath;
        await logger.file(LogTypeTag.INFO, 'Studio64.exe found in Jetbrains');
        await Future<dynamic>.delayed(const Duration(seconds: 1));
        await setPath(studio64JBPath, appDir);
        await SharedPref().prefs.setString('Studio path', paths.studio!);
        return true;
      } else {
        await logger.file(
            LogTypeTag.INFO, 'Studio64.exe not found in Jetbrains folder');
        return false;
      }
    } else {
      return false;
    }
  }

  /// Install the Android Studio.
  Future<void> installAndroidStudio(BuildContext context,
      {FluttermaticAPI? api,
      required String appDir,
      String? archiveType}) async {
    /// Downloading Android studio.
    !kDebugMode || kProfileMode
        ? await context.read<DownloadNotifier>().downloadFile(
              'https://sample-videos.com/zip/50mb.zip',
              'studio.$archiveType',
              appDir + '\\tmp',
            )
        : await context.read<DownloadNotifier>().downloadFile(
              api!.data!['android_studio'][platform]
                  [archiveType!.replaceAll('.', '')],
              'studio.$archiveType',
              appDir + '\\tmp',
            );
    await Future<dynamic>.delayed(const Duration(seconds: 1));

    _progress = Progress.EXTRACTING;
    context.read<DownloadNotifier>().dProgress = 0;
    notifyListeners();

    /// Extract Android studio from compressed file.
    bool studioExtracted = await unzip(
      appDir + '\\tmp\\studio.zip',
      'C:\\fluttermatic\\',
    );
    if (studioExtracted) {
      await Future<dynamic>.delayed(const Duration(seconds: 1));
      await logger.file(
          LogTypeTag.INFO, 'Android studio extraction was successfull');
      if (await checkDir('C:\\fluttermatic\\', subDirName: 'android-studio')) {
        await Directory('C:\\fluttermatic\\android-studio')
            .rename('C:\\fluttermatic\\AndroidStudio');

        /// Appending path to env
        bool isASPathSet =
            await setPath('C:\\fluttermatic\\AndroidStudio\\bin', appDir);
        if (isASPathSet) {
          await SharedPref()
              .prefs
              .setString('Studio path', 'C:\\fluttermatic\\AndroidStudio\\bin');
          await Future<dynamic>.delayed(const Duration(seconds: 1));
          await logger.file(LogTypeTag.INFO, 'Android studio set to path');
        } else {
          _progress = Progress.FAILED;
          notifyListeners();

          await Future<dynamic>.delayed(const Duration(seconds: 1));
          await logger.file(
              LogTypeTag.INFO, 'Android studio set to path failed');
        }
      } else {
        _progress = Progress.FAILED;
        notifyListeners();
        await Future<dynamic>.delayed(const Duration(seconds: 1));
        await logger.file(LogTypeTag.ERROR, 'Android studio renaming failed.');
      }
    } else {
      _progress = Progress.FAILED;
      notifyListeners();
      await Future<dynamic>.delayed(const Duration(seconds: 1));
      await logger.file(LogTypeTag.ERROR, 'Android studio extraction failed.');
    }
  }
}
