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
  static Future<bool> downloadPersonByProject(Project item,{Function(String? note)? message}) async {
    try {
      BaseResponseList<Person>? response = await Apis().getAllPerson(item.object_id);
      if (response != null) {
        if (response.status!) {
          List<Person> persons=response.data ?? [];
          Project? project = ObjectBox.instance.getProject(item.object_id);
          if (project == null) {
            print("downloadPersonByProject: ${item.aids_name} =>Project ${project?.aids_name} not found!");
            if(message!=null)message(response.message);
            return false;
          }else{
            print("downloadPersonByProject: ${item.aids_name} =>persons length : ${persons.length}");

            for (var person in persons) {
              ObjectBox.instance.updatePersonDownload(person, project.object_id);
            }
            print("downloadPersonByProject: ${item.aids_name} =>${response.message ?? ""}");
            if(message!=null)message(response.message);
            return true;
          }
        } else {
          print("downloadPersonByProject: ${item.aids_name} =>${response.message ?? ""}");
          if(message!=null)message(response.message);
          return false;
        }
      } else {
        print("downloadPersonByProject: ${item.aids_name} =>Response Error");
        if(message!=null)message("Response Error");
        return false;
      }
    } catch (error) {
      print("downloadPersonByProject: ${item.aids_name} =>${error.toString() ?? ""}");
      if(message!=null)message(error.toString());
      return false;
    }
  }

  static Future<bool> uploadPersonByProject(Project item,{Function(String? note)? message}) async {
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
          if(message!=null)message(response.message);
          return true;
        } else {
          print("uploadProjectWithPersons: ${item.aids_name} =>${response.message ?? ""}");
          if(message!=null)message(response.message);
          return false;
        }
      } else {

        print("uploadProjectWithPersons: ${item.aids_name} =>Response Error");
        if(message!=null)message("Response Error");
        return false;

      }
      }else{
        print("uploadProjectWithPersons: ${item.aids_name} => No Found Data");
        if(message!=null)message("No Found Data Fo upload");
        return true;
      }
    } catch (error) {
      print("uploadProjectWithPersons: ${item.aids_name} =>${error.toString()}");
      if(message!=null)message(error.toString());
      return false;
    }
  }
static Future<void> uploadDeletedPersonByProject(Project item,{Function(String? note)? message}) async {
    try {
      List<Map<String, dynamic>> json = ObjectBox.instance.getPersonsByProjectDeleted(item.object_id ?? 0);
      print("uploadProjectWithPersonsDeleted: ${item.aids_name} =>$json");
      if(json.isNotEmpty){
      BaseResponse? response = await Apis().uploadPersonsDeleted({"data": jsonEncode(json)});
      if (response != null) {
        if (response.status!) {

          ObjectBox.instance.resetPersonDeleted(item.object_id);
          print("uploadProjectWithPersonsDeleted: ${item.aids_name} =>${response.message ?? ""}");
          // ObjectBox.instance.deletePersonsReceivedInProject(item.object_id!);
          print("uploadProjectWithPersonsDeleted: ${item.aids_name} =>delete Persons In Project");
          if(message!=null)message(response.message);
        } else {
          print("uploadProjectWithPersonsDeleted: ${item.aids_name} =>${response.message ?? ""}");
          if(message!=null)message(response.message);
        }
      } else {
        print("uploadProjectWithPersonsDeleted: ${item.aids_name} =>Response Error");
        if(message!=null)message("Response Error");
      }
      }else{
        print("uploadProjectWithPersonsDeleted: ${item.aids_name} => No Found Data");
        if(message!=null)message("No Found Data Fo upload");
      }
    } catch (error) {
      print("uploadProjectWithPersonsDeleted: ${item.aids_name} =>${error.toString()}");
      if(message!=null)message(error.toString());
    }
  }

  static Future<void> syncData()async {
   List<Project> projects=ObjectBox.instance.getAllProjects();
   for (var project in projects) {
     await uploadDeletedPersonByProject(project);
     bool status=await uploadPersonByProject(project);
     if(status)
       await downloadPersonByProject(project);
     //
   }
  }
}
