import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app.dart';
import '../../../core/constant/share_pref.dart';
import '../../../core/models/loading_status.dart';
import '../../../core/utils/dialog_service.dart';
import '../../../core/utils/functions.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/user_preference.dart';
import '../../../core/utils/validations.dart';
import '../../../core/web_services/BaseResponse.dart';
import '../../../core/web_services/apis.dart';
import '../../../data/user.dart';
import '../../../databse/objectbox_database.dart';
import '../../../databse/sync_service.dart';
import '../main/MainScreen.dart';

class LoginNotifier extends StateNotifier<ReqStatus>
    with Helpers, Validations, DialogService {
  LoginNotifier() : super(ReqStatus.idle);

  GlobalKey<FormState> loginKey = GlobalKey<FormState>(
    debugLabel: "__form_login_key_loin_1__",
  );
  final TextEditingController emailController = TextEditingController(text:UserPreferences().username);
  final TextEditingController passwordController = TextEditingController(text: UserPreferences().password);
  bool isLoading = false;

  Future<BaseResponse<User>?> login() async {
    try {
      state = ReqStatus.loading;
      showLoading();
      BaseResponse<User>? response = await Apis().login<User>({
        'email': emailController.text,
        'password': passwordController.text,
      });

      if (response != null) {
        if (response.status!) {
          state = ReqStatus.success;

          await UserPreferences().setObject(
            ConstantsSherPref.userInfo,
            response.data ?? {},
          );

          await UserPreferences().setValue(
            ConstantsSherPref.token,
            response.data?.hash ?? '',
          );
          await UserPreferences().setValue(ConstantsSherPref.isLogged, true);

          await UserPreferences().setValue(
            ConstantsSherPref.username,
            emailController.text,
          );
          await UserPreferences().setValue(
            ConstantsSherPref.password,
            passwordController.text,
          );
          ObjectBox.clearAll();
          dismissLoading();
          showMessage(response.message ?? "", error: false);
          push(App.context, screen: MainScreen(),removeUntil: true);
        } else {
          dismissLoading();
          state = ReqStatus.error;
          showMessage(response.message ?? "", error: true);
          return response;
        }
      } else {
        state = ReqStatus.error;
        dismissLoading();
        showMessage("Response Error");
      }
    } catch (error) {
      dismissLoading();
      state = ReqStatus.error;
      showMessage(error.toString());
    }
  }
}
