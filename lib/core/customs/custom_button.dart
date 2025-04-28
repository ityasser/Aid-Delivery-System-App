import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/color.dart';
import '../theme/founts.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final double radius;
  final double fontSize;
  final Color fontColor;
  final double height;
  final double width;
  final Color? color;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;
  final bool showBorder;

  const CustomButton({
    Key? key,
    this.text,
    required this.onPressed,
    this.radius = 23,
    this.fontColor = ColorsUi.fount_button,
    this.fontSize = 16,
    this.height = 45,
    this.width = 176,
    this.color=ColorsUi.bac_button,
    this.icon,
    this.padding,
    this.showBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.of(context), // تأكد من وجود Directionality
      child: SizedBox(
        width: width.w,
        height: height.h,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.r),
              side: showBorder ? BorderSide(color: Colors.transparent) : BorderSide.none,
            ),
            backgroundColor: color ?? Colors.transparent,
            padding: padding ?? EdgeInsets.zero,
            shadowColor: Colors.transparent,
            visualDensity: VisualDensity.compact,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) icon!,
              if (icon != null && text != null) SizedBox(width: 5.w),
              if (text != null)
                CustomText(
                  text!,
                  size: fontSize,
                  color: fontColor,
                  height: 0.9.h,
                  textOverflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
