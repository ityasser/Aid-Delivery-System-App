import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constant/imagepath.dart';
import '../theme/color.dart';


class LogoWidget extends StatelessWidget {
  // const LogoWidget({Key? key}) : super(key: key);

  double size;
  LogoWidget({this.size=70});

  double percentage=0.85526315789473684210526315789474;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: (size*percentage).h,width: size.w,

      padding: EdgeInsets.symmetric(vertical:  ((size*percentage)*0.25).h,horizontal: (size*0.25).w,),
      decoration: BoxDecoration(
          gradient: ColorsUi.gradientLogo,
          borderRadius: BorderRadius.all(Radius.circular(15.r))
      ),
      child: SvgPicture.asset(ImagePath.logo,fit:BoxFit.contain,)
    );
  }
}
