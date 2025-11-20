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
import '../../../databse/objectbox_database.dart';
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

    print(
      "onSelectionChanged selectedProjects reload:${searchState.selectedProjects}",
    );
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 20.w, left: 20.w, right: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),


              Center(
                child: Row(
                  children: [
                    Expanded(
                      child: TextFieldCustom(
                        focusNode: _focusNode,
                        controller: searchController,
                        labelHint: "رقم الهوية",
                        textAlign: TextAlign.center,
                        textInputType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.search,
                        onFieldSubmitted: (value) async {
                          final now = DateTime.now();
                          // إذا تم الضغط مرتين خلال فترة قصيرة
                          if (_lastEnterTime != null && now.difference(_lastEnterTime!) < _enterThreshold) {
                            print("Double press: تنفيذ التسليم والطباعة");

                            for (var project in searchState.selectedProjects) {
                              Person personWithProject = ObjectBox.instance
                                  .getPersonByIDAndProject(
                                    searchState.person?.person_pid,
                                    project.object_id,
                                  );
                            }
                            if (personController.hasAnyPersonNotReceived(searchState.person!.person_pid,)) {
                              USBPrinterService u = USBPrinterService();
                              u.printReceipt(searchState.person!, personController.getProjectByPerson(searchState.person,),);
                            }else{
                               DialogService.showMessageDialog(
                                title: "حالة الاستلام",
                                description:
                                " المستفيد ${searchState.person?.fullName} تم استلامه سابقاً",
                                btnOkText: "موافق",
                              );
                              personController.showMessage(
                                "المستفيد تم استلامه سابقاً",
                                error: true,
                              );
                            }
                            print("selected projectsc ${searchState.selectedProjects}");
                            for (var project in searchState.selectedProjects) {
                              print("action search: toggleReceived");
                              print("action search: toggleReceived  ${searchState.person!.toJson()}",);
                              if(!personController.checkIsReceivedWithProjectAndPerson(searchState.person!.person_pid, project.object_id)) {
                                personController.toggleReceived(
                                person_pid: searchState.person!.person_pid,
                                project_id: project.object_id,
                                value: true,
                                note: "",
                              );
                              }
                            }

                            searchController.text = "";
                            // personController.reset();
                            // personController.updateProjectsList();

                            _lastEnterTime = null; // إعادة الضبط
                          } else {
                            print("Single press: تنفيذ البحث");

                            if (value.isNotEmpty) {
                              personController.searchByPid(value);
                            }

                            _lastEnterTime = now; // تخزين وقت الضغط
                          }

                          // في كل الحالات، إعادة تركيز المؤشر
                          Future.delayed(Duration(milliseconds: 50), () {
                            FocusScope.of(context).requestFocus(_focusNode);
                          });
                        },

                        // onChanged: (value) => aidNotifier.search(value),
                      ),
                    ),

                    SizedBox(width: 20.w),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: PopupMenuButton<String>(
                        tooltip: "إجراءات",
                        offset: Offset(0, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onSelected: (value) async {
                          if (value == 'reprint') {
                            if (searchState.person != null) {
                              USBPrinterService u = USBPrinterService();
                              u.printReceipt(
                                searchState.person!,
                                personController.getProjectByPerson(
                                  searchState.person,
                                ),
                              );
                            } else {
                              personController.showMessage(
                                "المستفيد غير موجود",
                              );
                            }
                          } else if (value == 'delivered_note') {
                            USBPrinterService u = USBPrinterService();
                            if (searchState.person != null) {
                              await DialogService.showMessageDialog(
                                title: "حالة الاستلام",
                                description:
                                    "هل انت متاكد من تغير حالة الاستلام",
                                labelNote: "الملاحظات",
                                note: searchState.person?.note,
                                btnOkText: "تأكيد",
                                btnOkOnPress: (note) {
                                  print(searchState.selectedProjects);
                                  for (var project
                                      in searchState.selectedProjects) {
                                    personController.toggleReceived(
                                      person_pid:
                                          searchState.person!.person_pid,
                                      project_id: project.object_id,
                                      value: true,
                                      note: note,
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
                              personController.showMessage(
                                "المستفيد غير موجود",
                              );
                            }
                          } else if (value == 'delete') {
                            USBPrinterService u = USBPrinterService();
                            if (searchState.person != null) {
                              await DialogService.showMessageDialog(
                                title: "حذف التسليم",
                                description:
                                    "هل انت متاكد من حذف المستفيد من المساعدة ",
                                labelNote: "الملاحظات",
                                note: searchState.person?.note,
                                btnOkText: "تأكيد",

                                btnOkOnPress: (note) {
                                  print(searchState.selectedProjects);
                                  for (var project
                                      in searchState.selectedProjects) {
                                    personController.removeAid(
                                      person_pid:
                                          searchState.person!.person_pid,
                                      project_id: project.object_id,
                                      value: false,
                                      note: note,
                                    );
                                  }

                                  if (searchState.person != null)
                                    personController.searchByPid(
                                      searchState.person!.person_pid,
                                    );

                                  personController.showMessage(
                                    "تمت عملية الحذف بنجاح",
                                    error: false,
                                  );
                                },
                              );
                            } else {
                              personController.showMessage(
                                "المستفيد غير موجود",
                              );
                            }
                          }
                        },
                        itemBuilder:
                            (BuildContext context) => [
                              PopupMenuItem(
                                value: 'reprint',
                                child: Row(
                                  children: [
                                    Icon(Icons.print, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text("إعادة طباعة"),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delivered_note',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.note_alt_outlined,
                                      color: Colors.orange,
                                    ),
                                    SizedBox(width: 8),
                                    Text("تسليم بملاحظة"),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete_forever,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 8),
                                    Text("حذف التسليم"),
                                  ],
                                ),
                              ),
                            ],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.manage_accounts,
                                color: Colors.black87,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                "إجراءات",
                                style: TextStyle(color: Colors.black87),
                              ),
                              SizedBox(width: 60.w),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.h),

              if (searchState.status == SearchStatus.searching)
                Center(child: CircularProgressIndicator()),
              if (searchState.status == SearchStatus.notFound)
                Center(child: Text("المستفيد غير موجود")),

              if (searchState.status == SearchStatus.error)
                Center(child: Text("حدث خطأ: ${searchState.errorMessage}")),

              SizedBox(height: 15.h),
              if (searchState.status == SearchStatus.success ||
                  searchState.status == SearchStatus.received)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    "البيانات الشخصية",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 20,
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 50),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                double maxWidth = constraints.maxWidth;
                                double minButtonWidth = 300;
                                // int columns = (maxWidth / minButtonWidth).floor().clamp(1, 6);
                                int columns = (constraints.maxWidth /
                                        minButtonWidth)
                                    .floor()
                                    .clamp(1, 3);

                                // print("columns $columns");
                                double spacing = 12.w;
                                double computedWidth =
                                    (constraints.maxWidth -
                                        (columns - 1) * spacing) /
                                    columns;
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
                                            "الاسم:",
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
                                            ":الهوية",
                                            size: 18.sp,
                                            color: ColorsUi.black,
                                            fontFamily: Founts.medium,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          SizedBox(width: 20.w),
                                          CustomText(
                                            searchState.person?.person_pid ??
                                                "",
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
                                            "الجوال:",
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

                                    if (searchState.person?.note != null &&
                                        (searchState.person?.note?.isNotEmpty ??
                                            false))
                                      SizedBox(
                                        width: computedWidth,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomText(
                                              "الملاحظات:",
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
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 40.h),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    "المشاريع",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 20,
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 50),
                            AidListPerson(
                              person: searchState.person!,
                              list_projects: searchState.projects ?? [],
                              selectedProjects: searchState.selectedProjects,
                              onSelectionChanged: (newSelected) {
                                personController.updateSelectedProjects(
                                  newSelected,
                                );
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
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
