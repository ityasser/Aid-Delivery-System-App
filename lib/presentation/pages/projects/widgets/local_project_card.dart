import 'package:aid_registry_flutter_app/core/customs/custom_text.dart';
import 'package:aid_registry_flutter_app/core/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:aid_registry_flutter_app/core/customs/chaed_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/app.dart';
import '../../../../core/theme/founts.dart';
import '../../../../data/aid.dart';
import '../../../../data/project.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LocalProjectCard extends StatelessWidget {
  final Project item;
  VoidCallback? onTapRemove;
  VoidCallback? onTap;
  VoidCallback? onTapExportExcel;
  VoidCallback? onTapExportExcelNotReceived;
  VoidCallback? onTapUpdate;
  VoidCallback? onTapExportReceivedPdf;
  VoidCallback? onTapExportNonReceivedPdf;
  int? countAll;
  int? countReceived;
  int? countNonReceived;

  LocalProjectCard({Key? key, required this.item,this.onTapRemove,this.countAll,this.countReceived,this.countNonReceived,this.onTapExportExcel,this.onTapUpdate,this.onTapExportNonReceivedPdf,this.onTap,this.onTapExportExcelNotReceived,this.onTapExportReceivedPdf}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(

      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: InkWell(

        onTap: onTap,
        hoverColor: Colors.grey.withOpacity(0.1),

        borderRadius: BorderRadius.circular(16),
        radius:16 ,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [CustomText(
                  item.title??"",
                  size: 16.sp,
                  fontFamily: Founts.medium
              ),CustomText(
                  " (${countAll})",
                  size: 16.sp,
                  fontFamily: Founts.medium
              ),],),
              SizedBox(height:15.h),
              CustomText(
                  item.date??"",
                  size: 12.sp,
                  fontFamily: Founts.normal,
                color: ColorsUi.grey
              ),

              SizedBox(height:10.h),
              CustomText(
                  item.aids_name??"",
                  size: 12.sp,
                  fontFamily: Founts.normal,
                  color: ColorsUi.black,
              ),

              SizedBox(height: 16.h),

          LayoutBuilder(
          builder: (context, constraints) {
          double maxWidth = constraints.maxWidth;
          double minButtonWidth = 220;
          // int columns = (maxWidth / minButtonWidth).floor().clamp(1, 6);
          int columns = (constraints.maxWidth / 250).floor().clamp(1, 3);

          double spacing = 12.w;
          double computedWidth = (constraints.maxWidth - (columns - 1) * spacing) / columns;
          // double computedWidth = (maxWidth - ((columns - 1) * spacing)) / columns;

            return Wrap(
        alignment: WrapAlignment.spaceBetween,
                  spacing: spacing,
                  runSpacing: 10.h,
                  children: [
                    _buildButton(
                      width: computedWidth,
                      onPressed: onTapExportExcel,
                      icon: FontAwesomeIcons.fileExcel,
                      label: "المستلمين (${countReceived})",
                      color: Colors.green,
                    ),
                    _buildButton(
                      width: computedWidth,

                      onPressed: onTapExportExcelNotReceived,
                      icon: FontAwesomeIcons.fileExcel,
                      label: "الغير مستلمين (${countNonReceived})",
                      color: Colors.green,
                    ),
                    _buildButton(
                      width: computedWidth,

                      onPressed: onTapExportReceivedPdf,
                      icon: FontAwesomeIcons.filePdf,
                      label: "المستلمين",
                      color: Colors.orange,
                    ),
                    _buildButton(
                      width: computedWidth,

                      onPressed: onTapExportNonReceivedPdf,
                      icon: FontAwesomeIcons.filePdf,
                      label: "الغير مستلمين",
                      color: Colors.orange,
                    ),
                    _buildButton(
                      width: computedWidth,

                      onPressed: onTapUpdate,
                      icon: FontAwesomeIcons.sync,
                      label: "تحديث",
                      color: Colors.green,
                    ),
                    _buildButton(
                      width: computedWidth,
                      onPressed: onTapRemove,
                      icon: FontAwesomeIcons.remove,
                      label: "إغلاق",
                      color: Colors.red,
                    ),
                  ],
                );
          }
              )
              ,
             /* Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [


                  ElevatedButton.icon(
                    onPressed: onTapExportExcel,
                    icon: Icon(FontAwesomeIcons.fileExcel,color:  Colors.white,),
                    label: CustomText(
                      "المستلمين (${countReceived})",

                      size: 11.sp,
                      fontFamily: Founts.normal,
                      color: ColorsUi.white,
                    ) ,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: onTapExportExcelNotReceived,
                    icon: Icon(FontAwesomeIcons.fileExcel,color:  Colors.white,),
                    label: CustomText(
                      "الغير مستلمين (${countNonReceived})",
                      size: 11.sp,
                      fontFamily: Founts.normal,
                      color: ColorsUi.white,
                    ) ,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),

                ],
              ),
              SizedBox(height: 10.h,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  ElevatedButton.icon(
                    onPressed: onTapExportReceivedPdf,
                    icon: Icon(FontAwesomeIcons.filePdf,color:  Colors.white,),
                    label: CustomText(
                      "المستلمين",
                      size: 11.sp,
                      fontFamily: Founts.normal,
                      color: ColorsUi.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),    ElevatedButton.icon(
                    onPressed: onTapExportNonReceivedPdf,
                    icon: Icon(FontAwesomeIcons.filePdf,color:  Colors.white,),
                    label: CustomText(
                      "الغير مستلمين",
                      size: 11.sp,
                      fontFamily: Founts.normal,
                      color: ColorsUi.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  )
                ],
              ),
              SizedBox(height: 10.h,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                ElevatedButton.icon(
                onPressed: onTapUpdate,
                icon: Icon(FontAwesomeIcons.sync,color:  Colors.white,),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ), label:  CustomText(
                "تحديث",
                size: 11.sp,
                fontFamily: Founts.normal,
                color: ColorsUi.white,
              ),
              )
                , ElevatedButton.icon(
                    onPressed: onTapRemove,
                    icon: Icon(FontAwesomeIcons.remove,color: Colors.white,),
                    label: CustomText(
                      "اغلاق",
                      size: 11.sp,
                      fontFamily: Founts.normal,
                      color: ColorsUi.white,
                    ) ,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),*/
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    required Color color,
    required double width,

  }) {
    return SizedBox(
      width: width, // يعطي كل زر عرض 28% من عرض الشاشة
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 16.sp),
        label: CustomText(
          label,
          size: 11.sp,
          fontFamily: Founts.normal,
          color: ColorsUi.white,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
        ),
      ),
    );
  }
}

