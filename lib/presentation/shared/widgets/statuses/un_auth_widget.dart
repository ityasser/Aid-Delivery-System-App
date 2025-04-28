import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/app.dart';
import '../../../../core/constant/imagepath.dart';
import '../../../../core/customs/custom_button.dart';
import '../../../../core/customs/custom_text.dart';
import '../../../../core/theme/color.dart';
import '../../../../core/utils/local.dart';
import '../../../pages/login/login_screen.dart';


class UnAuthWidget extends StatelessWidget {
  // const EmptyEstateWidgets({Key? key}) : super(key: key);
  Function()? onPressed;
  UnAuthWidget({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(ImagePath.unAuthImage),
            SizedBox(height: 50.h,),
            CustomText(AppLocal.getString().sorry_not_logged_in,color: ColorsUi.grayBlue),
            SizedBox(height: 30.h,),
            CustomButton(
              height: 45.h,width: 210.w,
              onPressed: onPressed??(){
                Navigator.pushAndRemoveUntil(
                  App.context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false,
                );
              },text: AppLocal.getString().login,)
          ],



        ),
      ),
    );
  }
}
