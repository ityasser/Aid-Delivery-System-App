import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatefulWidget {
  const ShimmerWidget({Key? key}) : super(key: key);

  @override
  _ShimmerWidgetState createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.h),
      child: Container(
        margin: EdgeInsets.only(top: 10.h),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: _enabled,
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 35,
            itemBuilder: (_, __) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  width: getRandomWidth(),
                  height: 12.0.h,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double getRandomWidth() {
    return max(50.w, Random().nextDouble() * 400.w);
  }
}
