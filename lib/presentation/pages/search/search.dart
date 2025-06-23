import 'dart:typed_data';

import 'package:aid_registry_flutter_app/core/customs/custom_text.dart';
import 'package:aid_registry_flutter_app/core/theme/color.dart';
import 'package:aid_registry_flutter_app/core/theme/founts.dart';
import 'package:aid_registry_flutter_app/core/utils/extension.dart';
import 'package:aid_registry_flutter_app/presentation/pages/search/list_aid/aid_list_person.dart';
import 'package:aid_registry_flutter_app/presentation/pages/search/list_aid/list_aid_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../core/customs/text_field_custom.dart';
import '../../../core/utils/dialog_service.dart';
import '../../../core/utils/usb_printer_service.dart';
import '../../../data/person.dart';
import 'search_controller.dart';
import 'search_state.dart';

class SearchPage extends ConsumerWidget {
  final TextEditingController searchController = TextEditingController(
    text: "",
  );
  final FocusNode _focusNode = FocusNode();

  late SearchAidController personController;
  DateTime? _lastEnterTime;
  final Duration _enterThreshold = Duration(milliseconds: 700);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Person? person = ref.watch(personControllerProvider);
    personController = ref.read(personControllerProvider.notifier);
    final searchState = ref.watch(personControllerProvider);

    final selectedProjects = ref.watch(selectedProjectsProvider);
    // final selectedProjectsNotifier = ref.read(selectedProjectsProvider.notifier);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 20.w, left: 20.w, right: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),

              Center(
                child: TextFieldCustom(
                  focusNode: _focusNode,
                  controller: searchController,
                  labelHint: "رقم الهوية",
                  textInputType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (value) {
                    // personController.searchByPid(value.toInt());
                    final now = DateTime.now();
                    if (_lastEnterTime != null &&
                        now.difference(_lastEnterTime!) < _enterThreshold) {
                      if (searchState.person != null &&
                          searchState.person!.person_pid!.endsWith(value)) {
                        for (var project in searchState.selectedProjects) {
                          print("action search: toggleReceived");
                          searchState.person!.receivedTime = DateFormat(
                            'HH:mm dd-MM-yy',
                          ).format(DateTime.now());
                          personController.toggleReceived(
                            searchState.person!,
                            project,
                            true, //!searchState.person!.isReceived
                            "",
                          );
                        }
                        USBPrinterService u = USBPrinterService();
                        u.printReceipt(
                          searchState.person!,
                          personController.getProjectByPerson(
                            searchState.person,
                          ),
                        );
                        searchController.text = "";
                        personController.reset();
                        personController.updateProjectsList();
                      } else {}
                      _lastEnterTime = null;
                    } else {
                      print("action search: searchByPid");

                      if (value.isNotEmpty)
                        personController.searchByPid(value.toInt());
                      _lastEnterTime = now;
                    }

                    Future.delayed(Duration(milliseconds: 50), () {
                      FocusScope.of(context).requestFocus(_focusNode);
                    });
                  },
                  // onChanged: (value) => aidNotifier.search(value),
                ),
              ),

              SizedBox(height: 30.h),

              if (searchState.status == SearchStatus.searching)
                Center(child: CircularProgressIndicator()),
              if (searchState.status == SearchStatus.notFound)
                Center(child: Text("المستفيد غير موجود")),

              if (searchState.status == SearchStatus.error)
                Center(child: Text("حدث خطأ: ${searchState.errorMessage}")),

