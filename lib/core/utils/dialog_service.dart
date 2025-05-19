import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../presentation/pages/login/login_screen.dart';
import '../app.dart';
import '../customs/custom_button.dart';
import '../customs/logo_widget.dart';
import '../customs/spinning_lines_loading.dart';
import '../customs/custom_text.dart';
import '../customs/text_field_custom.dart';
import '../theme/color.dart';
import '../theme/founts.dart';

mixin DialogService {
  void showDialog(
    String title,
    Function()? onPress, {
    bool? withBody,
    Function()? onCancel,
    Function(DismissType)? onDismissCallback,
    String? okText,
    String? desc,
    String? pathImage,
    String? cancelText,
    Widget? body,
    bool? showCloseIcon,
    bool? dismissOnTouchOutside,
    Color? btnOkColor,
    Color? btnCancelColor,
  }) {
    AwesomeDialog(
      context: App.context,
      dialogType: DialogType.noHeader,
      dismissOnTouchOutside: dismissOnTouchOutside ?? true,
      animType: AnimType.scale,
      btnOk: CustomButton(
        onPressed: onPress,
        color: btnOkColor,
        text: okText ?? App.getString().done,
        height: 35.h,
      ),
      btnCancel: CustomButton(
        onPressed:
            onCancel ??
            () {
              if (Navigator.canPop(App.context)) {
                Navigator.pop(App.context);
              }
            },
        color: btnCancelColor,
        text: cancelText ?? App.getString().cancel,
        height: 35.h,
      ),
      onDismissCallback: onDismissCallback,
      buttonsTextStyle: TextStyle(
        fontFamily: Founts.normal,
        fontSize: 14.sp,
        height: .8.h,
      ),
      body:
          withBody ?? false
              ? body
              : Column(
                children: [
                  pathImage == null
                      ? LogoWidget(size: 50.sp)
                      : SvgPicture.asset(pathImage),
                  SizedBox(height: 15.h),
                  CustomText(
                    title,
                    color: ColorsUi.black,
                    fontFamily: Founts.normal,
                  ),
                  desc != null ? SizedBox(height: 10.h) : SizedBox(),
                  desc != null
                      ? CustomText(desc, color: ColorsUi.black)
                      : SizedBox(),
                  SizedBox(height: 10.h),
                ],
              ),

      title: title,
      desc: desc,
      closeIcon: Icon(Icons.close, color: ColorsUi.greyDark, size: 16.sp),
      showCloseIcon: showCloseIcon ?? false,
    ).show();
  }

  static void showDialogUnauthorized() async {
    print("showDialogUnauthorized");
    await Future.delayed(Duration(milliseconds: 200)).then(
      (value) =>
          AwesomeDialog(
            context: App.context,
            dialogType: DialogType.info,
            animType: AnimType.bottomSlide,
            desc: App.getString().please_login,
            btnOkText: App.getString().login,
            btnCancelText: App.getString().cancel,
            buttonsTextStyle: TextStyle(height: 1.h),
            btnCancelOnPress: () {
              /*  Get.deleteAll();
        Get.offAll(SignupScreen());*/
            },
            btnOkOnPress: () {
              /*Get.deleteAll();
        Get.offAll(LoginScreen());*/

              Navigator.pushAndRemoveUntil(
                App.context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ).show(),
    );
  }

  void showFullLoading() {
    showGeneralDialog(
      context: App.context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: ColorsUi.secondary.withOpacity(0.2),
            body: Center(
              child: SpinKitSpinningLines(
                color: ColorsUi.primary,
                size: 100,
                lineWidth: 5,
                itemCount: 6,
              ),
            ),
          ),
        );
      },
    );
  }

  void showLoading() {
    showGeneralDialog(
      context: App.context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: SpinKitSpinningLines(
                color: ColorsUi.primary,
                size: 100,
                lineWidth: 5,
                itemCount: 6,
              ),
            ),
          ),
        );
      },
    );
  }

  static AwesomeDialog? _loadingDialog;

  void showLoadingc() {
    hideLoading();
    _loadingDialog = AwesomeDialog(
      context: App.context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      dialogBackgroundColor: Colors.transparent,

      dialogBorderRadius: BorderRadius.all(Radius.circular(0)),
      // إزالة الحدود
      width: MediaQuery.of(App.context).size.width + 100,

      padding: EdgeInsets.all(0),
      barrierColor: Colors.transparent,
      body: SpinKitSpinningLines(
        color: ColorsUi.primary,
        size: 100,
        lineWidth: 5,
        itemCount: 6,
      ),
    )..show();
  }

  static void hideFullLoading() {
    if (Navigator.canPop(App.context)) {
      Navigator.pop(App.context);
    }
  }

  static void hideLoading() {
    if (_loadingDialog != null) {
      _loadingDialog!.dismiss();
      _loadingDialog = null;
    }
  }

  void dismissLoading() {
    if (_loadingDialog != null) {
      _loadingDialog!.dismiss();
      _loadingDialog = null;
    } else {
      Navigator.of(App.context).pop();
    }
  }

  static Future<void> showMessageDialog({
    String? title,
    String? description,
    DialogType? dialogType,
    String? labelNote,
    String? note,
    String? btnOkText,
  Widget? body,
    Function(String? note)? btnOkOnPress
  }) async {
    TextEditingController _noteController = TextEditingController(text: note);


    await Future.delayed(Duration(milliseconds: 0)).then(
      (value) =>
          AwesomeDialog(

            context: App.context,
            width:700.w,

            dialogType: dialogType ?? DialogType.info,
            animType: AnimType.bottomSlide,
            title: title,
            desc: description,
            body: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 700.w),
                child: body?? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CustomText(
                        title ?? "",
                        color: Colors.black,
                        fontFamily: Founts.medium,
                      ),
                      SizedBox(height: 30.h),
                      CustomText(
                        description ?? "",
                        color: Colors.black,
                        fontFamily: Founts.normal,
                        align: TextAlign.center,
                        height: 1.5
                      ),
                      SizedBox(height: 30.h),
                      if(labelNote!=null)
                        TextFieldCustom(
                        labelHint: labelNote,
                        hintText: "ادخل $labelNote",
                        controller: _noteController,
                        textAlign: TextAlign.justify,
                        minLines: 3,
                        heightFont: 1.5,
                        maxLine: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            buttonsTextStyle: TextStyle(height: 1.h,color: Colors.white),
            btnOkText: btnOkText,//??App.getString().confirm,
            btnCancelText: App.getString().cancel,

            btnOkOnPress: (btnOkOnPress!=null)?() =>btnOkOnPress(_noteController.text):null,

            btnCancelOnPress: () {
            },
          ).show(),
    );

  }
}
