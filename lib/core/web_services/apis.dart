import 'dart:io';
import 'package:aid_registry_flutter_app/data/person.dart';
import 'package:aid_registry_flutter_app/data/project.dart';

import '../../data/aid.dart';
import '../constant/urls.dart';
import 'BaseResponse.dart';
import 'BaseResponseList.dart';
import 'webservice.dart';

class Apis {

  static final Apis _instance = Apis._internal();

  factory Apis() {
    return _instance;
  }

  Apis._internal();



  Future<BaseResponse<UserResponse>?> login<UserResponse>(
      Map<String, dynamic>? body,
      ) async {
    print("login");

    print(body);
    BaseResponse<UserResponse>? response =
    await Webservice().post(ConstantsUrl.login, formData: body);
    return response!;
  }
  Future<BaseResponse?> uploadPersons(
      Map<String, dynamic>? body,
      ) async {
    print("uploadPersons");

    print(body);
    BaseResponse? response =
    await Webservice().post(ConstantsUrl.setReceive, formData: body);
    return response!;
  }

  Future<BaseResponse?> uploadPersonsDeleted(
      Map<String, dynamic>? body,
      ) async {
    print("uploadPersons");

    print(body);
    BaseResponse? response =
    await Webservice().post(ConstantsUrl.setNotReceive, formData: body);
    return response!;
  }

  Future<BaseResponseList<Aid>?> getAids({Map<String, dynamic>? query})async {

    BaseResponseList<Aid>? response = await Webservice().getList(ConstantsUrl.projects,queryParameters: query);
    return response!;
  }
  Future<BaseResponseList<Project>?> getProjects({Map<String, dynamic>? query})async {
    BaseResponseList<Project>? response = await Webservice().postList(ConstantsUrl.projects,body: query);
    return response!;
  }
  Future<BaseResponseList<Person>?> getPerson(int? id,{Map<String, dynamic>? query})async {
    BaseResponseList<Person>? response = await Webservice().getList("${ConstantsUrl.person}$id",queryParameters: query,varData: "person");
    return response!;
  }
  Future<BaseResponseList<Person>?> getAllPerson(int? id,{Map<String, dynamic>? query})async {
    BaseResponseList<Person>? response = await Webservice().getList("${ConstantsUrl.all_person}$id",queryParameters: query,varData: "person");
    return response!;
  }

  Future<BaseResponse?> closeCobon(int? id)async {
    BaseResponse? response = await Webservice().get("${ConstantsUrl.closeCobon}/$id",);
    return response;

  }


  Future<BaseResponse<T>?> logout<T>() async {
    BaseResponse<T>? response = await Webservice().get(ConstantsUrl.logout);
    return response;
  }


}
