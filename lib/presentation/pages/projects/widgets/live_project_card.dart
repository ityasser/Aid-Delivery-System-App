import 'package:aid_registry_flutter_app/core/customs/custom_text.dart';
import 'package:aid_registry_flutter_app/core/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:aid_registry_flutter_app/core/customs/chaed_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/founts.dart';
import '../../../../data/aid.dart';
import '../../../../data/project.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LiveProjectCard extends StatelessWidget {
  final Project item;
  VoidCallback? onTapDown;
  VoidCallback? onTapExportExcel;
  VoidCallback? onTapUpload;

  LiveProjectCard({Key? key, required this.item,this.onTapDown,this.onTapExportExcel,this.onTapUpload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              item.title??"",
              size: 16.sp,
              fontFamily: Founts.medium
            ),
            SizedBox(height:15.h),
            CustomText(
                item.date??"",
                size: 12.sp,
                fontFamily: Founts.normal,
              color: ColorsUi.grey
            ),

            SizedBox(height:10.h),
            CustomText(
                item.note??"",
                size: 12.sp,
                fontFamily: Founts.normal,
                color: ColorsUi.black,
            ),

            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onTapDown,
                    icon: Icon(FontAwesomeIcons.download,color: Colors.white,),
                    label: CustomText(
                    "تحميل",
                      size: 11.sp,
                      fontFamily: Founts.normal,
                      color: ColorsUi.white,
                    ) ,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}

