import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/color.dart';
import 'custom_text.dart';

class CustomCheckBox extends StatelessWidget {
  CustomCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.checkColor,
    this.enabled = true,
    this.fountFamily,
    this.tileColor,
    this.title,
    this.titleText,
    this.subtitle,
    this.isThreeLine = false,
    this.dense,
    this.secondary ,
    this.selected = false,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.autofocus = false,
    this.contentPadding,
    this.checkBoxSize = 22,
    this.shape ,
    this.padding ,
    this.isExpanded = false,
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
  final String? fountFamily;

  final Widget? subtitle;

  final Widget? secondary;

  final bool isThreeLine;

  final bool? dense;

  final bool selected;

  final ListTileControlAffinity controlAffinity;

  final bool autofocus;

  final EdgeInsetsGeometry? contentPadding;

  final OutlinedBorder? shape;

  final Color? selectedTileColor;
  final EdgeInsetsGeometry? padding;

  final BorderSide? side;

  final VisualDensity? visualDensity;

  final FocusNode? focusNode;

  final bool? enableFeedback;

  final bool enabled;
  final double checkBoxSize;
  bool isExpanded;

  @override
  Widget build(BuildContext context) {
    Widget? leading;
    Widget? trailing;

    Widget control = IconButton(
      visualDensity: VisualDensity(vertical:-4,horizontal:-4),
      padding:padding?? EdgeInsets.zero,
      splashRadius: splashRadius ?? 20.r,
        onPressed: enabled ? () => onChanged(!value) : null,
        icon: Container(
          width: checkBoxSize,
          height: checkBoxSize,
          padding: EdgeInsets.all(2.5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6.r)),
              border: Border.all(
                  color: value ? ColorsUi.primary : ColorsUi.greyDark,
                  width: 1.5.w),
              color: ColorsUi.white),
          child: Container(
            width: checkBoxSize,
            height: checkBoxSize,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.r)),
                color: value ? ColorsUi.primary : ColorsUi.white),
          ),
        ));

    Widget controlx = Transform.scale(
      scale: 1 + ((checkBoxSize) / 100),
      child: Checkbox(
        value: value,
        onChanged: enabled ? (v) => onChanged(v!) : null,
        activeColor: activeColor,
        checkColor: checkColor,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        autofocus: autofocus,
        shape: shape,
        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
        splashRadius: splashRadius ?? 3.r,
        side: side,
      ),
    );

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
        if (Directionality.of(context) == TextDirection.rtl) {
          leading = control;
          trailing = secondary;
        } else {
          leading = control;
          trailing =secondary ;
        }
        break;
    }



    return TextButton(

        style: TextButton.styleFrom(
          shape: shape,
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
            visualDensity:
            const VisualDensity(vertical: -4, horizontal: -4),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: AlignmentDirectional.centerStart),

        onPressed: enabled ? () => onChanged(!value) : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(leading!=null)
              leading,
            SizedBox(
              width: 4.w,
            ),
            isExpanded?Expanded(child:title ??  CustomText(titleText ?? "", size: 15.sp, color: ColorsUi.black, height: 1.h,fontFamily:fountFamily )
            ):
            title ?? CustomText(titleText ?? "", size: 15.sp, color: ColorsUi.black, height: 1.h,fontFamily: fountFamily)  ,
            SizedBox(
              width: 4.w,
            ),
            if(trailing!=null)trailing
          ],
        ));
  }
}
