import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nocommission_app/core/local.dart';

import '../theme/color.dart';
import 'custom_text.dart';

class CustomRadio extends StatelessWidget {
  CustomRadio({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.checkColor,
    this.enabled = true,
    this.tileColor,
    this.title,
    this.titleText,
    this.subtitle,
    this.isThreeLine = false,
    this.isExpanded = false,
    this.dense,
    this.secondary = const SizedBox.shrink(),
    this.selected = false,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.autofocus = false,
    this.contentPadding,
    this.radioSize = 22,
    this.fountSize = 15,
    this.shape ,
    this.selectedTileColor,
    this.side = const BorderSide(
      color: ColorsUi.inputBorder,
      width: 1,
    ),
    this.visualDensity,
    this.focusNode,
    this.enableFeedback,
    this.splashRadius,
  });

  final bool value;

  final double? splashRadius;

  final ValueChanged<bool> onChanged;

  final Color? activeColor;

  final Color? checkColor;

  final Color? tileColor;

  final Widget? title;
  final String? titleText;

  final Widget? subtitle;

  final Widget secondary;

  final bool isThreeLine;

  final bool? dense;

  final bool selected;

  final ListTileControlAffinity controlAffinity;

  final bool autofocus;

  final EdgeInsetsGeometry? contentPadding;

  final OutlinedBorder? shape;

  final Color? selectedTileColor;

  final BorderSide? side;

  final VisualDensity? visualDensity;

  final FocusNode? focusNode;

  final bool? enableFeedback;
  bool isExpanded;

  final bool enabled;
  final double radioSize;
  double fountSize;

  @override
  Widget build(BuildContext context) {
    Widget leading, trailing;

    Widget control = IconButton(
        visualDensity: const VisualDensity(vertical: -3, horizontal: -4),
        padding: EdgeInsets.zero,
        splashRadius: splashRadius ?? 15.r,

        onPressed: enabled ? () => onChanged(!value) : null,
        icon: Container(
          width: radioSize,
          height: radioSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: value ? ColorsUi.gradientLogo : null,
              borderRadius: BorderRadius.all(Radius.circular(25.r)),
              border: Border.all(
                  color: value ? ColorsUi.primary : ColorsUi.greyDark,
                  width: 1.5.w),
              color: value ? ColorsUi.primary : ColorsUi.white),
          child: value
              ? Icon(
                  Icons.done,
                  color: Colors.white,
                  size: 20.r,
                )
              : null,
        ));

    switch (controlAffinity) {
      case ListTileControlAffinity.leading:
        leading = control;
        trailing = secondary;
        break;
      case ListTileControlAffinity.trailing:
        leading = secondary;
        trailing = control;
        break;
      case ListTileControlAffinity.platform:
       // if (Directionality.of(context) == TextDirection.rtl) {
          leading = control;
          trailing = secondary;
      //  } else {
       //   leading = secondary;
       //   trailing = control;
       // }
        break;
    }

    return TextButton(
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            shape: shape,
            visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: AlignmentDirectional.centerStart),
        onPressed: enabled ? () => onChanged(!value) : null,
        child: Row(
          children: [
       leading,
            SizedBox(
              width: 4.w,
            ),
            isExpanded?Expanded(child: title ??
                TextCustom(titleText ?? "",
                    size: fountSize.sp, color: ColorsUi.black, height: 1.1)):
            title ??
                TextCustom(titleText ?? "",
                    size: fountSize.sp, color: ColorsUi.black, height: 1.1),
            SizedBox(
              width: 4.w,
            ),
            trailing
          ],
        ));
  }
}
