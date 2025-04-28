import 'package:aid_registry_flutter_app/core/utils/extension.dart';

import '../core/models/identifiable.dart';

class User extends Identifiable {
  String? id;
  String? name;
  String? email;
  String? mobile;
  String? hash;
  String? store_id;
  String? store_name;

   User({int? object_id}) : super(object_id: object_id);

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String?;
    name = json['name'] as String?;
    email = json['email'] as String?;
    mobile = json['mobile'] as String?;
    hash = json['hash'] as String?;
    store_id = json['store_id'] as String?;
    store_name = json['store_name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = Map<String, dynamic>();
    json['id'] = id;
    json['name'] = name;
    json['email'] = email;
    json['mobile'] = mobile;
    json['hash'] = hash;
    json['store_id'] = store_id;
    json['store_name'] = store_name;

    return json;
  }
}
