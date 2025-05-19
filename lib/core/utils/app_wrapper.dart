import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppWrapper extends StatelessWidget {
  final Widget Function(BuildContext context) builder;

  const AppWrapper({Key? key, required this.builder}) : super(key: key);

  bool get isDesktop => [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final Size windowSize = constraints.biggest;
        final clampedWidth = windowSize.width.clamp(1024.0, 1440.0);
        final clampedHeight = windowSize.height.clamp(720.0, 900.0);
        return ScreenUtilInit(
          designSize: isDesktop
              ? Size(windowSize.width, windowSize.height)
              : const Size(390, 815),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return builder(context);
          },
        );
      },
    );
  }
}
