import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aid_registry_flutter_app/core/web_services/server_error.dart';

import '../utils/dialog_service.dart';
import '../utils/helpers.dart';
import 'BaseResponse.dart';
import 'BaseResponseList.dart';
import 'network.dart';

class Webservice with Helpers {
  Dio client = Network().dio;

  static String getErrorsFromJson(Map<dynamic, dynamic>? json) {
    var errors = StringBuffer();
    if (json!.containsKey("msg")) errors.writeln(json["msg"]);

    if (!json.containsKey("errors") && json.containsKey("message"))
      errors.writeln(json["message"]);

    if (json.containsKey("exception"))
      errors.writeln(
        json["exception"].substring(json["exception"].lastIndexOf('\\') + 1),
      );

    if (json.containsKey("file"))
      errors.writeln(json["file"].substring(json["file"].lastIndexOf('/') + 1));

    if (json.containsKey("line")) errors.writeln("line:${json["line"]}");

    if (json.containsKey("errors"))
      json["errors"].forEach((i, value) {
        errors.writeln(value[0]);
      });

    return errors.toString().trim();
  }

  Future<BaseResponse<T>?> parsePostError<T>(
    DioError error, {
    Function()? onUnauthorized,
  }) async {
    if (error.response?.statusCode == 401) {
      Map<String, dynamic> body = {
        "status": false,
        "code": error.response?.statusCode,
        "message": "",
        "data": [],
      };
      BaseResponse<T> res = BaseResponse.fromJson(body);
      onUnauthorized ?? DialogService.showDialogUnauthorized;

      if (onUnauthorized != null) {
        onUnauthorized();
      } else {
        DialogService.showDialogUnauthorized();
      }
      // onUnauthorized??showDialogUnauthorized;

      return res;
    } else {
      dynamic msg = ServerError.withError(error: error).getErrorMessage();
      String err = msg is String ? msg : getErrorsFromJson(msg);
      Map<String, dynamic> body = {
        "status": false,
        "code": getStatusCodeFromDioError(error),
        "message": err,
        "data": [],
      };
      BaseResponse<T> res = BaseResponse.fromJson(body);
      return res;
    }
  }

  Future<BaseResponseList<T>?> parsePostListError<T>(
    DioError error, {
    Function()? onUnauthorized,
  }) async {
    if (error.response?.statusCode == 401 || error.response?.statusCode == 203) {
      print("parsePostListError ${error.response?.statusCode}");

      Map<String, dynamic> body = {
        "status": false,
        "code": error.response?.statusCode,
        "message": "",
        "data": [],
      };
      BaseResponseList<T> res = BaseResponseList.fromJson(body);
    //  onUnauthorized ?? DialogService.showDialogUnauthorized();
      /* AwesomeDialog(
          context: App.navigatorKey.currentContext!,
          dialogType: DialogType.INFO,
          animType: AnimType.BOTTOMSLIDE,
          desc: App.getString().please_login,
          btnOkText: App.getString().login,
          btnCancelText: App.getString().sign_up,
          btnCancelOnPress: () {
            App.navigatorKey.currentState?.pushAndRemoveUntil(
                MyRoute(
                    builder: (context) {
                      return SignupUi();
                    },
                    type: TransitionType.fade),
                (Route<dynamic> route) => false);
          },
          btnOkOnPress: () {
            App.navigatorKey.currentState?.pushAndRemoveUntil(
                MyRoute(
                    builder: (context) {
                      return LoginUi();
                    },
                    type: TransitionType.fade),
                (Route<dynamic> route) => false);
          },
        ).show();*/
      return res;
    } else {
      dynamic msg = ServerError.withError(error: error).getErrorMessage();
      String err = msg is String ? msg : getErrorsFromJson(msg);
      Map<String, dynamic> body = {
        "status": false,
        "code": getStatusCodeFromDioError(error),
        "message": err,
        "data": [],
      };
      BaseResponseList<T> res = BaseResponseList.fromJson(body);
      return res;
    }
  }

  Future<BaseResponse<T>?> post<T>(
    String path, {
    Map<String, dynamic>? formData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    Function()? onUnauthorized,
  }) async {
    try {
      var response = await client.post<Map<String, dynamic>>(
        path,
        data: body ?? FormData.fromMap(formData ?? {}),
        options: Options(headers: headers),
        queryParameters: queryParameters,
      );
      response.data?["code"] = 200;
      BaseResponse<T> res = BaseResponse.fromJson(response.data);
      print(res);
      return res;
    } on DioException catch (error) {
      return await parsePostError(error, onUnauthorized: onUnauthorized);
    }
  }

