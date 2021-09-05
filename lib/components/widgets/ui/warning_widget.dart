import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manager/app/constants/constants.dart';
import 'package:manager/components/widgets/ui/round_container.dart';
import 'package:manager/meta/utils/app_theme.dart';

Widget informationWidget(String text,
    {InformationType type = InformationType.warning, bool showIcon = true}) {
  return RoundContainer(
    color: _getColor(type).withOpacity(0.1),
    borderColor: _getColor(type),
    radius: 5,
    borderWith: 1.5,
    child: Row(
      children: <Widget>[
        if (showIcon)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: type == InformationType.info
                ? const Icon(Icons.info_rounded)
                : SvgPicture.asset(
                    type == InformationType.warning
                        ? Assets.warn
                        : type == InformationType.error
                            ? Assets.error
                            : Assets.done,
                    height: 20),
          ),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

Color _getColor(InformationType type) {
  if (type == InformationType.warning) {
    return kYellowColor;
  } else if (type == InformationType.error) {
    return kRedColor;
  } else if (type == InformationType.green) {
    return kGreenColor;
  } else {
    return AppTheme.darkLightColor;
  }
}

enum InformationType {
  info,
  warning,
  error,
  green,
}
