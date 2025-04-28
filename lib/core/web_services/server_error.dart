import 'package:dio/dio.dart' hide Headers;

class ServerError implements Exception {
  dynamic _errorMessage = "";

  ServerError.withError({DioError? error}) {
    _handleError(error!);
  }

  getErrorMessage() {
    return _errorMessage;
  }

  _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        _errorMessage = "Request was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        _errorMessage = "Connection timeout";
        break;
      case DioExceptionType.unknown:
        _errorMessage = "Connection failed due to internet connection";
        break;
      case DioExceptionType.receiveTimeout:
        _errorMessage = "Receive timeout in connection";
        break;
      case DioExceptionType.badResponse:
          _errorMessage = error.response!.data;
        break;
      case DioExceptionType.sendTimeout:
        _errorMessage = "Receive timeout in send request";
        break;
      case DioExceptionType.badCertificate:
        // TODO: Handle this case.
        _errorMessage = "Bad Certificate";
      case DioExceptionType.connectionError:
        // TODO: Handle this case.
        _errorMessage = "Connection Error";
    }
    return _errorMessage;
  }
}
