import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SliderIndicator extends StatelessWidget {
  double endMargin;
  bool selected;
  Color? color1;
  Color? color2;
  bool isCircle;

  SliderIndicator({
    this.endMargin = 0,
    this.selected = false,
    this.color2,
    this.isCircle = false,
    this.color1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(
        end: endMargin.w,
      ),
      width: isCircle ? 5.w : 23.w,
      height: isCircle ? 5.w : 6.6.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(100.r),
        color: selected ? color1! : color2!,
      ),
    );
  }
}
