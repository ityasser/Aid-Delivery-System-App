import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nocommission_app/core/theme/color.dart';

import 'piker_map.dart';


Future showPikerMapSheet(BuildContext context,  {LatLng? initial,
  Function(LatLng)? onPressedConfirm,isPadding = true,enable=true}) async {
  showModalBottomSheet(
    useRootNavigator: true,
    context: context,
    backgroundColor: ColorsUi.white,
    elevation: 5,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        )),
    clipBehavior: Clip.antiAlias,
    isDismissible: true,
    // barrierColor: barrierColor,
    enableDrag: true,
    isScrollControlled: true,
    builder: (context) =>
        DraggableScrollableSheet(
          initialChildSize: 0.90,
          //set this as you want
          maxChildSize: 0.96,
          //set this as you want
          minChildSize: 0.30,
          //set this as you want
          expand: false,
          snapSizes: [0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9],
          snap: false,
          builder: (context, scrollController) =>
              Container(
                color: Colors.white,
                //  margin:EdgeInsetsDirectional.only(top: 10,bottom: 95.h) ,
                padding:
                EdgeInsetsDirectional.only(

                   /* bottom: isPadding ? MediaQuery
                        .of(context)
                        .viewInsets
                        .bottom : 10.h,
                    top:MediaQuery
                        .of(context)
                        .viewInsets
                        .top+0*/
                ),
                child: ClipRRect(
                  borderRadius:  BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),

                  child: PikerMap(
                    enable: enable,
                    initial: initial,
                    onPressedConfirm: (value) async {

                      if(onPressedConfirm!=null){
                        onPressedConfirm(value);
                      }

                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
        ),
  );
}

