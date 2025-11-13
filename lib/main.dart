import 'dart:async';

// import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app.dart';

// import 'core/utils/usb_printer_service.dart';
import 'core/utils/file_logger.dart';
import 'core/utils/user_preference.dart';
import 'databse/objectbox_database.dart';


void main() {
  // Run everything in the same zone
  runZonedGuarded(() async {
    // Must be inside the same zone
    WidgetsFlutterBinding.ensureInitialized();
    await UserPreferences.initPreferences();
    await ObjectBox.init();
    await FileLogger.init();

    // Capture Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) async {
      FlutterError.dumpErrorToConsole(details);
      await FileLogger.logError(details.exception, details.stack);
    };

    runApp(ProviderScope(child: App(), overrides: []));
  }, (error, stack) async {
    await FileLogger.logError(error, stack);
  });
}