              if (searchState.status == SearchStatus.received)
                Center(
                  child: Container(
                    color: Colors.redAccent,
                    child: Text(
                      "حالة المستفيد مستلم",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              SizedBox(height: 15.h),
              if (searchState.status == SearchStatus.success ||
                  searchState.status == SearchStatus.received)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(
                        builder: (context, constraints) {
                          double maxWidth = constraints.maxWidth;
                          double minButtonWidth = 400;
                          // int columns = (maxWidth / minButtonWidth).floor().clamp(1, 6);
                          int columns = (constraints.maxWidth / minButtonWidth).floor().clamp(1, 3);

                          print("columns $columns");
                          double spacing = 12.w;
                          double computedWidth = (constraints.maxWidth - (columns - 1) * spacing) / columns;
                          // double computedWidth = (maxWidth - ((columns - 1) * spacing)) / columns;

                          return Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            spacing: spacing,
                            runSpacing: 20.h,
                            children: [
                              SizedBox(
                                width: computedWidth,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomText(
                                      "الاسم",
                                      size: 18.sp,
                                      color: ColorsUi.black,
                                      fontFamily: Founts.medium,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    SizedBox(width: 20.w),
                                    CustomText(
                                      searchState.person?.fullName,
                                      size: 18.sp,
                                      color: ColorsUi.black,
                                      fontFamily: Founts.normal,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: computedWidth,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,

                                  children: [
                                    CustomText(
                                      "الهوية",
                                      size: 18.sp,
                                      color: ColorsUi.black,
                                      fontFamily: Founts.medium,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    SizedBox(width: 20.w),
                                    CustomText(
                                      searchState.person?.person_pid ?? "",
                                      size: 18.sp,
                                      color: ColorsUi.black,
                                      fontFamily: Founts.normal,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: computedWidth,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomText(
                                      "الجوال",
                                      size: 18.sp,
                                      color: ColorsUi.black,
                                      fontFamily: Founts.medium,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    SizedBox(width: 20.w),
                                    CustomText(
                                      searchState.person?.mobile ?? "",
                                      size: 18.sp,
                                      color: ColorsUi.black,
                                      fontFamily: Founts.normal,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ],
                                ),
                              ),
                              if (searchState.person?.note != null)
                                SizedBox(
                                  width: computedWidth,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,

                                    children: [
                                      CustomText(
                                        "الملاحظات",
                                        size: 18.sp,
                                        color: ColorsUi.black,
                                        fontFamily: Founts.medium,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      SizedBox(width: 20.w),
                                      CustomText(
                                        searchState.person?.note ?? "",
                                        size: 18.sp,
                                        color: ColorsUi.black,
                                        fontFamily: Founts.normal,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        }
                    ),


                    SizedBox(height: 20.h),
                    CustomText(
                      "المشاريع",
                      size: 20.sp,
                      color: ColorsUi.black,
                      fontFamily: Founts.medium,
                      fontWeight: FontWeight.bold,
                    ),
                    AidListPerson(
                      list_projects: searchState.projects ?? [],
                      selectedProjects: searchState.selectedProjects,
                      onSelectionChanged: (newSelected) {
                        personController.updateSelectedProjects(newSelected);

                        searchState.selectedProjects = [...newSelected];
                        print(
                          "onSelectionChanged projects:${searchState.projects}",
                        );
                        print(
                          "onSelectionChanged selectedProjects:${searchState.selectedProjects}",
                        );
                      },
                    ),
                  ],
                ),

              if (searchState.status == SearchStatus.received)
                Column(
                  children: [

                    if (searchState.person != null)
                      FutureBuilder<Uint8List>(
                        future: USBPrinterService.generateArabicImage(
                          searchState.person!,
                          searchState.selectedProjects,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(); // أو أي عنصر تحميل مؤقت
                          } else if (snapshot.hasError) {
                            return Text('خطأ في تحميل الصورة');
                          } else if (snapshot.hasData) {
                            return Container(
                              alignment: AlignmentDirectional.center,
                              width: 500,
                              height: 150 + 4 * 35,
                              color: Colors.grey,

                              child: Image.memory(snapshot.data!),
                            );
                          } else {
                            return Text('لا توجد صورة');
                          }
                        },
                      ),
                    ElevatedButton(
                      onPressed: () async {
                        USBPrinterService u = USBPrinterService();
                        u.printReceipt(
                          searchState.person!,
                          personController.getProjectByPerson(
                            searchState.person,
                          ),
                        );
                      },
                      child: Text('اعادة طباعة عبر USB'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        for (var project in searchState.selectedProjects) {
                          searchState.person!.receivedTime = DateFormat(
                            'HH:mm dd-MM-yy',
                          ).format(DateTime.now());
                          personController.toggleReceived(
                            searchState.person!,
                            project,
                            true, //!searchState.person!.isReceived
                            null,
                          );
                        }
                        final unselectedProjects =
                            searchState.projects.where((project) {
                              return !searchState.selectedProjects.contains(
                                project,
                              );
                            }).toList();
                        print("unselectedProjects: ${unselectedProjects}");
                        for (var project in unselectedProjects) {
                          personController.toggleReceived(
                            searchState.person!,
                            project,
                            false, //!searchState.person!.isReceived
                            null,
                          );
                        }
                        personController.showMessage(
                          "تم تغير الحالة بنجاح",
                          error: false,
                        );
                      },
                      child: Text('حفظ التعديلات'),
                    ),
                  ],
                ),

              if (searchState.status == SearchStatus.success)
                if (searchState.person != null)
                  FutureBuilder<Uint8List>(
                    future: USBPrinterService.generateArabicImage(
                      searchState.person!,
                      searchState.selectedProjects,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // أو أي عنصر تحميل مؤقت
                      } else if (snapshot.hasError) {
                        return Text('خطأ في تحميل الصورة');
                      } else if (snapshot.hasData) {
                        return Container(
                          alignment: AlignmentDirectional.center,
                          width: 500,
                          height: 150 + 4 * 35,
                          color: Colors.grey,

                          child: Image.memory(snapshot.data!),
                        );
                      } else {
                        return Text('لا توجد صورة');
                      }
                    },
                  ),
              if (searchState.status == SearchStatus.success)
                if (searchState.person != null)
                  ElevatedButton(
                    onPressed: () async {
                      USBPrinterService u = USBPrinterService();
                      if (searchState.person != null) {
                        await DialogService.showMessageDialog(
                          title: "حالة الاستلام",
                          description: "هل انت متاكد من تغير حالة الاستلام",
                          labelNote: "الملاحظات",
                          note: searchState.person?.note,
                          btnOkText: "تأكيد",
                          btnOkOnPress: (note) {
                            print(searchState.selectedProjects);
                            for (var project in searchState.selectedProjects) {
                              searchState.person!.receivedTime = DateFormat(
                                'HH:mm dd-MM-yy',
                              ).format(DateTime.now());
                              personController.toggleReceived(
                                searchState.person!,
                                project,
                                true, //!searchState.person!.isReceived
                                note,
                              );
                            }
                            u.printReceipt(
                              searchState.person!,
                              personController.getProjectByPerson(
                                searchState.person,
                              ),
                            );
                            personController.updateProjectsList();
                          },
                        );
                      } else {
                        personController.showMessage("المستفيد غير موجود");
                      }
                    },
                    child: Text('طباعة عبر USB'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
