import 'package:aid_registry_flutter_app/core/utils/extension.dart';
import 'package:aid_registry_flutter_app/core/utils/user_preference.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import '../data/person_db.dart';
import '../data/project_db.dart';
import '../objectbox.g.dart';
import '../data/person.dart';
import '../data/project.dart';

class ObjectBox {
  static  ObjectBox? _instance;
  late final Store store;
  late final Box<ProjectDB> projectBox;
  late final Box<PersonDB> personBox;

  ObjectBox._create(this.store) {
    projectBox = Box<ProjectDB>(store);
    personBox = Box<PersonDB>(store);
  }

  static Future<void> init() async {


    if (_instance != null) {
      _instance?.store.close();
    }

    final dir=await getApplicationDocumentsDirectory();

    print("dir-database: $dir");
    final userDbPath = '${dir.path}/objectbox_${UserPreferences().store}';

    // فتح الـ Store من هذا المسار
    final store = await openStore(directory: userDbPath);

    // final store = await openStore();

    _instance = ObjectBox._create(store);

  }

  static ObjectBox get instance => _instance!;

  static void clearAll() {
    ObjectBox.instance.projectBox.removeAll();
    ObjectBox.instance.personBox.removeAll();
  }

  void deleteProject(int projectId) {
    final project = getProjectDB(projectId);

    ObjectBox.instance.projectBox.remove(project!.id!);
  }

  void deletePersonsInProject(int projectId) {
    final personBox = ObjectBox.instance.personBox;

    final project = getProjectDB(projectId);
    if (project != null) {
      List<PersonDB> persons =
          ObjectBox.instance.personBox
              .getAll()
              .where((p) => p.project_id == projectId)
              .toList();
      personBox.removeMany(persons.map((p) => p.id).toList());
    } else {
      print("project is null");
    }
  }

  void deletePersonsReceivedInProject(int projectId) {
    final personBox = ObjectBox.instance.personBox;

    final project = getProjectDB(projectId);
    if (project != null) {
      List<PersonDB> persons =
          ObjectBox.instance.personBox
              .getAll()
              .where((p) => p.project_id == projectId && p.isReceived == true)
              .toList();
      personBox.removeMany(persons.map((p) => p.id).toList());
    } else {
      print("project is null");
    }
  }

  List<PersonDB> getAllPersonsDB() {
    return ObjectBox.instance.personBox.getAll();
  }

  List<Person> getAllPersons() {
    return convertToPersonsList(getAllPersonsDB());
  }

  List<Person> convertToPersonsList(List<PersonDB> projectDBList) =>
      projectDBList
          .map((projectDB) => Person.fromJson(projectDB.toJson()))
          .toList();

  List<ProjectDB> getAllProjectsDB() {
    return ObjectBox.instance.projectBox.getAll();
    ;
  }

  List<Project> convertToProjectList(List<ProjectDB> projectDBList) =>
      projectDBList
          .map((projectDB) => Project.fromJson(projectDB.toJson()))
          .toList();

  List<Project> getAllProjects() {
    return convertToProjectList(getAllProjectsDB());
  }

  Project? getProject(int? projectID) {
    ProjectDB? card = getProjectDB(projectID);
    if (card == null) return null;
    Project? project = Project.fromJson(card.toJson());
    return project;
  }

  ProjectDB? getProjectDB(int? projectID) {
    final query =
        ObjectBox.instance.projectBox
            .query(ProjectDB_.aid_manage_id.equals(projectID!))
            .build();
    ProjectDB? card = query.findFirst();
    query.close();
    return card;
  }

  ProjectDB toProjectDB(Project? project) {
    return ProjectDB.fromJson(project?.toJson() ?? {});
  }

  PersonDB toPersonDB(Person? person) {
    return PersonDB.fromJson(person?.toJson() ?? {});
  }

  Person toPerson(PersonDB? person) {
    print("aid: toPerson ${person?.toJson()}");
    return Person.fromJson(person?.toJson() ?? {});
  }

  void updateProject(Project apiProject) {
    ProjectDB? existingProject = getProjectDB(apiProject.object_id);
    if (existingProject != null) {
      existingProject.title = apiProject.title;
      existingProject.date = apiProject.date;
      existingProject.mobile = apiProject.mobile;
      existingProject.note = apiProject.note;
      projectBox.put(existingProject);
    } else {
      ProjectDB apiProjectDB = toProjectDB(apiProject);
      apiProjectDB.id = 0;
      projectBox.put(apiProjectDB);
    }
  }

  PersonDB? getPersonDB(int? personID, int? projectId) {
    final query =
        ObjectBox.instance.personBox
            .query(
              PersonDB_.aid_person_id
                  .equals(personID!)
                  .and(PersonDB_.project_id.equals(projectId!)),
            )
            .build();
    PersonDB? card = query.findFirst();

    query.close();
    return card;
  }

  Person getPersonByIDAndProject(String? pid, int? projectId) {
    final query =
        ObjectBox.instance.personBox
            .query(
              PersonDB_.person_pid
                  .equals(pid.toString())
                  .and(PersonDB_.project_id.equals(projectId!)),
            )
            .build();
    PersonDB? card = query.findFirst();

    query.close();
    return toPerson(card);
  }

