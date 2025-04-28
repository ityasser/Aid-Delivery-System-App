import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constant/imagepath.dart';
import '../../../../core/customs/custom_text.dart';
import '../../../../core/theme/color.dart';
import '../../../../core/utils/local.dart';

class EmptyWidgets extends StatelessWidget {
  // const EmptyEstateWidgets({Key? key}) : super(key: key);
  Function()? onPressed;
  EmptyWidgets({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(ImagePath.emptyImage,height: 200.h,width: 200.w,),
          SizedBox(height: 20.h,),
          CustomText(AppLocal.getString().no_results_found,color: ColorsUi.grayBlue),
          SizedBox(height: 30.h,),
          //CustomButton(height: 45.h,width: 210.w, onPressed: onPressed??(){},text: "${AppLocal.getString().go_to} ${AppLocal.getString().home}",)
        ],



      ),
    );
  }
}
