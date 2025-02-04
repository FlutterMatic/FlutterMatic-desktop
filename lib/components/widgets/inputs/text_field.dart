// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 🌎 Project imports:
import 'package:fluttermatic/app/constants.dart';
import 'package:fluttermatic/core/notifiers/models/state/general/theme.dart';
import 'package:fluttermatic/core/notifiers/out.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  /// If [filterFormatters] is provided then this will be no effect.
  final TextInputFormatter? filteringTextInputFormatter;

  /// If this is provided then [filteringTextInputFormatter] will be ignored.
  final List<TextInputFormatter>? filterFormatters;
  final int? numLines;
  final int? maxLength;
  final dynamic suffixIcon;
  final Function? onSuffixIcon;
  final Color? iconColor;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Color? color;
  final VoidCallback? onEditCompleted;
  final TextEditingController? controller;
  final bool? autofocus;
  final bool readOnly;
  final TextCapitalization? textCapitalization;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  const CustomTextField({
    Key? key,
    this.filteringTextInputFormatter,
    this.validator,
    this.autofocus,
    this.onChanged,
    this.controller,
    this.suffixIcon,
    this.onSuffixIcon,
    this.iconColor,
    this.numLines,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.color,
    this.hintText,
    this.focusNode,
    this.onEditCompleted,
    this.readOnly = false,
    this.textCapitalization,
    this.filterFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) {
        ThemeState themeState = ref.watch(themeStateController);

        return TextFormField(
          scrollPhysics: const BouncingScrollPhysics(),
          cursorRadius: const Radius.circular(10),
          focusNode: focusNode,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          readOnly: readOnly,
          onEditingComplete: onEditCompleted,
          autofocus: autofocus ?? false,
          keyboardType: keyboardType ?? TextInputType.text,
          obscureText: obscureText,
          maxLines: numLines ?? 1,
          style: TextStyle(color: Theme.of(context).textTheme.bodySmall!.color),
          inputFormatters: filterFormatters ??
              <TextInputFormatter>[
                filteringTextInputFormatter ??
                    FilteringTextInputFormatter.deny('')
              ],
          decoration: InputDecoration(
            errorStyle: const TextStyle(color: kRedColor),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(5),
            ),
            suffixIcon: suffixIcon,
            fillColor:
                Colors.blueGrey.withOpacity(themeState.darkTheme ? 0.2 : 0.1),
            filled: true,
            hintText: hintText,
            counterStyle: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .color!
                  .withOpacity(0.75),
            ),
            hintStyle: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .color!
                    .withOpacity(0.75),
                fontSize: 15),
          ),
          textAlignVertical: TextAlignVertical.center,
          maxLength: maxLength,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          validator: validator == null
              ? null
              : validator as String? Function(String?)?,
          keyboardAppearance: Brightness.dark,
          onChanged: onChanged,
          controller: controller,
        );
      },
    );
  }
}
