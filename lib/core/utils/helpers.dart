import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' as intl;
import 'package:aid_registry_flutter_app/core/utils/extension.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app.dart';
import '../theme/color.dart';
import 'my_route.dart';
import 'package:oktoast/oktoast.dart';

mixin Helpers {
  bool isHtml(String text) {
    final regex = RegExp(r'<[^>]*>');
    return regex.hasMatch(text);
  }
  Map<String, dynamic> listToMapIds<M>(List<M>list,int? Function(M? data) getId,{String key="ids"}) {
    Map<String, dynamic> m={};
    for (var i = 0; i < list.length; i++) {
        m.add("$key[$i]",getId(list[i]));
    }
    return m;
  }
  Map<String, dynamic> listPropertiesToMapIds<M>(List<M>list,dynamic Function(M? data) value,int? id) {
    Map<String, dynamic> m={};
    for (var i = 0; i < list.length; i++) {
      if(value(list[i])==null)
        m.remove("properties[$id][$i]");
      else
      m["properties[$id][$i]"]=value(list[i]);
    }
    return m;
  }

  Future<T?> push<T>(
    BuildContext context, {
    required dynamic screen,
    bool withNavBar = false,
    TransitionType? transitionType,
    bool removeUntil=false,
  }) {
    return removeUntil?Navigator.of(context, rootNavigator: withNavBar).pushAndRemoveUntil<T>( MyRoute(
    builder: (context) {
    return screen;
    },
    type: transitionType), (Route<dynamic> route) => false,):Navigator.of(context, rootNavigator: withNavBar).push<T>(MyRoute(
        builder: (context) {
          return screen;
        },
        type: transitionType));
  }

  void showMessage(String message, {error = true,Color? color}) {
    // showToast('content');

// position and second have default value, is optional
    showToastWidget(Text('hello oktoast'),position: ToastPosition.bottom,);
    if (message.isNotEmpty) {
        showToastWidget(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: color == null ? error
                  ? Color(0xFFEB5757).withOpacity(.9)
                  : ColorsUi.green.withOpacity(.9) : color.withOpacity(.9),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white,),
                  ),
                ),
              ],
            ),
          ),
          position: ToastPosition.bottom,
          duration: Duration(seconds: 3),
          dismissOtherToast: true,
        );


      /* Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 16,
        textColor: Colors.white,
        backgroundColor: color == null ? error
            ? Color(0xFFEB5757).withOpacity(.9)
            : ColorsUi.green.withOpacity(.9) : color.withOpacity(.9),
      );*/

    }
  }

  static String formatTimeOfDay(TimeOfDay tod, intl.DateFormat format) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    //  final formatv = format;//DateFormat.Hm();  //"6:00 AM"
    return format.format(dt);
  }

  static String? formatDateTime(DateTime tod, intl.DateFormat format) {
    return format.format(tod);
  }


  // void showSnackBar({
  //   required BuildContext context,
  //   required String content,
  //   bool error = false,
  // }) {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text(content),
  //     behavior: SnackBarBehavior.floating,
  //     backgroundColor: error ? Colors.red : CustomColors.mainColor,
  //   ));
  // }
  // GlobalKey<NavigatorState>? dialogKey;


  void openWhatsApp(String phone) async {
    final uri = Uri.parse("https://wa.me/$phone"); // أو استخدام "whatsapp://send?phone=$phone"
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      showMessage("لا يمكن فتح واتساب",error: true);
    }
  }
}
