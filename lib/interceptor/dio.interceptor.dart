import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pharmacy_app_updated/constants/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioConfig {
  static Dio createDio() {
    final dio = Dio();

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final SharedPreferences localStorage =
            await SharedPreferences.getInstance();
        final tokenData = localStorage.getString('token');
        if (tokenData != null) {
          final token = json.decode(tokenData);
          logger.w("--Token details from interceptor : $token");
          options.headers['Authorization'] = 'Bearer $token';
        }
        options.headers['Content-Type'] = 'application/json';
        logger.d('Request: ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        logger.i('Response: ${response.statusCode}');
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        logger.d('Error: ${error.response?.statusCode}');
        if (error.response?.statusCode == 401) {
          logger.e('Unauthorized! Handle token refresh here.');
        }
        return handler.next(error);
      },
    ));

    return dio;
  }
}
