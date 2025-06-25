import 'dart:convert';
import 'package:aid_registry_flutter_app/core/utils/dialog_service.dart';
import 'package:aid_registry_flutter_app/core/utils/helpers.dart';
import 'package:aid_registry_flutter_app/core/web_services/BaseResponseList.dart';
import 'package:aid_registry_flutter_app/data/person.dart';
import 'package:aid_registry_flutter_app/data/project.dart';
import 'package:aid_registry_flutter_app/data/project_db.dart';
import 'package:aid_registry_flutter_app/databse/objectbox_database.dart';
import 'package:aid_registry_flutter_app/databse/sync_service.dart';
import 'package:aid_registry_flutter_app/objectbox.g.dart';
import 'package:aid_registry_flutter_app/presentation/shared/widgets/lists/list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/web_services/apis.dart';
import '../local_projects/local_projects_notifier.dart';

class LiveProjectsNotifier extends ListNotifier<Project>
    with DialogService, Helpers {
  Ref ref;

  LiveProjectsNotifier(this.ref) : super();

  Future<BaseResponseList<Project>?> fetchData(int page) async {
    BaseResponseList<Project>? response = await Apis().getProjects(
      query: {"start": "1", "length": "1000"},
    );
    return response;
  }

  List<Person> getAllPersonByProject(int? projectId) {
    return ObjectBox.instance.getAllPersons();
  }

  void syncPersonsWithAPI(int? projectId, List<Person> apiPersons) {
    Project? project = ObjectBox.instance.getProject(projectId);
    if (project == null) {
      print("Project with ID $projectId not found!");
      return;
    }
    print("syncPersonsWithAPI");
    print("apiPersons ${apiPersons.length}");



    apiPersons.forEach((person) {
      // print(jsonEncode(person.toJson()));
       ObjectBox.instance.updatePerson(person, project.object_id);
    });
  }

  updateLocalProjects() {
    print("updateLocalProjects");
    LocalProjectsNotifier localProjectNotifier = ref.read(
      localProjectsProvider.notifier,
    );
    // localProjectNotifier.fetchData(0);
    localProjectNotifier.refreshList();
  }

  Future<bool> downloadPersonByProject(int? projectId) async {
    try {
      showLoading();
      BaseResponseList<Person>? response = await Apis().getPerson(projectId);
      if (response != null) {
        if (response.status!) {
          syncPersonsWithAPI(projectId, response.data ?? []);

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
    } catch (error) {
      dismissLoading();
      showMessage(error.toString());
      return false;
    }
  }

  bool isExistProject(Project project) {
    return ObjectBox.instance.getProject(project.object_id) != null;
  }

  downloadProjectAndPerson(Project project) async {

    ObjectBox.instance.updateProject(project);
    bool s = await downloadPersonByProject(project.object_id);

    if (s) {
      updateLocalProjects();
      print("updateLocalProjects $s");
      removedItemSelected = ObjectBox.instance.getAllProjects();
       updateView();
    }
  }
}

final liveProjectsProvider =
    StateNotifierProvider<LiveProjectsNotifier, List<Project>>(
      (ref) => LiveProjectsNotifier(ref),
    );
