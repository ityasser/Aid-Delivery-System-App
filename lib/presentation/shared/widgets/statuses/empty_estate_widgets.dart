import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';


import '../../../../core/constant/imagepath.dart';
import '../../../../core/customs/custom_button.dart';
import '../../../../core/customs/custom_text.dart';
import '../../../../core/theme/color.dart';
import '../../../../core/utils/local.dart';

class EmptyEstateWidgets extends StatelessWidget {
  // const EmptyEstateWidgets({Key? key}) : super(key: key);
  Function()? onPressed;
  EmptyEstateWidgets({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(ImagePath.emptyImage),
          SizedBox(height: 20.h,),
          CustomText(AppLocal.getString().sorry_there_are_no_properties,color: ColorsUi.grayBlue),
          SizedBox(height: 30.h,),
          CustomButton(
            height: 45.h,width: 210.w,
            onPressed: onPressed??(){},text: "${AppLocal.getString().go_to} ${AppLocal.getString().home}",)
        ],



      ),
    );
  }
}
