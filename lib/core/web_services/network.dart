import 'dart:io';
import 'package:dio/dio.dart';
import '../constant/urls.dart';
import '../utils/user_preference.dart';

class Network {
  static final Network _singleton = new Network._internal();

  factory Network() {
    return _singleton;
  }

  Network._internal();

  Dio get dio {
    Dio dio = Dio();

    dio.options.baseUrl = ConstantsUrl.baseUrl;
    dio.options.connectTimeout = Duration(seconds: 20);
    dio.options.receiveTimeout = Duration(seconds: 20);

    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      String token = UserPreferences().token;
      if (token.isNotEmpty) {
        options.headers["Authorization"] = "Bearer " + token;
        options.headers["auth"] = token;
        print("token: $token");
      }


      options.headers["Accept-Language"] = UserPreferences().language;
      options.headers["X-Client-Device-Name"] = "${Platform.operatingSystem}";
      options.headers["Accept"] = "application/json";

      print("############# Dio ###########");
      print("url >> ${options.uri}");
      print(options.data);
      print(options.headers);
     // print(e.response!.statusCode);
      print("############# Dio ###########");
      return handler.next(options);
    }, onResponse: (response, handler) {
      //final int? statusCode = response.statusCode;
      // print("Response From:${statusCode} ${response.request.method} ${response.request.baseUrl} ${response.request.path}");
      // print("Response From:${response.toString()}");
      return handler.next(response); // continue
    }, onError: (DioError e, handler) {
      print("############# DioError ########### ");
      print(e.response!.realUri);
      print(e.response!.data);
      print(e.response!.statusCode);
      print("############# DioError ###########");
      return handler.next(e); //continue
    }));

    return dio;
  }
}
