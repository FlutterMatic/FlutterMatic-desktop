import 'package:flutter/material.dart';
import 'package:flutter_installer/utils/constants.dart';

class SquareButton extends StatelessWidget {
  final double size;
  final Widget icon;
  final Function() onPressed;
  final Color? color;
  final String tooltip;
  final EdgeInsets padding;

  SquareButton({
    this.size = 40,
    this.padding = EdgeInsets.zero,
    this.color = kGreyColor,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: size, maxWidth: size),
      child: Tooltip(
        message: tooltip,
        child: MaterialButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size > 40 ? 10 : 5),
          ),
          color: color,
          elevation: 0,
          hoverElevation: 0,
          focusElevation: 0,
          highlightElevation: 0,
          minWidth: size,
          height: size,
          child: Padding(
            padding: padding,
            child: SizedBox(height: size, width: size, child: icon),
          ),
        ),
      ),
    );
  }
}
