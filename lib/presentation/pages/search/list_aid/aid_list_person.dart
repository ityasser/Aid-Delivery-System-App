import 'package:aid_registry_flutter_app/core/utils/extension.dart';
import 'package:aid_registry_flutter_app/presentation/shared/widgets/lists/list_general.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/customs/custom_text.dart';
import '../../../../core/theme/color.dart';
import '../../../../core/theme/founts.dart';
import '../../../../data/person.dart';
import '../../../../data/project.dart';
import '../../../../databse/objectbox_database.dart';
import 'list_aid_notifier.dart';

class AidListPerson extends StatefulWidget {
  List<Project> list_projects;
  Person person;
  final List<Project> selectedProjects;
  final void Function(List<Project>) onSelectionChanged;

  AidListPerson({
    required this.list_projects,
    required this.person,
    required this.selectedProjects,
    required this.onSelectionChanged,
  });

  @override
  State<AidListPerson> createState() => _AidListSectionState();
}

class _AidListSectionState extends State<AidListPerson> {
  // late ListAidNotifier listAidNotifier;

  @override
  void initState() {
    super.initState();

    // listAidNotifier = ref.read(listAidProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    print("list_projects ${widget.list_projects.length}");
    print("list_selectedProjects ${widget.selectedProjects.length}");
    // final movies = ref.watch(listAidProvider);
    //
    //
    // listAidNotifier.listItemSelected=widget.selectedProjects;
    // Future(() {
    //   listAidNotifier.state=widget.list_projects;
    //
    // });
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: widget.list_projects.length,
      itemBuilder: (context, index) {
        Project project = widget.list_projects[index];
        Person person = widget.person;

        Person aid = ObjectBox.instance.getPersonByIDAndProject(
          person.person_pid,
          project.object_id,
        );
        print("aid: ${aid.toJson()}");

        return InkWell(
          onTap: () {
            final isSelected = widget.selectedProjects.any(
              (item) => item.object_id == widget.list_projects[index].object_id,
            );
            setState(() {
              if (isSelected) {
                widget.selectedProjects.removeWhere(
                  (item) =>
                      item.object_id == widget.list_projects[index].object_id,
                );
              } else {
                widget.selectedProjects.add(widget.list_projects[index]);
              }
            });
            widget.onSelectionChanged(widget.selectedProjects);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Checkbox(
                  value: widget.selectedProjects.any(
                    (item) =>
                        item.object_id == widget.list_projects[index].object_id,
                  ),
                  onChanged: (val) {
                    setState(() {
                      if (val!) {
                        widget.selectedProjects.add(
                          widget.list_projects[index],
                        );
                      } else {
                        widget.selectedProjects.removeWhere(
                          (item) =>
                              item.object_id ==
                              widget.list_projects[index].object_id,
                        );
                      }
                      widget.onSelectionChanged(widget.selectedProjects);
                    });
                  },
                ),
                SizedBox(width: 12), // مسافة بين الـ checkbox والنص
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        widget.list_projects[index].title ?? "",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(width: 20.w),
                      Text(
                        widget.list_projects[index].aids_name ?? "",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                CustomText(
                  (aid.isReceived)
                      ? "مستلم"
                      : "مرشح",
                  size: 18.sp,
                  color:
                  (aid.isReceived)
                      ? ColorsUi.green
                      : ColorsUi.primary,
                  fontFamily: Founts.normal,
                  fontWeight: FontWeight.normal,
                ), SizedBox(width: 10.w,),
                CustomText(
                  !aid.isReceived &&aid.isDeleted?"":aid.receivedTime??"",
                  size: 18.sp,
                  color:
                  (aid.isReceived)
                      ? ColorsUi.green
                      : ColorsUi.primary,
                  fontFamily: Founts.normal,
                  fontWeight: FontWeight.normal,
                ),SizedBox(width: 30.w,),
              ],
            ),
          ),
        );

        return CheckboxListTile(
          title: Text(
            widget.list_projects[index].title ?? "",
            style: TextStyle(fontSize: 18),
          ),
          value: widget.selectedProjects.any(
            (item) => item.object_id == widget.list_projects[index].object_id,
          ),
          onChanged: (val) {
            if (val!) {
              setState(() {
                widget.selectedProjects.add(widget.list_projects[index]);
              });
            } else {
              setState(() {
                widget.selectedProjects.remove(widget.list_projects[index]);
              });
            }
            // listAidNotifier.updateSelectionItem(val!, widget.list_projects[index], index);
            widget.onSelectionChanged(widget.selectedProjects);
          },
        );
      },
    );
    /*return ListGeneral<Project>(

      listNotifier: listAidNotifier,
        shrinkWrap: true,
        isRefresh: false,
        listItem: widget.list_projects,
      selectionType: SelectionType.multi,
      listItemSelected: widget.selectedProjects,
        itemBuilder: (context, index, item, isSelection)
    {
      return CheckboxListTile(
        title: Text(
          item.title ?? "",
          style: TextStyle(fontSize: 18),
        ),
        value: isSelection,
        onChanged: (val) {
          listAidNotifier
              .updateSelectionItem(val!, item, index);
          widget.onSelectionChanged(listAidNotifier.listItemSelected);
        },
      );

        }
    );*/
  }
}
