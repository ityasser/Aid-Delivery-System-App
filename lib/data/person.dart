import 'dart:convert';

import 'package:aid_registry_flutter_app/core/utils/extension.dart';
import 'package:aid_registry_flutter_app/data/project.dart';
import 'package:aid_registry_flutter_app/data/project_db.dart';
import 'package:objectbox/objectbox.dart';

import '../core/models/identifiable.dart';

class Person extends Identifiable {


  int? project_id;
  String? person_pid;
  String? person_fname;
  String? person_sname;
  String? person_tname;
  String? person_lname;
  String? date;
  String? note;
  String? mobile;
  bool isReceived = false;
  bool isDeleted = false;
  String? receivedTime ;
  get fullName {
    return "$person_fname $person_sname $person_tname $person_lname";
  }

  Person({int? object_id})
      : super(object_id: object_id);

  Person.fromJson(Map<String, dynamic> json)
      : super(object_id: (json['aid_person_id'] as String?)?.toInt()) {
    project_id = json['project_id'] as int?;
    object_id = (json['aid_person_id'] as String?)?.toInt();
    person_pid = json['person_pid'] as String?;
    note = json['note'] as String?;
    person_fname = json['person_fname'] as String?;
    person_sname = json['person_sname'] as String?;
    person_tname = json['person_tname'] as String?;
    person_lname = json['person_lname'] as String?;
    mobile = json['person_mob_1'] as String?;
    isReceived = (json['aid_person_status_rec']?.toString() == "1");
    receivedTime= json['received_time'] as String?;
    isDeleted= json['is_deleted'] as String?;

  }

  // Person({int? id_object}) : super(id_object: id_object);


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = Map<String, dynamic>();
    json['note'] = note;
    json['aid_person_id'] = object_id;
    json['person_pid'] = person_pid;
    json['aid_manage_date'] = date;
    json['person_mob_1'] = mobile;
    json['person_fname'] = person_fname ;
    json['person_sname'] =person_sname ;
    json['person_tname'] =person_tname ;
    json['person_lname'] =person_lname ;
    json['aid_person_status_rec'] =isReceived ? "1" : "0" ;
    json['project_id'] =project_id ;
    json['received_time'] =receivedTime ;
    json['is_deleted'] =isDeleted ;


    return json;
  }

  @override
  String toString() {
    // TODO: implement toString
   return "$person_pid";
   return jsonEncode(toJson());
  }
}