  Person? getPerson(String? personID) {
    final query =
        ObjectBox.instance.personBox
            .query(
              PersonDB_.person_pid
                  .startsWith(personID.toString())
                  .or(PersonDB_.person_pid.endsWith(personID.toString())),
            )
            .build();

    print("getPerson ${query.findFirst()}");
    PersonDB? card = query.findFirst();
    query.close();
    return card != null ? Person.fromJson(card.toJson()) : null;
  }

  List<Person> getAllPersonByProject(int? projectId) {
    List<PersonDB> list =
        ObjectBox.instance.personBox
            .getAll()
            .where((p) => p.project_id == projectId)
            .toList();
    return convertToPersonsList(list);
  }

  List<Person> getAllPersonByIDPerson(String? pid) {
    List<PersonDB> list =
        ObjectBox.instance.personBox
            .getAll()
            .where(
              (p) => p.person_pid.toString().compareTo(pid.toString()) == 0,
            )
            .toList();
    return convertToPersonsList(list);
  }

  bool checkIsReceivedWithProjectAndPerson(String? pid, int? projectId) {
    if (pid == null || projectId == null) return false;
    final query = ObjectBox.instance.personBox.query(
        PersonDB_.person_pid.equals(pid) &
        PersonDB_.project_id.equals(projectId) &
        PersonDB_.isReceived.equals(true)
    ).build();

    final result = query.findFirst();
    query.close();

    return result != null;
  }
  List<Person> getAllPersonById(String? pid) {
    final query =
        ObjectBox.instance.personBox
            .query(
              PersonDB_.person_pid
                  .endsWith(pid.toString())
                  .or(PersonDB_.person_pid.startsWith(pid.toString())),
            )
            .build();
    List<PersonDB> list = query.find();
    return convertToPersonsList(list);
  }

  List<Person> getPersonsByAidManageIdAndReceived(int projectId) {
    List<PersonDB> list =
        ObjectBox.instance.personBox
            .getAll()
            .where((p) => p.project_id == projectId && p.isReceived == true)
            .toList();
    return convertToPersonsList(list);
  }

  List<Person> getPersonsByAidManageIdDeleted(int projectId) {
    List<PersonDB> list =
        ObjectBox.instance.personBox
            .getAll()
            .where((p) => p.project_id == projectId && p.isDeleted == true)
            .toList();
    return convertToPersonsList(list);
  }
  List<PersonDB> getPersonsDBByAidManageIdDeleted(int? projectId) {
    List<PersonDB> list =
        ObjectBox.instance.personBox
            .getAll()
            .where((p) => p.project_id == projectId && p.isDeleted == true)
            .toList();
    return list;
  }

  List<Person> getPersonsByAidManageIdAndNotReceived(int projectId) {
    List<PersonDB> list =
        ObjectBox.instance.personBox
            .getAll()
            .where((p) => p.project_id == projectId && p.isReceived == false)
            .toList();
    return convertToPersonsList(list);
  }

  List<Person> getPersonsByAidManageId(int projectId) {
    List<PersonDB> list =
        ObjectBox.instance.personBox
            .getAll()
            .where((p) => p.project_id == projectId)
            .toList();
    return convertToPersonsList(list);
  }

  List<Map<String, dynamic>> getPersonsByProjectAndReceived(int projectId) {
    List<Person> list = getPersonsByAidManageIdAndReceived(projectId);

    return list
        .map(
          (person) => {
            "id": person.object_id, // استخدام Object ID
            "title": person.note ?? "", // استخدام الملاحظة
            "received_time": person.receivedTime ?? "", // استخدام الملاحظة
          },
        )
        .toList();
  }

  List<Map<String, dynamic>> getPersonsByProjectDeleted(int projectId) {
    List<Person> list = getPersonsByAidManageIdDeleted(projectId);

    return list
        .map(
          (person) => {
            "id": person.object_id, // استخدام Object ID
            "title": person.note ?? "", // استخدام الملاحظة
            "received_time": person.receivedTime, // استخدام الملاحظة
          },
        )
        .toList();
  }

  void resetPersonDeleted(int? projectId) {
    List<PersonDB> list = getPersonsDBByAidManageIdDeleted(projectId);
    for (PersonDB person in list) {
      person.isDeleted = false;
      person.receivedTime = null;
      person.note=null;
      personBox.put(person);
    }
  }

