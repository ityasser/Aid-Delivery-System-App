import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:aid_registry_flutter_app/core/utils/extension.dart';

import '../../../core/constant/imagepath.dart';
import '../../../core/customs/custom_button.dart';
import '../../../core/customs/custom_text.dart';
import '../../../core/customs/logo_widget.dart';
import '../../../core/customs/text_field_custom.dart';
import '../../../core/models/loading_status.dart';
import '../../../core/theme/color.dart';
import '../../../core/theme/founts.dart';
import '../../../core/utils/local.dart';
import 'login_notifier.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({Key? key}) : super(key: key);
  final loginProvider = StateNotifierProvider<LoginNotifier, ReqStatus>(
    (ref) => LoginNotifier(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginStatus = ref.watch(loginProvider.notifier);
    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ColorsUi.white,
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: ColorsUi.white,
          toolbarHeight: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: ColorsUi.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
          ),
        ),
        body:  Center(
      child: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: 30.w, end: 30.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: AlignmentDirectional.center,
              child: SvgPicture.asset(ImagePath.logo, fit: BoxFit.contain),
            ),
            SizedBox(height: 40.h),
            Align(
              alignment: AlignmentDirectional.center,
              child: CustomText(
                AppLocal.getString().appName.toTitleCase(),
                size: 18.sp,
                fontFamily: Founts.medium,
              ),
            ),
            SizedBox(height: 100.h),
            ConstrainedBox(
              constraints:  BoxConstraints(maxWidth: 400.w),
              child: Form(
                key: loginStatus.loginKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: CustomText(
                        AppLocal.getString().email.toTitleCase(),
                        size: 14,
                        fontFamily: Founts.normal,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    TextFieldCustom(
                      controller: loginStatus.emailController,
                      validator: (value) => loginStatus.validateEmail(value!),
                      hintText: 'example@gmail.com',
                      textInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: CustomText(
                        AppLocal.getString().password.toTitleCase(),
                        size: 14,
                        fontFamily: Founts.normal,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    TextFieldCustom(
                      controller: loginStatus.passwordController,
                      validator: (value) => loginStatus.validatePassword(value!),
                      obscureText: true,
                      textInputType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (v) {

                        if (loginStatus.loginKey.currentState!.validate()) {
                          loginStatus.login();
                        }
                      },
                    ),
                    SizedBox(height: 35.h),
                    Align(
                      alignment: AlignmentDirectional.center,
                      child: CustomButton(
                        text: AppLocal.getString().login.toTitleCase(),
                        onPressed: () {
                          if (loginStatus.loginKey.currentState!.validate()) {
                            loginStatus.login();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    ),
    ),
          ),
    );
  }
}
