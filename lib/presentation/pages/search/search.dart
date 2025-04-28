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
  late SearchAidController personController;

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
                  controller: searchController,
                  labelHint: "رقم الهوية",
                  textInputType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted:
                      (value) => personController.searchByPid(value.toInt()),

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

              if (searchState.status == SearchStatus.success)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomText(
                          "الاسم",
                          size: 20.sp,
                          color: ColorsUi.black,
                          fontFamily: Founts.medium,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(width: 20.w),
                        CustomText(
                          searchState.person?.fullName,
                          size: 20.sp,
                          color: ColorsUi.black,
                          fontFamily: Founts.normal,
                          fontWeight: FontWeight.normal,
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      children: [
                        CustomText(
                          "الهوية",
                          size: 20.sp,
                          color: ColorsUi.black,
                          fontFamily: Founts.medium,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(width: 20.w),
                        CustomText(
                          searchState.person?.person_pid ?? "",
                          size: 20.sp,
                          color: ColorsUi.black,
                          fontFamily: Founts.normal,
                          fontWeight: FontWeight.normal,
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),

                    Row(
                      children: [
                        CustomText(
                          "الجوال",
                          size: 20.sp,
                          color: ColorsUi.black,
                          fontFamily: Founts.medium,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(width: 20.w),
                        CustomText(
                          searchState.person?.mobile ?? "",
                          size: 20.sp,
                          color: ColorsUi.black,
                          fontFamily: Founts.normal,
                          fontWeight: FontWeight.normal,
                        ),
                      ],
                    ),

                    AidListPerson(
                      list_projects: searchState.projects??[],
                      selectedProjects: searchState.selectedProjects,
                      onSelectionChanged: (newSelected) {
                        personController.updateSelectedProjects(newSelected);

                        searchState.selectedProjects = [...newSelected];
                        print("onSelectionChanged projects:${searchState.projects}");
                        print("onSelectionChanged selectedProjects:${searchState.selectedProjects}");

                      },
                    ),
                  ],
                ),

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
              if (searchState.person != null)
                ElevatedButton(
                onPressed: () async{
                  USBPrinterService u = USBPrinterService();
                  if (searchState.person != null) {
                    await DialogService.showMessageDialog(
                      title: "حالة الاستلام",
                      description: "هل انت متاكد من تغير حالة الاستلام",
                      labelNote: "الملاحظات",
                      note: searchState.person?.note,
                      btnOkOnPress: (note) {
                        print(searchState.selectedProjects);
                        for (var project in searchState.selectedProjects) {
                          personController.toggleReceived(searchState.person!, project,
                              true//!searchState.person!.isReceived
                             ,note);

                        }
                        u.printReceipt(
                          searchState.person!,
                          personController.getProjectByPerson(searchState.person),
                        );
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
