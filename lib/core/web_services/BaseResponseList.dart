
import 'package:aid_registry_flutter_app/data/project_db.dart';

import '../../data/aid.dart';
import '../../data/person.dart';
import '../../data/person_db.dart';
import '../../data/project.dart';

class BaseResponseList<T> {
  bool? status;
  List<T>? data;
  String? message;
  int? code;
  Map<String, dynamic>? errors;


  BaseResponseList({this.status = false, this.data, this.message, this.code, this.errors});

  BaseResponseList.fromJson(Map<dynamic, dynamic>? json,{String? key,String? varData}) {
    varData = varData ?? 'data';
    status = (json?['status'] as bool?) ?? true;
    data =json![varData]!=null?(((key!=null)?json![varData][key]:json![varData]) as List).map(fromJson).toList():[];
    message = json['message'].toString().isEmpty ? null : json['message'];
    code = json['code'];
    errors = json['errors'];
  }

  T fromJson(dynamic json) {
    if (T == Aid) return Aid.fromJson(json) as T;
    if (T == Project) return Project.fromJson(json) as T;
    if (T == Person) return Person.fromJson(json) as T;
    if (T == ProjectDB) return ProjectDB.fromJson(json) as T;
    if (T == PersonDB) return PersonDB.fromJson(json) as T;
    return json as T;
  }


}

