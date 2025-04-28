import '../../data/project.dart';
import '../../data/user.dart';
import 'BaseResponseList.dart';

class BaseResponse<T> {
  bool? status;
  int? code;
  T? data;
  String? message;
  Map<String, dynamic>? errors;

  BaseResponse(
      {this.status = false, this.data, this.message, this.code, this.errors});


  BaseResponse.fromJson(Map<dynamic, dynamic>? json,{String? key}) {
    status = json!['status'] as bool;
    data = json['data'] != null ? (json["data"] is List) ? null : (key != null)? fromJson(json['data'][key]):fromJson(json['data']) : json['data'];
    message = json['message'] == '' ? null : json['message'];
    code = json['code'];
    errors = json['errors'];
  }

  T fromJson(dynamic json) {
    if (T == User) return User.fromJson(json) as T;
    if (T == Project) return Project.fromJson(json) as T;

    return json as T;
  }

  BaseResponseList<M> toBaseResponseList<M>(List<M>? Function(T? data) list) {
    return BaseResponseList<M>(
      status: status,
      message: message,
      code: code,
      errors: errors,
      data: list(data),
    );
  }
}
