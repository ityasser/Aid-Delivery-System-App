import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nocommission_app/core/customs/custom_text.dart';
import 'package:nocommission_app/core/theme/color.dart';
import 'package:nocommission_app/core/theme/founts.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  // const AppBarCustom({Key? key}) : super(key: key);
  String? title;
  List<Widget>? actions;
  Widget? leading;
  bool? centerTitle;
  double? leadingWidth;
  double? elevation;
  Function()? back;

  AppBarCustom({this.title, this.actions, this.leading, this.centerTitle, this.leadingWidth,this.back,this.elevation});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: ColorsUi.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,

        ),titleSpacing: 0,leadingWidth: leadingWidth,
        title: TextCustom(title ?? '',height: 0.8.h,
            size: 16.sp, fontFamily: Founts.mediumFount),
        centerTitle: centerTitle ?? true,
        actions: actions ?? [],

        leading: leading ??
            IconButton(
                visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                padding: EdgeInsets.zero,
                splashRadius: 25.r,
                iconSize: 28.r,
                onPressed:back?? () {
                  Get.back();
                },
                icon: Icon(
                  Icons.chevron_left_rounded,
                )),
    elevation:elevation??4 ,);
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(50.h);
}
