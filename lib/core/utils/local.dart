import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app.dart';
import '../constant/share_pref.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'user_preference.dart';

class AppLocal{
  static AppLocalizations getString() {
    return AppLocalizations.of(App.context)!;
  }
  static String  currentLocaleString = UserPreferences().getValue<String>(ConstantsSherPref.language) ?? "ar";//Platform.localeName.substring(0, 2);
  static Locale currentLocale = Locale(currentLocaleString);
  static StateProvider<Locale> localeProvider = StateProvider<Locale>((ref) => currentLocale);



  static Future<void> setLocale(BuildContext context, WidgetRef ref, Locale value) async{
    UserPreferences().setValue(ConstantsSherPref.language, value.languageCode);
    currentLocale = value;
    ref.read(localeProvider.notifier).state = value;
  }

  static Future<void> iniLocale() async {
    localeProvider = StateProvider<Locale>((ref) => currentLocale);
  }




}