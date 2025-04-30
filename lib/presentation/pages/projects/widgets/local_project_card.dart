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

class LocalProjectCard extends StatelessWidget {
  final Project item;
  VoidCallback? onTapRemove;
  VoidCallback? onTap;
  VoidCallback? onTapExportExcel;
  VoidCallback? onTapExportExcelNotReceived;
  VoidCallback? onTapUpdate;
  VoidCallback? onTapExportReceivedPdf;
  VoidCallback? onTapExportNonReceivedPdf;
  int? countReceived;
  int? countNonReceived;

  LocalProjectCard({Key? key, required this.item,this.onTapRemove,this.countReceived,this.countNonReceived,this.onTapExportExcel,this.onTapUpdate,this.onTapExportNonReceivedPdf,this.onTap,this.onTapExportExcelNotReceived,this.onTapExportReceivedPdf}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(

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
                  ),
                ],
              ),
              SizedBox(height: 20.h,),
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
                  ), ElevatedButton.icon(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

