import 'dart:math';

import 'package:aid_registry_flutter_app/core/utils/extension.dart';
import 'package:aid_registry_flutter_app/core/utils/helpers.dart';
import 'package:aid_registry_flutter_app/data/project.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../projects/local_projects/local_projects_notifier.dart';
import 'search_state.dart';
import '../../../data/person.dart';
import '../../../databse/objectbox_database.dart';

class SearchAidController extends Notifier<SearchState> with Helpers {
  @override
  SearchState build() {
    return SearchState.initial();
  }
  updateLocalProjects() {
    print("updateLocalProjects");
    LocalProjectsNotifier localProjectNotifier = ref.read(
      localProjectsProvider.notifier,
    );
    // localProjectNotifier.fetchData(0);
    localProjectNotifier.refreshList();
  }
  void toggleReceived({String? person_pid, int? project_id, required bool value, String? note}) {

   print("personWithProject: ${project_id}");

    Person personWithProject = ObjectBox.instance.getPersonByIDAndProject(person_pid, project_id);
    personWithProject.isReceived = value;
    personWithProject.receivedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    personWithProject.note = note;
    personWithProject.isDeleted=false;
    print("personWithProject: ${personWithProject.toJson()}");
    ObjectBox.instance.updatePerson(personWithProject, project_id);
    updateLocalProjects();
  }
  void removeAid({String? person_pid, int? project_id, required bool value, String? note}) {

    Person personWithProject = ObjectBox.instance.getPersonByIDAndProject(person_pid, project_id);
    personWithProject.isReceived = value;
    personWithProject.receivedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    personWithProject.isDeleted=true;
    personWithProject.note = note;
    ObjectBox.instance.removePerson(personWithProject, project_id);
    updateLocalProjects();
  }

  void updateSelectedProjects(List<Project> newSelected) {
    state = state.copyWith(selectedProjects: [...newSelected]);
  }

  bool hasAnyPersonNotReceived(String? pid) {
    List<Person> persons = ObjectBox.instance.getAllPersonById(pid);
    // print("getAllPersonById: $persons");
    // print("getAllPersonById: ${persons.any((person) => !person.isReceived)}");

    return persons.any((person) => !person.isReceived);
  }
bool  checkIsReceivedWithProjectAndPerson(String? pid, int? projectId) {
    return ObjectBox.instance.checkIsReceivedWithProjectAndPerson(pid, projectId);
  }



  void searchByPid(String? pid) {
    state = SearchState.searching();

    try {
      Person? person = ObjectBox.instance.getPerson(pid);

      print("searchByPid ${person?.toJson()}");
      if (person != null) {
        List<Project> personProjects = getProjectByPerson(person);
        // final selectedProjectsNotifier = ref.read(selectedProjectsProvider.notifier);
        // selectedProjectsNotifier.state = [...personProjects];

        // print("searchByPid ${ selectedProjectsNotifier.state}");

        if (hasAnyPersonNotReceived(pid)) {
          print("SearchState: success");

          state = SearchState.success(person, personProjects, [
            ...personProjects,
          ]);
        }else {
          print("SearchState: received");

          state = SearchState.received(person, personProjects, [
            ...personProjects,
          ]);
        }
      } else {
        state = SearchState.notFound();
      }

    } catch (e) {
      state = SearchState.error(e.toString());
    }
  }

  void reset() {
    state = SearchState.initial();
  }

  void updateProjectsList() {
    LocalProjectsNotifier localProjectNotifier = ref.read(
      localProjectsProvider.notifier,
    );
    localProjectNotifier.refreshList();
  }

  List<Project> getProjectByPerson(Person? person) {
    print("getProjectByPerson ${person?.project_id}");
    return ObjectBox.instance.getAllProjectByPerson(person);
  }

  /*
  // مثال: تحديث الاستلام
  void toggleIsReceived() {
    if (state == null) return;
    final updated = state!..isReceived = !state!.isReceived;
    ObjectBox.instance.updatePerson(updated, null); // تمرير المشروع لو لزم
    state = updated;
  }
  Person? getPerson(){
    return state;
  }*/
}

final personControllerProvider =
    NotifierProvider<SearchAidController, SearchState>(() {
      return SearchAidController();
    });
final selectedProjectsProvider = StateProvider<List<Project>>((ref) => []);
