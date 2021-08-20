import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:manager/app/constants/enum.dart';
import 'package:manager/app/constants/constants.dart';
import 'package:manager/core/libraries/checks.dart';
import 'package:manager/core/libraries/widgets.dart';
import 'package:manager/components/dialog_templates/dialog_header.dart';
import 'package:manager/core/libraries/components.dart';
import 'package:manager/meta/utils/app_theme.dart';
import 'package:provider/provider.dart';

Widget installJava(
  BuildContext context, {
  VoidCallback? onInstall,
  VoidCallback? onContinue,
  VoidCallback? onSkip,
  required bool isInstalling,
  required bool doneInstalling,
}) {
  return Consumer<JavaNotifier>(
      builder: (BuildContext context, JavaNotifier javaNotifier, _) {
    return Column(
      children: <Widget>[
        welcomeHeaderTitle(
          Assets.java,
          Install.java,
          InstallContent.java,
          iconHeight: 40,
        ),
        const SizedBox(height: 50),
        if (isInstalling && !doneInstalling)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: (javaNotifier.progress == Progress.STARTED ||
                    javaNotifier.progress == Progress.CHECKING)
                ? Column(
                    children: <Widget>[
                      hLoadingIndicator(
                        context: context,
                        message: 'Checking for java',
                      ),
                      const Text('Checking for java'),
                    ],
                  )
                : (javaNotifier.progress == Progress.DOWNLOADING)
                    ? CustomProgressIndicator(
                        disabled: (javaNotifier.progress != Progress.CHECKING &&
                            javaNotifier.progress != Progress.DOWNLOADING &&
                            javaNotifier.progress != Progress.STARTED),
                        progress: javaNotifier.progress,
                        toolName: 'Java',
                        onCancel: () {},
                        message: javaNotifier.sw == Java.JDK
                            ? 'Downloading JDK'
                            : 'Downloading JRE',
                      )
                    : javaNotifier.progress == Progress.EXTRACTING
                        ? Tooltip(
                            message: javaNotifier.sw == Java.JDK
                                ? 'Extracting JDK'
                                : 'Extracting JRE',
                            child: Lottie.asset(
                              Assets.extracting,
                              height: 100,
                            ),
                          )
                        : javaNotifier.progress == Progress.DONE
                            ? welcomeToolInstalled(
                                context,
                                title: 'Java Installed',
                                message:
                                    'Java installed successfully on your machine. Continue to the next step.',
                              )
                            : javaNotifier.progress == Progress.NONE
                                ? const SizedBox.shrink()
                                : CustomProgressIndicator(
                                    disabled: (javaNotifier.progress !=
                                            Progress.CHECKING &&
                                        javaNotifier.progress !=
                                            Progress.DOWNLOADING &&
                                        javaNotifier.progress !=
                                            Progress.STARTED),
                                    progress: javaNotifier.progress,
                                    toolName: 'Java',
                                    onCancel: () {},
                                    message: javaNotifier.sw == Java.JDK
                                        ? 'Downloading JDK'
                                        : 'Downloading JRE',
                                  ),
          ),
        if (doneInstalling)
          welcomeToolInstalled(
            context,
            title: Installed.java,
            message: InstalledContent.java,
          ),
        if (javaNotifier.progress == Progress.DONE) const SizedBox(height: 30),
        WelcomeButton(
          onContinue: onContinue,
          onInstall: onInstall,
          progress: javaNotifier.progress,
          toolName: 'Java',
        ),
        const SizedBox(height: 20),
        if (javaNotifier.progress == Progress.NONE)
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => DialogTemplate(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const DialogHeader(title: 'Are you sure?'),
                      const SizedBox(height: 10),
                      informationWidget(
                        'We recommend that you installed Java. This will help eliminate some issues you might face in the future with Flutter.',
                      ),
                      const SizedBox(height: 5),
                      infoWidget(context,
                          'You will still be able to install Java later if you change your mind.'),
                      const SizedBox(height: 20),
                      const Text('Tool Skipping:'),
                      const SizedBox(height: 15),
                      BulletPoint('Java 8 by Oracle', 2),
                      const SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: RectangleButton(
                              hoverColor: AppTheme.errorColor,
                              child: const Text('Skip',
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                Navigator.pop(context);
                                onSkip!();
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: RectangleButton(
                              child: const Text('Cancel',
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                ButtonTexts.skip,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
      ],
    );
  });
}
