import 'dart:convert';

import 'package:aid_registry_flutter_app/core/utils/extension.dart';
import 'package:aid_registry_flutter_app/data/person.dart';

import '../core/models/identifiable.dart';
import 'package:objectbox/objectbox.dart';


class Project  extends Identifiable  {



  String? aids_name;
  String? donation_name;
  String? title;
  String? date;
  String? mobile;
  String? note;
  String? storesName;
  String? printNote;

  Project({int? object_id})
      : super(object_id: object_id);

  Project.fromJson(Map<String, dynamic> json) : super(object_id: (json['aid_manage_id'] as String).toInt()) {
    object_id =  (json['aid_manage_id'] as String).toInt();
    donation_name = json['donation_name'] as String?;
    aids_name = json['aids_name'] as String?;
    title = json['aid_manage_title'] as String?;
    date = json['aid_manage_date'] as String?;
    mobile = json['mobile'] as String?;
    note = json['aid_manage_note'] as String?;
    storesName = json['stores_area_name'] as String?;
    printNote = json['print_note'] as String?;


  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = Map<String, dynamic>();
    json['aid_manage_id'] = '$object_id';
    json['aids_name'] = aids_name;
    json['donation_name'] = donation_name;
    json['aid_manage_title'] = title;
    json['aid_manage_date'] = date;
    json['mobile'] = mobile;
    json['aid_manage_note'] = note;
    json['stores_area_name'] = storesName;
    json['print_note'] = printNote;


    return json;
  }
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson() );
  }
}
