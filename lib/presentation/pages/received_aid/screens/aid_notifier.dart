import 'dart:convert';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aid_registry_flutter_app/data/aid.dart';

import '../../../../core/web_services/BaseResponseList.dart';
import '../../../../core/web_services/apis.dart';
import '../../../../data/person.dart';
import '../../../../data/project.dart';
import '../../../../databse/objectbox_database.dart';
import '../../../shared/widgets/lists/list_notifier.dart';


class AidNotifier extends ListNotifier<Person> {
  Ref ref;
  Project? project;
  AidNotifier(this.ref,this.project) : super();

  Future<BaseResponseList<Person>?> fetchData(int page) async {
    List<Person> list = getPersonsByProject(project?.object_id??0);
    BaseResponseList<Person>? response = BaseResponseList(
      status: true,
      data: list,
      code: 200,
      message: "success",
    );
    return response;
  }

  void search(String query) {
    searchFromList(query.trim());

  }
  void toggleReceived(Person item, bool value,String? note) {
    print("toggleReceived $value");
    item.isReceived = value;
    item.note = note;
    ObjectBox.instance.updatePerson(item,project);
    updateItem(item);
  }


  List<Person> getPersonsByProject(int projectId) {
    return ObjectBox.instance.getAllPersonByProject(projectId);
  }

}

final aidProvider = StateNotifierProvider.family<AidNotifier, List<Person>,Project>(
      (ref,project) => AidNotifier(ref,project),
);
