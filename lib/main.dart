import 'dart:async';

// import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app.dart';
// import 'core/utils/usb_printer_service.dart';
import 'core/utils/user_preference.dart';
import 'databse/objectbox_database.dart';





void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.initPreferences();
  await ObjectBox.init();


  // await UserPreferences().clearAll();
  // ObjectBox.clearAll();

  // SyncService.sync();

  runApp(
    ProviderScope(
        child: App(),overrides: [
    ]
    ),
  );

}

