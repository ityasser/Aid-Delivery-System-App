import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:process_run/process_run.dart';

import '../web_services/network.dart';

Future<void> checkForUpdates(BuildContext context) async {
  try {
    final info = await PackageInfo.fromPlatform();
    final currentVersion = info.version;
    Dio client = Network().dio;
    final response = await client.get<Map>(
      'https://github.com/ityasser/Aid-Delivery-System-App/releases/latest/download/latest.json',
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final latestVersion = data?['version'];
      final updateUrl = data?['url'];
      final appName = data?['name'];

      if (_isNewerVersion(latestVersion, currentVersion)) {
        final confirmed = await showDialog<bool>(
          context: context,
          builder:
              (_) => AlertDialog(
            title: Text('تحديث جديد متوفر'),
            content: Text(
              'تم إصدار نسخة جديدة من "$appName"\nالإصدار: $latestVersion\n\nهل ترغب في التحديث الآن؟',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('لاحقًا'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('موافق'),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          await _downloadAndInstall(updateUrl);
          exit(0); // إغلاق التطبيق بعد بدء التثبيت
        }
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
  final response = await client.get(
      url,
      options: Options(responseType: ResponseType.bytes));
  final file = File(filePath);
  await file.writeAsBytes(response.data);

  await runExecutableArguments(filePath, ['/S']);
}