
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'color.dart';
import 'founts.dart';

InputDecorationTheme createInputDecorationTheme() {
  return InputDecorationTheme(
    fillColor: ColorsUi.white,
    floatingLabelStyle: TextStyle(color: ColorsUi.black, fontSize: 16.sp),
    errorStyle: TextStyle(
      fontSize:  12.sp,
      fontWeight: FontWeight.normal,
      height: 1.5.h,
    ),
    hintStyle: TextStyle(fontSize: 14.sp, color: ColorsUi.greyDark.withOpacity(.5),fontFamily:Founts.normal,height: .5.h),
    labelStyle: TextStyle(fontSize: 14.sp, color: ColorsUi.greyDark,height: .5.h,fontFamily:Founts.normal,),

    isDense: true,
    // contentPadding: EdgeInsets.symmetric(vertical: 18.h,horizontal: 5.w),
    // floatingLabelStyle: const TextStyle(color: AppColors.primary),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: ColorsUi.primary),
      borderRadius: BorderRadius.all(Radius.circular(23.r))
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: ColorsUi.inputBorder,),
      borderRadius: BorderRadius.all(Radius.circular(23.r))
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: ColorsUi.greyF7),
        borderRadius: BorderRadius.all(Radius.circular(23.r))
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: ColorsUi.red, width: 1,),
        borderRadius: BorderRadius.all(Radius.circular(23.r))
    ),
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFD7D7D7)),
      borderRadius: BorderRadius.all(Radius.circular(23.r))
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: ColorsUi.red),
      borderRadius: BorderRadius.all(Radius.circular(23.r))
    ),
  );
}
