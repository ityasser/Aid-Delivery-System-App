import 'dart:convert';

import 'package:aid_registry_flutter_app/core/utils/extension.dart';
import 'package:aid_registry_flutter_app/data/project_db.dart';
import 'package:objectbox/objectbox.dart';


@Entity()
class PersonDB  {

  @Id()
  int id = 0;

  int? aid_person_id;
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

  get fullName {
    return "$person_fname $person_sname $person_tname $person_lname";
  }

  PersonDB({this.aid_person_id});

  PersonDB.fromJson(Map<String, dynamic> json) {
    project_id =json['project_id'] as int?;
    aid_person_id =json['aid_person_id'] as int;
    person_pid = json['person_pid'] as String?;
    note = json['note'] as String?;
    person_fname = json['person_fname'] as String?;
    person_sname = json['person_sname'] as String?;
    person_tname = json['person_tname'] as String?;
    person_lname = json['person_lname'] as String?;
    mobile = json['person_mob_1'] as String?;
    isReceived = (json['is_received'] as bool?)??false;
  }

  // Person({int? id_object}) : super(id_object: id_object);


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = Map<String, dynamic>();
    json['id'] = id;
    json['note'] = note;
    json['aid_person_id'] = '$aid_person_id';
    json['person_pid'] = person_pid;
    json['aid_manage_date'] = date;
    json['person_mob_1'] = mobile;
    json['person_fname'] = person_fname ;
    json['person_sname'] =person_sname ;
    json['person_tname'] =person_tname ;
    json['person_lname'] =person_lname ;
    json['is_received'] =isReceived ;
    json['project_id'] =project_id ;

    return json;
  }

  @override
  String toString() {
    // TODO: implement toString
   return jsonEncode(toJson());
  }
}
