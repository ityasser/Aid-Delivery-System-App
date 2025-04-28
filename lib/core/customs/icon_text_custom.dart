
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nocommission_app/core/theme/color.dart';

import 'custom_text.dart';

Widget IconTextCustom(
    {required String iconPath, required String text,Color? textColor,double sizeText=13,double sizeIcon=20,double sizeBoxIcon=20}) {


  return Row(
    children: [
      SizedBox(
          width: sizeBoxIcon.w,
          height: sizeBoxIcon.h,
        child: Align(
          alignment: Alignment.center,
          child: SvgPicture.asset(
            iconPath,
            width:sizeIcon.w,
            height: sizeIcon.h,
          ),
        ),
      ),
      SizedBox(width:5.w),
      TextCustom(
        text,
        color: textColor??ColorsUi.blackItem,
        size: sizeText.sp,
      ),
    ],
  );


}
