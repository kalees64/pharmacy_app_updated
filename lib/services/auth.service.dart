import 'package:dio/dio.dart';
import 'package:pharmacy_app_updated/constants/environment.dart';
import 'package:pharmacy_app_updated/constants/logger.dart';
import 'package:pharmacy_app_updated/interceptor/dio.interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _http = DioConfig.createDio();

  dynamic login(Map<String, dynamic> data) async {
    final url = "$apiUrl/auth/login";
    try {
      final res = await _http.post(url, data: data);

      if (res.statusCode == 200) {
        return res.data;
      }

      if (res.statusCode == 404) {
        return null;
      }
    } catch (e) {
      logger.e("--Error while login : ${e.toString()}");
      // rethrow;
    }
  }

  dynamic getUserDataFromLocalStorage() async {
    final SharedPreferences localStorage =
        await SharedPreferences.getInstance();
    final dynamic userData = localStorage.getString('user');
    return userData;
  }

  dynamic getUserTokenFromLocalStorage() async {
    final SharedPreferences localStorage =
        await SharedPreferences.getInstance();
    final String? token = localStorage.getString('token');
    return token;
  }

  dynamic getUserRolesByUserId(Map<String, dynamic> data) async {
    try {
      final url = '$apiUrl/auth/role';
      final res = await _http.post(url, data: data);
      logger.i("--Fetching user roles response : $res");

      if (res.statusCode == 200) {
        return res.data;
      }

      if (res.statusCode == 404) {
        return null;
      }
    } catch (e) {
      logger.e("--Error while fetching user roles : $e");
    }
  }
}
