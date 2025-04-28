
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget LineThrouh(
    {required Widget child, Color? color}) {
  return Container(
    child: Stack(
      alignment: Alignment.center,
      children: [
        child,

        Positioned(
          left: 0,
          right: 0,
          child: Container(height:1.h,color: color??Colors.grey),
        ),
      ],
    ),
  )
;
  return
    Stack(
      alignment: Alignment.center,
      children: [
       child,
        Positioned(
          child: Container(
            height: 5.0,
            color: Colors. white,
          ),
        ),
      ],
    );
}
