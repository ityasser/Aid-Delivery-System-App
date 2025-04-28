import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nocommission_app/core/customs/custom_text.dart';
import 'package:nocommission_app/core/theme/color.dart';
import 'package:nocommission_app/core/theme/founts.dart';

class CustomIconButton extends StatelessWidget {
  Function()? onPressed;
  Color? color;
  Widget icon;
  OutlinedBorder? shape;
  EdgeInsetsGeometry? padding;
  Color? backgroundColor;
  AlignmentGeometry? alignment;
  double? splashRadius;
  double iconSize;

  CustomIconButton({
    this.onPressed,
    this.color,
    required this.icon,
    this.shape,
    this.splashRadius,
    this.iconSize=25,
    this.padding,
    this.backgroundColor,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {

    return IconButton(
      visualDensity: VisualDensity(vertical: -4, horizontal: -4),
      padding: padding??EdgeInsetsDirectional.zero,
        constraints: BoxConstraints(maxWidth: iconSize,minHeight: iconSize),
        style: TextButton.styleFrom(
            padding: padding??EdgeInsetsDirectional.zero,
            minimumSize: Size.zero,
            maximumSize: Size(iconSize, iconSize),
            visualDensity: VisualDensity(vertical: -4, horizontal: -4),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: shape,
            backgroundColor: backgroundColor,
            alignment:alignment?? AlignmentDirectional.centerStart),
        onPressed: onPressed,
      iconSize:iconSize,
      splashRadius:splashRadius,
      color: color,
        icon: icon,

        );
  }
}
