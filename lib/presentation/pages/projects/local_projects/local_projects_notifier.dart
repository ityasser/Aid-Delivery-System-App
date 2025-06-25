import 'dart:convert';
import 'dart:io';
import 'package:aid_registry_flutter_app/core/utils/dialog_service.dart';
import 'package:aid_registry_flutter_app/core/utils/helpers.dart';
import 'package:aid_registry_flutter_app/core/web_services/BaseResponseList.dart';
import 'package:aid_registry_flutter_app/data/person.dart';
import 'package:aid_registry_flutter_app/data/project.dart';
import 'package:aid_registry_flutter_app/databse/objectbox_database.dart';
import 'package:aid_registry_flutter_app/databse/sync_service.dart';
import 'package:aid_registry_flutter_app/objectbox.g.dart';
import 'package:aid_registry_flutter_app/presentation/shared/widgets/lists/list_notifier.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/web_services/BaseResponse.dart';
import '../../../../core/web_services/apis.dart';
import '../live_projects/live_projects_notifier.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class LocalProjectsNotifier extends ListNotifier<Project>
    with DialogService, Helpers {
  Ref ref;

  LocalProjectsNotifier(this.ref) : super();

  void closeCobon() {}

  List<Project> getAllProjects() {
    return ObjectBox.instance.getAllProjects();
  }

  int getCountReceived(Project item) {
    return ObjectBox.instance
        .getPersonsByAidManageIdAndReceived(item.object_id!)
        .length;
  }

  int getCountNonReceived(Project item) {
    return ObjectBox.instance
        .getPersonsByAidManageIdAndNotReceived(item.object_id!)
        .length;
  }
  int getCountAll(Project item) {
    return ObjectBox.instance
        .getPersonsByAidManageId(item.object_id!)
        .length;
  }

  Future<BaseResponseList<Project>?> fetchData(int page) async {
    List<Project> projects = getAllProjects();
    print("getAllProjects ${projects.length}");
    BaseResponseList<Project>? response = BaseResponseList(
      status: true,
      data: projects,
      code: 200,
      message: "success",
    );
    return response;
  }

  deletePersonsInProject(Project project) {
    ObjectBox.instance.deletePersonsInProject(project.object_id!);
    reGetList();
    // updateLiveProjects(project);
  }

  deleteProjectWithPersons(Project project) async {
    try {
      showLoading();
      bool s = await uploadProjectWithPersons(project);
      if (s) {
        BaseResponse? response = await Apis().closeCobon(project.object_id);
        if (response != null) {
          if (response.status ?? false) {
            showMessage(response.message ?? "", error: false);
            ObjectBox.instance.deletePersonsInProject(project.object_id!);
            ObjectBox.instance.deleteProject(project.object_id!);
            reGetList();
            updateLiveProjects(project);
          } else {
            showMessage(response.message ?? '');
          }
        } else {
          showMessage('Response Error', error: true);
        }
      }
      dismissLoading();
    } catch (error) {
      dismissLoading();
      showMessage(error.toString(), error: true);
      return null;
    }
  }

  updateLiveProjects(Project? item) {
    LiveProjectsNotifier liveProjectsNotifier = ref.read(
      liveProjectsProvider.notifier,
    );

    liveProjectsNotifier.removedItemSelected =
        ObjectBox.instance.getAllProjects();
    // if(item!=null)liveProjectsNotifier.addItem(item);
    // liveProjectsNotifier.updateView();
  }

  List<Person> getAllPersonByProject(int? projectId) {
    return ObjectBox.instance.getAllPersonByProject(projectId);
  }

  Future<bool> uploadProjectWithPersons(Project item) async {
    try {
      showLoading();
      List<Map<String, dynamic>> json = ObjectBox.instance
          .getPersonsByProjectAndReceived(item.object_id ?? 0);
      print("uploadProjectWithPersons $json");

      if (json.isNotEmpty) {
        BaseResponse? response = await Apis().uploadPersons({
          "data": jsonEncode(json),
        });
        if (response != null) {
          if (response.status!) {
            // deletePersonsInProject(item);
            dismissLoading();
            showMessage(response.message ?? "", error: false);
            return true;
          } else {
            dismissLoading();
            showMessage(response.message ?? "", error: true);
            return false;
          }
        } else {
          dismissLoading();
          showMessage("Response Error");
          return false;
        }
      } else {
        dismissLoading();
        return true;
      }
    } catch (error) {
      dismissLoading();
      showMessage(error.toString());
      return false;
    }
  }

  Future<String> getDownloadsPath() async {
    if (Platform.isAndroid) {
      // طلب إذن التخزين على Android
      if (await Permission.manageExternalStorage.request().isGranted ||
          await Permission.storage.request().isGranted) {
        Directory downloadsDir = Directory('/storage/emulated/0/Download');
        if (await downloadsDir.exists()) {
          return downloadsDir.path;
        }
      }
    } else if (Platform.isWindows) {
      // في ويندوز، مجلد التنزيلات عادة يكون تحت مجلد المستخدم
      final directory = Directory(
        '${Platform.environment['USERPROFILE']}\\Downloads',
      );
      if (await directory.exists()) {
        return directory.path;
      }
    }

    return "";
  }

  Future<List<String>> listFilesInDirectory(String path) async {
    List<String> list = [];

    try {
      Directory targetDir = Directory(path);

      if (await targetDir.exists()) {
        List<FileSystemEntity> files = targetDir.listSync();

        for (var file in files) {
          if (file is File) {
            list.add(file.path.split('/').last.split('.').first);
          }
        }
      } else {
        print('المجلد غير موجود');
      }
    } catch (e) {
      print('حدث خطأ: $e');
    }
    return list;
  }

  Future<void> onTapUpdate(Project project) async {
    showLoading();
    SyncService.uploadPersonByProject(project, message: (note){
      showMessage(note??"",error: false);
    });
    SyncService.downloadPersonByProject(project,message: (note){
      showMessage(note??"",error: false);
    });
    SyncService.uploadDeletedPersonByProject(project,message: (note){
      showMessage(note??"",error: false);
    });
    dismissLoading();

    // uploadProjectWithPersons(project);
    // LiveProjectsNotifier liveProjectsNotifier = ref.read(
    //   liveProjectsProvider.notifier,
    // );
    // liveProjectsNotifier.downloadPersonByProject(project.object_id);
  }

  Future<void> exportPersonsToExcelNotReceived(Project project) async {
    if (await requestStoragePermission() == false) {
      showMessage("لا يوجد صلاحيات");
      return;
    }

    String dirPath = await getDownloadsPath();
    String filePath = generateUniqueFileName(
      "متغيبين - ${project.title}",
      dirPath,
      "xlsx",
    );
    print("object $filePath");

    List<Person> persons = ObjectBox.instance
        .getPersonsByAidManageIdAndNotReceived(project.object_id!);

    if (persons.isEmpty) {
      showMessage("لا يوجد مستفيدين لم يستلمو مساعدات");
      return;
    }

    var excel = Excel.createExcel();
    print(excel.sheets);
    String? defaultSheet = excel.getDefaultSheet();
    if (defaultSheet != null) {
      excel.rename(defaultSheet, "Persons");
    }
    var sheet = excel['Persons'];

    sheet.appendRow([
      TextCellValue('ID'),
      TextCellValue('person pid'),
      TextCellValue('Full Name'),
      TextCellValue('Mobile'),
      TextCellValue('Title'),
    ]);

    for (var person in persons) {
      sheet.appendRow([
        TextCellValue(person.object_id.toString()),
        TextCellValue(person.person_pid!),
        TextCellValue(person.fullName),
        TextCellValue(person.mobile ?? ""),
        TextCellValue(person.note ?? ""),
      ]);
    }

    Directory? directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    String path = await getWritableFilePath();
    print(path);

    File file =
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(excel.encode()!);

    showMessage("✅ تم حفظ الملف بنجاح: $filePath", error: false);
  }

  Future<void> exportPersonsToExcel(Project project) async {
    if (await requestStoragePermission() == false) {
      showMessage("لا يوجد صلاحيات");
      return;
    }

    String dirPath = await getDownloadsPath();
    String filePath = generateUniqueFileName(
      "مستليمين - ${project.title}",
      dirPath,
      "xlsx",
    );
    print("object $filePath");

    List<Person> persons = ObjectBox.instance
        .getPersonsByAidManageIdAndReceived(project.object_id!);

    if (persons.isEmpty) {
      showMessage("لا يوجد مستفيدين استلمو مساعدات");
      return;
    }

    var excel = Excel.createExcel();
    print(excel.sheets);
    String? defaultSheet = excel.getDefaultSheet();
    if (defaultSheet != null) {
      excel.rename(defaultSheet, "Persons");
    }
    var sheet = excel['Persons'];

    sheet.appendRow([
      TextCellValue('ID'),
      TextCellValue('person pid'),
      TextCellValue('Full Name'),
      TextCellValue('Mobile'),
      TextCellValue('Title'),
    ]);

    for (var person in persons) {
      sheet.appendRow([
        TextCellValue(person.object_id.toString()),
        TextCellValue(person.person_pid!),
        TextCellValue(person.fullName),
        TextCellValue(person.mobile ?? ""),
        TextCellValue(person.note ?? ""),
      ]);
    }

    Directory? directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    String path = await getWritableFilePath();
    print(path);

    File file =
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(excel.encode()!);

    showMessage("✅ تم حفظ الملف بنجاح: $filePath", error: false);
  }

  Future<String> getWritableFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  String generateUniqueFileName(
    String baseName,
    String directoryPath,
    String extension,
  ) {
    int counter = 1;
    String fileName = "$baseName";
    File file = File('$directoryPath/$fileName.$extension');

    while (file.existsSync()) {
      fileName = "${baseName} - $counter";
      file = File('$directoryPath/$fileName.$extension');
      counter++;
    }

    return file.path;
  }

  Future<bool> requestStoragePermission() async {
    // if (Platform.isAndroid) {
    if (await Permission.storage.isGranted) {
      return true; // الإذن ممنوح مسبقًا
    } else {
      if (await Permission.storage.request().isGranted) {
        return true; // إذن القراءة/الكتابة (Android 9 وأقل)
      } else if (await Permission.manageExternalStorage.request().isGranted) {
        return true; // إذن الإدارة الكامل (Android 11+)
      }
    }
    // }else if (Platform.isWindows){

    // }
    return false;
  }

  Future<void> exportNonReceivedPdf(Project project) async {
    if (await requestStoragePermission() == false) {
      showMessage("لا يوجد صلاحيات");
      return;
    }

    String dirPath = await getDownloadsPath();
    String filePath = generateUniqueFileName(
      "${project.title}غير مستلمين-",
      dirPath,
      "pdf",
    );

    List<Person> persons = ObjectBox.instance
        .getPersonsByAidManageIdAndNotReceived(project.object_id!);
    print(persons.length);
    final fontData = await rootBundle.load(
      "assets/fonts/NotoSansArabic-Regular.ttf",
    );
    final arabicFont = pw.Font.ttf(fontData);

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,

        build: (pw.Context context) {
          return [
            // Title
            pw.Text(
              ' ',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),

            pw.SizedBox(height: 8),

            // Subtitle
            pw.Text(
              "${project.title ?? ""} الغير مستلمين ",
              style: pw.TextStyle(
                font: arabicFont,
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey600,
              ),
            ),

            pw.SizedBox(height: 12),

            // Description
            pw.Text('', style: pw.TextStyle(fontSize: 14)),

            pw.SizedBox(height: 16),

            // Table
            pw.TableHelper.fromTextArray(
              headers: ['ID', 'Person Pid', 'Full Name', 'Mobile', 'Title'],
              data:
                  persons.map((person) {
                    return [
                      person.object_id.toString(),
                      person.person_pid,
                      person.fullName.toString(),
                      person.mobile.toString(),
                      person.note ?? "",
                    ];
                  }).toList(),
              border: pw.TableBorder.all(),
              cellAlignment: pw.Alignment.center,
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                font: arabicFont,
              ),
              cellStyle: pw.TextStyle(font: arabicFont),
            ),
          ];
        },
      ),
    );

    // Save PDF to device
    final file = File('${filePath}');
    await file.writeAsBytes(await pdf.save());
    showMessage("✅ تم حفظ الملف بنجاح: $filePath", error: false);

    OpenFile.open(file.path);
  }

  Future<void> exportReceivedPdf(Project project) async {
    if (await requestStoragePermission() == false) {
      showMessage("لا يوجد صلاحيات");
      return;
    }

    String dirPath = await getDownloadsPath();
    String filePath = generateUniqueFileName(
      "${project.title}مستلمين-",
      dirPath,
      "pdf",
    );

    List<Person> persons = ObjectBox.instance
        .getPersonsByAidManageIdAndReceived(project.object_id!);
    final fontData = await rootBundle.load(
      "assets/fonts/NotoSansArabic-Regular.ttf",
    );
    final arabicFont = pw.Font.ttf(fontData);

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        build: (pw.Context context) {
          return [
            // Title
            pw.Text(
              ' ',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),

            pw.SizedBox(height: 8),

            // Subtitle
            pw.Text(
              "${project.title ?? ""} المستلمين ",
              style: pw.TextStyle(
                font: arabicFont,
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey600,
              ),
            ),

            pw.SizedBox(height: 12),

            // Description
            pw.Text('', style: pw.TextStyle(fontSize: 14)),

            pw.SizedBox(height: 16),

            // Table
            pw.TableHelper.fromTextArray(
              headers: ['ID', 'Person Pid', 'Full Name', 'Mobile', 'Title'],
              data:
                  persons.map((person) {
                    return [
                      person.object_id.toString(),
                      person.person_pid,
                      person.fullName.toString(),
                      person.mobile.toString(),
                      person.note ?? "",
                    ];
                  }).toList(),
              border: pw.TableBorder.all(),
              cellAlignment: pw.Alignment.center,
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                font: arabicFont,
              ),
              cellStyle: pw.TextStyle(font: arabicFont),
            ),
          ];
        },
      ),
    );

    // Save PDF to device
    final file = File('${filePath}');
    await file.writeAsBytes(await pdf.save());
    showMessage("✅ تم حفظ الملف بنجاح: $filePath", error: false);

    OpenFile.open(file.path);
  }
}

final localProjectsProvider =
    StateNotifierProvider<LocalProjectsNotifier, List<Project>>(
      (ref) => LocalProjectsNotifier(ref),
    );
