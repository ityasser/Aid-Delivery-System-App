import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../core/web_services/BaseResponse.dart';
import '../core/web_services/BaseResponseList.dart';
import '../core/web_services/apis.dart';
import '../data/person.dart';
import '../data/project.dart';
import 'objectbox_database.dart';

class SyncService {


  SyncService();


 static Future<void> sync() async {
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
   if (connectivityResult.contains(ConnectivityResult.wifi)) {
       await syncData();
    } else {
      print("No internet connection, sync postponed.");
    }
  }
  static Future<bool> downloadPersonByProject(Project item) async {
    try {
      BaseResponseList<Person>? response = await Apis().getPerson(item.object_id);
      if (response != null) {
        if (response.status!) {
          List<Person> persons=response.data ?? [];
          Project? project = ObjectBox.instance.getProject(item.object_id);
          if (project == null) {
            print("downloadPersonByProject: ${item.aids_name} =>Project ${project?.aids_name} not found!");
            return false;
          }else{
            print("downloadPersonByProject: ${item.aids_name} =>persons length : ${persons.length}");
            for (var person in persons) {
              ObjectBox.instance.updatePerson(person, project);
            }
            print("downloadPersonByProject: ${item.aids_name} =>${response.message ?? ""}");
            return true;
          }
        } else {
          print("downloadPersonByProject: ${item.aids_name} =>${response.message ?? ""}");
          return false;
        }
      } else {
        print("downloadPersonByProject: ${item.aids_name} =>Response Error");
        return false;
      }
    } catch (error) {
      print("downloadPersonByProject: ${item.aids_name} =>${error.toString() ?? ""}");
      return false;
    }
  }

  static Future<void> uploadPersonByProject(Project item) async {
    try {
      List<Map<String, dynamic>> json = ObjectBox.instance.getPersonsByProjectAndReceived(item.object_id ?? 0);
      print("uploadProjectWithPersons: ${item.aids_name} =>$json");
      if(json.isNotEmpty){
      BaseResponse? response = await Apis().uploadPersons({"data": jsonEncode(json)});
      if (response != null) {
        if (response.status!) {
          print("uploadProjectWithPersons: ${item.aids_name} =>${response.message ?? ""}");
          // ObjectBox.instance.deletePersonsReceivedInProject(item.object_id!);
          print("uploadProjectWithPersons: ${item.aids_name} =>delete Persons In Project");
        } else {
          print("uploadProjectWithPersons: ${item.aids_name} =>${response.message ?? ""}");
        }
      } else {
        print("uploadProjectWithPersons: ${item.aids_name} =>Response Error");
      }
      }else{
        print("uploadProjectWithPersons: ${item.aids_name} => No Found Data");
      }
    } catch (error) {
      print("uploadProjectWithPersons: ${item.aids_name} =>${error.toString()}");
    }
  }

  static Future<void> syncData()async {
   List<Project> projects=ObjectBox.instance.getAllProjects();
   for (var project in projects) {
     await uploadPersonByProject(project);
     await downloadPersonByProject(project);
   }
  }
}
