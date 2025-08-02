import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:process_run/process_run.dart';

import '../app.dart';
import '../customs/custom_text.dart';
import '../theme/founts.dart';
import '../web_services/network.dart';
import 'dialog_service.dart';

Future<void> checkForUpdates(BuildContext context,bool isShowLoading) async {
  try {
    if(isShowLoading)DialogService.showLoadingG();


    final info = await PackageInfo.fromPlatform();
    final currentVersion = info.version;
    Dio client = Network().dio;
    final response = await client.get(
      'https://github.com/ityasser/Aid-Delivery-System-App/releases/latest/download/latest.json',
    );
    print(response.data);

    if(isShowLoading)DialogService.hideLoading();

    if (response.statusCode == 200) {
      dynamic rawData = response.data;

      Map<String, dynamic> data;

      if (rawData is String) {
        data = jsonDecode(rawData);
      } else if (rawData is Map) {
        data = Map<String, dynamic>.from(rawData);
      } else {
        throw Exception("نوع غير معروف من البيانات");
      }
      data = jsonDecode(response.data as String) as Map<String, dynamic>;

      final latestVersion = data['version'];
      final updateUrl = data['url'];
      final appName = data['name'];

      if (_isNewerVersion(latestVersion, currentVersion)) {
        DialogService.showMessageDialog(
          btnCancelText: "لاحقًا",

          btnOkText: "تحديث",
          btnOkOnPress: (n) async {
            await _downloadAndInstall(updateUrl);
            exit(0);
          },
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CustomText(
                    'تحديث جديد متوفر',
                    color: Colors.black,
                    fontFamily: Founts.medium,
                    align: TextAlign.center,

                  ),
                ),
                SizedBox(height: 30.h),
                Center(
                  child: CustomText(
                    'تم إصدار نسخة جديدة من "$appName"\nالإصدار: $latestVersion\n\nهل ترغب في التحديث الآن؟',
                    color: Colors.black,
                    fontFamily: Founts.medium,
                    align: TextAlign.center,
                  ),
                ),
                SizedBox(height: 30.h),



                SizedBox(height: 30.h),
              ],
            ),
          ),
        );
      } else {
        if(isShowLoading)
        DialogService.showMessageDialog(
          title: "لا يوجد تحديث",
          description: "أنت تستخدم أحدث إصدار من التطبيق.",
          dialogType: DialogType.info,
        );
      }
    }
  } catch (e) {
    debugPrint("خطأ في التحقق من التحديث: $e");
  }
}

bool _isNewerVersion(String latest, String current) {
  final l = latest.split('.').map(int.parse).toList();
  final c = current.split('.').map(int.parse).toList();
  for (int i = 0; i < l.length; i++) {
    if (l[i] > c[i]) return true;
    if (l[i] < c[i]) return false;
  }
  return false;
}


Future<void> _downloadAndInstall(String url) async {
  final dir = await getTemporaryDirectory();
  final filePath = '${dir.path}/update.exe';
  Dio client = Network().dio;

  int received = 0;
  int total = 0;

  late void Function(VoidCallback) dialogSetState;

  showDialog(
    context: App.context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: Text('جارٍ تحميل التحديث...'),
      content: StatefulBuilder(
        builder: (context, setState) {
          dialogSetState = setState; // تخزين setState
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(
                value: total != 0 ? received / total : null,
              ),
              SizedBox(height: 10),
              Text(
                '${(received / 1024).toStringAsFixed(1)} KB / ${(total / 1024).toStringAsFixed(1)} KB',
                textDirection: TextDirection.ltr,
              ),
            ],
          );
        },
      ),
    ),
  );

  final response = await client.get(
    url,
    options: Options(responseType: ResponseType.bytes),
    onReceiveProgress: (count, totalBytes) {
      received = count;
      total = totalBytes;
      if (total != 0 && dialogSetState != null) {
        dialogSetState(() {}); // تحديث واجهة المستخدم
      }
    },
  );

  Navigator.of(App.context).pop(); // إغلاق Dialog بعد التحميل

  final file = File(filePath);
  await file.writeAsBytes(response.data);

  await runExecutableArguments(filePath, ['/S']);
}
