import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aid_registry_flutter_app/core/customs/custom_text.dart';

import '../../../../core/constant/imagepath.dart';
import '../../../../core/customs/custom_button.dart';
import '../../../../core/theme/color.dart';
import '../../../../core/utils/local.dart';


class NoInternetWidget extends StatelessWidget {
  // const EmptyEstateWidgets({Key? key}) : super(key: key);
  Function()? onPressed;
  NoInternetWidget({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(ImagePath.noNetImage),
            SizedBox(height: 50.h,),
            CustomText(AppLocal.getString().make_sure_net,color: ColorsUi.grayBlue),
            SizedBox(height: 30.h,),
            CustomButton(
              height: 45.h,width: 210.w,
              onPressed: onPressed??(){},text: AppLocal.getString().try_again,)
          ],



        ),
      ),
    );
  }
}
