import 'dart:math';

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
  void toggleReceived(Person item, Project project, bool value, String? note) {
    item.isReceived = value;
    if (note != null) item.note = note;

    ObjectBox.instance.updatePerson(item, project);
    updateLocalProjects();
  }

  void updateSelectedProjects(List<Project> newSelected) {
    state = state.copyWith(selectedProjects: [...newSelected]);
  }

  bool hasAnyPersonNotReceived(int pid) {
    List<Person> persons = ObjectBox.instance.getAllPersonById(pid);
    return persons.any((person) => !person.isReceived);
  }

  void searchByPid(int pid) {
    state = SearchState.searching();

    try {
      Person? person = ObjectBox.instance.getPerson(pid);

      print("searchByPid ${person?.toJson()}");
      if (person != null) {
        List<Project> personProjects = getProjectByPerson(person);
        // final selectedProjectsNotifier = ref.read(selectedProjectsProvider.notifier);
        // selectedProjectsNotifier.state = [...personProjects];

        // print("searchByPid ${ selectedProjectsNotifier.state}");

        if (hasAnyPersonNotReceived(pid))
          state = SearchState.success(person, personProjects, [
            ...personProjects,
          ]);
        else
          state = SearchState.received(person, personProjects, [
            ...personProjects,
          ]);
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
