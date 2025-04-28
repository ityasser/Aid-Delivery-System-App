import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/color.dart';
import '../theme/founts.dart';


Widget CustomText(String text,
    {double size = 15,
      Color? color,
      FontWeight? fontWeight = FontWeight.normal,
      double? height=1.5,
      int? maxLine ,
      String? fontFamily,
      TextAlign align = TextAlign.start,
      TextOverflow textOverflow = TextOverflow.visible,
      TextDecoration decoration = TextDecoration.none,
      bool? softWrap,
      TextDirection? textDirection,}) {
  return Text(
    text,
    textAlign: align,
    maxLines: maxLine,
    softWrap: softWrap,
    textDirection: textDirection,
    style: TextStyle(
      color: color??ColorsUi.black,
      fontSize: size,
      fontWeight: fontWeight,
      height: height?.h,
      decoration: decoration,
      letterSpacing: 0,
      fontFamily: fontFamily??Founts.normal
    ),
    overflow: textOverflow,
  );
}
