import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constant/imagepath.dart';
import '../../../../core/customs/custom_button.dart';
import '../../../../core/customs/custom_text.dart';
import '../../../../core/theme/color.dart';
import '../../../../core/utils/local.dart';

class ErrorWidgets extends StatelessWidget {
  // const EmptyEstateWidgets({Key? key}) : super(key: key);
  Function()? onPressed;
  String? error;
  ErrorWidgets({this.onPressed,this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(ImagePath.errorImage),
            SizedBox(height: 30.h,),
            CustomText(error??AppLocal.getString().error,color: ColorsUi.black),
            SizedBox(height: 15.h,),
            CustomText(AppLocal.getString().error_try_again,color: ColorsUi.grayBlue),
            SizedBox(height: 30.h,),
            CustomButton(
              height: 40.h,width: 210.w,
              onPressed: onPressed??(){},text: AppLocal.getString().try_again,)
          ],



        ),
      ),
    );
  }
}
