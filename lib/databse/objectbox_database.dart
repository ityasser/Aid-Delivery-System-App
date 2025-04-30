import 'package:objectbox/objectbox.dart';
import '../data/person_db.dart';
import '../data/project_db.dart';
import '../objectbox.g.dart';
import '../data/person.dart';
import '../data/project.dart';

class ObjectBox {
  static late final ObjectBox _instance;
  late final Store store;
  late final Box<ProjectDB> projectBox;
  late final Box<PersonDB> personBox;

  ObjectBox._create(this.store) {
    projectBox = Box<ProjectDB>(store);
    personBox = Box<PersonDB>(store);
  }

  static Future<void> init() async {
    final store = await openStore();
    _instance = ObjectBox._create(store);
  }

  static ObjectBox get instance => _instance;

  static void clearAll(){
    ObjectBox.instance.projectBox.removeAll();
    ObjectBox.instance.personBox.removeAll();
  }
  void deleteProject(int projectId){
    final project = getProjectDB(projectId);

    ObjectBox.instance.projectBox.remove(project!.id!);
  }
  void deletePersonsInProject(int projectId) {
    final personBox = ObjectBox.instance.personBox;

    final project = getProjectDB(projectId);
    if (project != null) {
      List<PersonDB> persons= ObjectBox.instance.personBox
          .getAll()
          .where((p) =>p.project_id==projectId)
          .toList();
      personBox.removeMany(persons.map((p) => p.id).toList());

    }else{
      print("project is null");
    }
  }

  void deletePersonsReceivedInProject(int projectId) {
    final personBox = ObjectBox.instance.personBox;

    final project = getProjectDB(projectId);
    if (project != null) {
      List<PersonDB> persons= ObjectBox.instance.personBox
          .getAll()
          .where((p) =>p.project_id==projectId && p.isReceived==true)
          .toList();
      personBox.removeMany(persons.map((p) => p.id).toList());

    }else{
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

  PersonDB? getPersonDB(int? personID,int? project_id) {
    final query =
        ObjectBox.instance.personBox
            .query(PersonDB_.aid_person_id.equals(personID!).and(PersonDB_.project_id.equals(project_id!)))
            .build();
    PersonDB? card = query.findFirst();
    query.close();
    return card;
  }
  Person? getPerson(int? personID) {
    final query = ObjectBox.instance.personBox.query(PersonDB_.person_pid.endsWith("$personID"))
            .build();
    print("getPerson ${query.findFirst()}");
    PersonDB? card = query.findFirst();
    query.close();
    return card!=null?Person.fromJson(card.toJson()):null;
  }

  List<Person> getAllPersonByProject(int? projectId) {

    List<PersonDB> list= ObjectBox.instance.personBox
        .getAll()
        .where((p) =>p.project_id==projectId)
        .toList();
    return convertToPersonsList(list);
  }
  List<Person> getAllPersonById(int pid) {
    final query = ObjectBox.instance.personBox.query(PersonDB_.person_pid.endsWith("$pid"))
        .build();
    List<PersonDB> list=query.find();
    return convertToPersonsList(list);
  }
  List<Person> getPersonsByAidManageIdAndReceived(int projectId) {
    List<PersonDB> list= ObjectBox.instance.personBox
        .getAll()
        .where((p) =>p.project_id==projectId && p.isReceived==true)
        .toList();
    return convertToPersonsList(list);
  }
  List<Person> getPersonsByAidManageIdAndNotReceived(int projectId) {
    List<PersonDB> list= ObjectBox.instance.personBox
        .getAll()
        .where((p) =>p.project_id==projectId && p.isReceived==false)
        .toList();
    return convertToPersonsList(list);
  }
  List<Map<String, dynamic>> getPersonsByProjectAndReceived(int projectId) {

    List<Person> list = getPersonsByAidManageIdAndReceived(projectId);

    return list.map((person) => {
      "id": person.object_id, // استخدام Object ID
      "title": person.note??"", // استخدام الملاحظة
    }).toList();
  }

void  updatePerson(Person apiPerson, Project? project) {

    PersonDB? existingPerson = getPersonDB(apiPerson.object_id,project?.object_id);
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
      existingPerson.note = apiPerson.note;
      existingPerson.isReceived = apiPerson.isReceived;
       personBox.put(existingPerson);

    } else {
      PersonDB apiPersonDB = toPersonDB(apiPerson);
      apiPersonDB.id = 0;

      apiPersonDB.project_id = project?.object_id;
      personBox.put(apiPersonDB);


    }
  }

  List<Project> getAllProjectByPerson(Person? person) {
    final query = ObjectBox.instance.projectBox.query(ProjectDB_.aid_manage_id.equals(person?.project_id??000))
        .build();
    List<ProjectDB> list = query.find();
    query.close();

    print(list);
    return convertToProjectList(list);
  }
}