  void updatePerson(Person apiPerson, int? object_id) {
    PersonDB? existingPerson = getPersonDB(apiPerson.object_id, object_id);
    if (existingPerson != null) {
      // print("existingPerson ${existingPerson.project_id} = ${apiPerson.project_id}");
      // existingPerson.project_id = apiPerson.project_id;
      // existingPerson.aid_person_id = apiPerson.object_id;
      // existingPerson.person_pid = apiPerson.person_pid;
      // existingPerson.person_fname = apiPerson.person_fname;
      // existingPerson.person_sname = apiPerson.person_sname;
      // existingPerson.person_tname = apiPerson.person_tname;
      // existingPerson.person_lname = apiPerson.person_lname;
      // existingPerson.date = apiPerson.date;
      // existingPerson.mobile = apiPerson.mobile;

      if (apiPerson.note != null && apiPerson.note!.isNotEmpty) {
        existingPerson.note = apiPerson.note;
      }


      if (apiPerson.isReceived != existingPerson.isReceived) {
        existingPerson.isReceived = apiPerson.isReceived;
      }

      // print("receivedTimexxxxx: ${apiPerson.receivedTime}");
      // print(
      //   "receivedTimexxxxx: ${(apiPerson.receivedTime != null && apiPerson.receivedTime!.isNotEmpty)}",
      // );
      if (apiPerson.receivedTime != null &&
          apiPerson.receivedTime!.isNotEmpty) {
        existingPerson.receivedTime = apiPerson.receivedTime;
      }

      if(apiPerson.person_pid=="804448801"){
        print("Yasser.Kuhail");
        print(apiPerson.toJson());
      }
      personBox.put(existingPerson);
    } else {
      PersonDB apiPersonDB = toPersonDB(apiPerson);
      apiPersonDB.id = 0;

      apiPersonDB.project_id = object_id;
      personBox.put(apiPersonDB);
    }
  }
  void updatePersonDownload(Person apiPerson, int? object_id) {
    PersonDB? existingPerson = getPersonDB(apiPerson.object_id, object_id);
    if (existingPerson != null) {
      // print("existingPerson ${existingPerson.project_id} = ${apiPerson.project_id}");
      // existingPerson.project_id = apiPerson.project_id;
      // existingPerson.aid_person_id = apiPerson.object_id;
      // existingPerson.person_pid = apiPerson.person_pid;
      // existingPerson.person_fname = apiPerson.person_fname;
      // existingPerson.person_sname = apiPerson.person_sname;
      // existingPerson.person_tname = apiPerson.person_tname;
      // existingPerson.person_lname = apiPerson.person_lname;
      // existingPerson.date = apiPerson.date;
      // existingPerson.mobile = apiPerson.mobile;

      if (apiPerson.note != null && apiPerson.note!.isNotEmpty) {
        existingPerson.note = apiPerson.note;
      }


        existingPerson.isReceived = apiPerson.isReceived;


      // print("receivedTimexxxxx: ${apiPerson.receivedTime}");
      // print(
      //   "receivedTimexxxxx: ${(apiPerson.receivedTime != null && apiPerson.receivedTime!.isNotEmpty)}",
      // );
      if (apiPerson.receivedTime != null &&
          apiPerson.receivedTime!.isNotEmpty) {
        existingPerson.receivedTime = apiPerson.receivedTime;
      }

      if(apiPerson.person_pid=="804448801"){
        print("Yasser.Kuhail");
        print(apiPerson.toJson());
      }
      personBox.put(existingPerson);
    } else {
      PersonDB apiPersonDB = toPersonDB(apiPerson);
      apiPersonDB.id = 0;

      apiPersonDB.project_id = object_id;
      personBox.put(apiPersonDB);
    }
  }

  void removePerson(Person apiPerson, int? object_id) {
    PersonDB? existingPerson = getPersonDB(apiPerson.object_id, object_id);
    if (existingPerson != null) {
      // print("existingPerson ${existingPerson.project_id} = ${apiPerson.project_id}");
      // existingPerson.project_id = apiPerson.project_id;
      // existingPerson.aid_person_id = apiPerson.object_id;
      // existingPerson.person_pid = apiPerson.person_pid;
      // existingPerson.person_fname = apiPerson.person_fname;
      // existingPerson.person_sname = apiPerson.person_sname;
      // existingPerson.person_tname = apiPerson.person_tname;
      // existingPerson.person_lname = apiPerson.person_lname;
      // existingPerson.date = apiPerson.date;
      // existingPerson.mobile = apiPerson.mobile;
      if (apiPerson.note != null && apiPerson.note!.isNotEmpty) {
        existingPerson.note = apiPerson.note;
      }

      if (apiPerson.isReceived != existingPerson.isReceived) {
        existingPerson.isReceived = apiPerson.isReceived;
      }

      existingPerson.receivedTime = apiPerson.receivedTime;
      existingPerson.isDeleted = apiPerson.isDeleted;

      print("receivedTime: ${existingPerson.isReceived ?? ""}");
      personBox.put(existingPerson);
    } else {
      PersonDB apiPersonDB = toPersonDB(apiPerson);
      apiPersonDB.id = 0;

      apiPersonDB.project_id = object_id;
      personBox.put(apiPersonDB);
    }
  }

  List<Project> getAllProjectByPerson(Person? person) {
    List<Person> allPersonByIDPerson = ObjectBox.instance
        .getAllPersonByIDPerson(person?.person_pid.toString());
    List<ProjectDB> all = [];
    for (Person person in allPersonByIDPerson) {
      final query =
          ObjectBox.instance.projectBox
              .query(ProjectDB_.aid_manage_id.equals(person.project_id ?? 000))
              .build();
      List<ProjectDB> list = query.find();

      query.close();
      all.addAll(list);
    }

    print(all);
    return convertToProjectList(all);
  }
}