  Future<BaseResponseList<T>?> postList<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Function()? onUnauthorized,
        String? varData,
  }) async {
    try {
      var formData = FormData.fromMap(body!);
      var response = await client.post<Map>(
        path,
        data: formData,
        queryParameters: queryParameters,
      );

      print(response.data);
      print(response.statusCode);
      if (response.statusCode == 200) {
        response.data!["code"] = 200;
        BaseResponseList<T> res = BaseResponseList.fromJson(response.data,varData:varData);
        return res;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,

          type: DioExceptionType.badResponse,
          error: 'Unexpected status code: ${response.statusCode}',
        );
      }
    } on DioException catch (error) {
      print("error: $error");
      return await parsePostListError(error, onUnauthorized: onUnauthorized);
    }
  }

  Future<BaseResponse<T>?> postFile<T>(
    String path, {
    Map<String, dynamic>? body,
    File? file,
    File? mainImage,
    File? avatar,
    File? licenseDocument,
    String? fileNameMap,
    List<File?>? files,
    MapEntry<String, MultipartFile>? mapEntry,
    Function()? onUnauthorized,
  }) async {
    try {
      print('body');
      print(body.toString());

      FormData formData = FormData.fromMap(body ?? {});

      if (files != null) {
        var myFile = <MapEntry<String, MultipartFile>>[];
        for (int i = 0; i < files.length; i++) {
          if (files[i] != null)
            myFile.add(
              MapEntry(
                "images[$i]",
                MultipartFile.fromFileSync(
                  files[i]!.path,
                  filename: files[i]?.path.split(Platform.pathSeparator).last,
                ),
              ),
            );
        }

        formData.files.addAll(myFile);
      }
      if (file != null && file.path.isNotEmpty) {
        formData.files.add(
          MapEntry(
            fileNameMap ?? 'file',
            MultipartFile.fromFileSync(
              file.path,
              filename: file.path.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }

      if (mainImage != null && mainImage.path.isNotEmpty) {
        formData.files.add(
          MapEntry(
            'main_image',
            MultipartFile.fromFileSync(
              mainImage.path,
              filename: mainImage.path.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }
      if (licenseDocument != null && licenseDocument.path.isNotEmpty) {
        formData.files.add(
          MapEntry(
            'lisence',
            MultipartFile.fromFileSync(
              licenseDocument.path,
              filename: licenseDocument.path.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }
      if (avatar != null && avatar.path.isNotEmpty) {
        formData.files.add(
          MapEntry(
            'avatar',
            MultipartFile.fromFileSync(
              avatar.path,
              filename: avatar.path.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }

      if (mapEntry != null) formData.files.add(mapEntry);

      var response = await client.post<Map>(path, data: formData);
      print(response.statusCode);
      print(response.data);
      response.data!["code"] = 200;

      print(response.data);
      BaseResponse<T> res = BaseResponse.fromJson(response.data);
      return res;
    } on DioError catch (error) {
      return parsePostError(error);
    }
  }

  Future<BaseResponse<T>?> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    String? key,
  }) async {
    try {
      var response = await client.get<Map>(
        path,
        queryParameters: queryParameters,
      );
      response.data!["code"] = 200;
      BaseResponse<T> res = BaseResponse.fromJson(response.data, key: key);
      return res;
    } on DioError catch (error) {
      dynamic msg = ServerError.withError(error: error).getErrorMessage();
      String err = msg is String ? msg : getErrorsFromJson(msg);
      print("DioError: $err");
      Map<String, dynamic> body = {
        "status": false,
        "code": getStatusCodeFromDioError(error),
        "message": err,
        "data": [],
      };
      BaseResponse<T> res = BaseResponse.fromJson(body);

      return res;
    }
  }

  Future<BaseResponse<T>?> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      var response = await client.delete<Map>(
        path,
        queryParameters: queryParameters,
      );
      response.data!["code"] = 200;
      BaseResponse<T> res = BaseResponse.fromJson(response.data);
      return res;
    } on DioError catch (error) {
      dynamic msg = ServerError.withError(error: error).getErrorMessage();
      String err = msg is String ? msg : getErrorsFromJson(msg);
      Map<String, dynamic> body = {
        "status": false,
        "code": getStatusCodeFromDioError(error),
        "message": err,
        "data": [],
      };
      BaseResponse<T> res = BaseResponse.fromJson(body);

      return res;
    }
  }

  Future<BaseResponseList<T>?> getList<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    String? key,
    String? url,
        String? varData
  }) async {
    try {
      var response = await client.get<Map>(
        path,
        queryParameters: queryParameters,
      );
      response.data!["code"] = 200;
      print(response.data);
      BaseResponseList<T> res = BaseResponseList.fromJson(
        response.data,
        key: key,
        varData: varData
      );
      return res;
    } on DioError catch (error) {
      dynamic msg = ServerError.withError(error: error).getErrorMessage();
      String err = msg is String ? msg : getErrorsFromJson(msg);
      Map<String, dynamic> body = {
        "status": false,
        "code": getStatusCodeFromDioError(error),
        "message": err,
        "data": [],
      };
      BaseResponseList<T> res = BaseResponseList.fromJson(body);
      return res;
    }
  }

  int? getStatusCodeFromDioError(DioError error) {
    if (error.type == DioErrorType.badResponse) {
      return error.response!.statusCode!;
    } else {
      return 500;
    }
  }
}
