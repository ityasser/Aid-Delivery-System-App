import 'package:aid_registry_flutter_app/core/utils/app_wrapper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/appbar_theme.dart';
import '../presentation/pages/login/login_screen.dart';
import '../presentation/pages/main/MainScreen.dart';
import '../presentation/scan/scan_id.dart';
import '../presentation/scan/scan_id_screen.dart';
import 'constant/share_pref.dart';
import 'package:aid_registry_flutter_app/l10n/app_localizations.dart';

import 'theme/color.dart';
import 'theme/founts.dart';
import 'theme/input_theme.dart';
import 'utils/local.dart';
import 'utils/user_preference.dart';
import 'package:oktoast/oktoast.dart';

class App extends ConsumerStatefulWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(
    debugLabel: "__navigator_key_app_1__",
  );
  static BuildContext get context {
    if (navigatorKey.currentContext == null) {
      throw Exception(
        "NavigatorState has not been initialized. Make sure to call navigatorKey in MaterialApp first.",
      );
    }
    return navigatorKey.currentContext!;
  }
  ProviderContainer? container;

  static AppLocalizations getString() {
    return AppLocalizations.of(context)!;
  }

  static bool isRTL() {
    return Directionality.of(context) == TextDirection.rtl;
  }


  static TextDirection grtTextDirection() {
    return Directionality.of(context);
  }

  bool isLogged() {
    return UserPreferences().getBool(ConstantsSherPref.isLogged);
  }
  static bool isDesktop = [
    TargetPlatform.macOS,
    TargetPlatform.windows,
    TargetPlatform.linux,
  ].contains(defaultTargetPlatform);
  static Main? of() =>
      context.findAncestorStateOfType<Main>();

  App({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => Main();
}

class Main extends ConsumerState<App> with SingleTickerProviderStateMixin {

   void resetProviders() {
     setState(() {
       widget.container?.dispose();
       widget.container = ProviderContainer();
     });
  }
  @override
  void initState() {
    super.initState();
   widget.container = ProviderContainer();

    AppLocal.iniLocale();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      connectWifi();
    });
  }

  @override
  Widget build(BuildContext context) {

    return AppWrapper(

      builder: (context) {
        return OKToast(
          /// set toast style, optional
            child: UncontrolledProviderScope(
            container:  widget.container!,child:MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mosa',
          supportedLocales: [Locale('ar', 'AE'), Locale('en', 'US')],
          navigatorKey: App.navigatorKey,

          // home:/* UserPreferences().getBool(ConstantsSherPref.isLogged)? MainScreen() :*/
          // //LoginScreen
          // //EstateDetailsScreen
          //    MainScreen
          //   ()
          // //MoreScreen()//TestScreen()//const LoginScreen() //ResetPasswordScreen(),SignupScreen
          // ,
          home: UserPreferences().isLoggedIn ? MainScreen() : LoginScreen(),
          theme: ThemeData(
            fontFamily: Founts.normal,
            inputDecorationTheme: createInputDecorationTheme(),
            appBarTheme: appBarTheme(),

            scaffoldBackgroundColor: ColorsUi.white,
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: ref.watch(AppLocal.localeProvider),
        )));
      },
    );
  }

  void connectWifi() {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result.contains(ConnectivityResult.wifi)) {
        if (result.contains(ConnectivityResult.wifi)) {
          /*Apis().get_setting().then((value) {
            if ((value?.data ?? []).isNotEmpty) {
              UserPreferences().addObject(
                  ConstantsSherPref.settings, value?.data ?? []);
            }
          });*/
        }
      }
    });
  }
}
