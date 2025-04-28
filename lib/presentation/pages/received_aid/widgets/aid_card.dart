import 'package:aid_registry_flutter_app/core/customs/custom_text.dart';
import 'package:aid_registry_flutter_app/core/theme/founts.dart';
import 'package:aid_registry_flutter_app/data/person.dart';
import 'package:flutter/material.dart';
import 'package:aid_registry_flutter_app/core/customs/chaed_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../data/aid.dart';

class AidCard extends StatelessWidget {
  final Person item;
  final VoidCallback? onPressed;

  const AidCard({Key? key, required this.item,this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),color: Colors.white,
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [CustomText(item.fullName, fontFamily: Founts.medium,size: 12.sp),CustomText(item.person_pid??"", fontFamily: Founts.medium,size:12.sp)],),
        subtitle: Row(children: [CustomText(item.mobile??"", fontFamily: Founts.medium,size: 12.sp),],),
        trailing:item.isReceived ? IconButton(
            icon: Icon(Icons.check_box),
            color:  Colors.green,
            onPressed:onPressed) : IconButton(
          icon: Icon(Icons.check_box_outline_blank),
          color:  Colors.grey,
          onPressed:onPressed),
      ),
    );
  }
}
