import 'package:dio/dio.dart';

class DioClient {
  DioClient._();

  static final DioClient instance = DioClient._();

  final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: 'https://jsonplaceholder.typicode.com',
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {'Content-Type': 'application/json'},
          ),
        )
        ..interceptors.add(
          LogInterceptor(request: true, requestBody: true, responseBody: true),
        );

  String handleNetworkError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout) {
      return 'Connection time out, check internet';
    }
    return 'something went wrong';
  }
}
