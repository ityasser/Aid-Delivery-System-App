import 'dart:math' as math;
import 'package:aid_registry_flutter_app/core/customs/custom_text.dart';
import 'package:aid_registry_flutter_app/core/theme/founts.dart';
import 'package:aid_registry_flutter_app/core/utils/dialog_service.dart';
import 'package:aid_registry_flutter_app/data/person.dart';
import 'package:aid_registry_flutter_app/data/project.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/customs/custom_icons_icons.dart';
import '../../../../core/customs/tabbar_gradient_indicator.dart';
import '../../../../core/customs/text_field_custom.dart';
import '../../../../core/theme/color.dart';
import '../../../../data/aid.dart';
import 'aid_notifier.dart';
import '../../../shared/widgets/lists/list_general.dart';
import '../widgets/aid_card.dart';

class ReceivedAidScreen extends ConsumerStatefulWidget {
  Project item;

  ReceivedAidScreen({required this.item});

  @override
  _ReceivedAidScreenState createState() => _ReceivedAidScreenState();
}

class _ReceivedAidScreenState extends ConsumerState<ReceivedAidScreen> {
  late AidNotifier aidNotifier;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    aidNotifier = ref.read(aidProvider(widget.item).notifier);
  }

  @override
  Widget build(BuildContext context) {
    final movies = ref.watch(aidProvider(widget.item));

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          widget.item.title ?? "",
          size: 16.sp,
          fontFamily: Founts.medium,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: REdgeInsetsDirectional.only(
              start: 20.w,
              end: 20.w,
              top: 30,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFieldCustom(
                    controller: searchController,
                    labelHint: "رقم الهوية",
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (value) => aidNotifier.search(value),
                    onChanged: (value) => aidNotifier.search(value),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.qr_code_scanner),
                      onPressed: () async {
                        String? scannedCode = "";
                        if (scannedCode != null) {
                          searchController.text = scannedCode;
                          aidNotifier.search(scannedCode);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListGeneral<Person>(
              listNotifier: aidNotifier,
              isRefresh: true,
              isPagination: true,
              physics: BouncingScrollPhysics(),
              loadMoreType: LoadMoreType.notification,
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 0),
              onGetRequest: (page) => aidNotifier.fetchData(page),

              itemBuilder: (context, index, item, isSelection) {
                return AidCard(
                  item: item,
                  onPressed: () async {/*
                   await DialogService.showMessageDialog(
                      title: "حالة الاستلام",
                      description: "هل انت متاكد من تغير حالة الاستلام",
                      labelNote: "الملاحظات",
                      note: item.note,
                      btnOkOnPress: (note) {
                        aidNotifier.toggleReceived(item, !item.isReceived,note);
                      },
                    );*/
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
