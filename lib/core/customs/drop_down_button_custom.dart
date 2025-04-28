import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nocommission_app/core/customs/custom_text.dart';

import '../theme/color.dart';

class DropdownButtonCustom extends StatelessWidget {
  DropdownButtonCustom({this.onTap, required this.dropdownValue, this.hintText, this.icon});

  String? dropdownValue;
  String? hintText;
  String? icon;
  GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon??"",
            color: ColorsUi.greyIcon,
            width: 14.w,height: 14.h,
          ),SizedBox(width: 5.w,),
          Expanded(
            child: TextCustom("${dropdownValue??hintText??''}",
                color: dropdownValue != null
                    ? ColorsUi.black
                    : ColorsUi.greyDark,size: 12.sp,
                height: 1.h),
          ),
          Icon(
            Icons.expand_more,
            color: ColorsUi.greyDark,
            size: 15.sp,
          ),

        ],
      ),
    );
  }
}
