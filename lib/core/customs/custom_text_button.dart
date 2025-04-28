import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nocommission_app/core/customs/custom_text.dart';
import 'package:nocommission_app/core/theme/color.dart';
import 'package:nocommission_app/core/theme/founts.dart';

class CustomTextButton extends StatelessWidget {
  String? text;
  Function()? onPressed;
  double fontSize;
  Color fontColor;
  Color? color;
  Widget? iconTrailing;
  Widget? iconLeading;
  String? fontFamily;
  OutlinedBorder? shape;
  EdgeInsetsGeometry padding;
  Color? backgroundColor;
  AlignmentGeometry? alignment;

  CustomTextButton({
    this.text ,
    this.onPressed,
    this.fontColor = ColorsUi.primary,
    this.fontSize = 14,
    this.fontFamily ,
    this.color,
    this.iconTrailing,
    this.iconLeading,
    this.shape,
    this.padding=EdgeInsetsDirectional.zero,
    this.backgroundColor,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    Widget?leading,trailing;
    if (Directionality.of(context) == TextDirection.ltr) {
      leading = iconLeading;
      trailing = iconTrailing;
    } else {
      leading = iconTrailing;
      trailing = iconLeading;
    }
    return TextButton(

        style: TextButton.styleFrom(
            //padding: padding,
            minimumSize: Size.zero,
            visualDensity: VisualDensity(vertical: -4, horizontal: -4),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: shape,
            backgroundColor: backgroundColor,
            alignment:alignment?? AlignmentDirectional.centerStart),
        onPressed: onPressed,
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,

            children: [
              if(leading!=null)leading,
              if(leading!=null&&text!=null)SizedBox(width: 4.w,),
              TextCustom(text ?? "",
                  size: fontSize.sp, color: fontColor, height: 1.1,fontFamily: fontFamily),
              if(trailing!=null)SizedBox(width: 4.w,),
              if(trailing!=null)trailing,
            ],
          ),
        ));
  }
}
