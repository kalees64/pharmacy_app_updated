import 'package:dio/dio.dart';
import 'package:pharmacy_app_updated/constants/environment.dart';
import 'package:pharmacy_app_updated/constants/logger.dart';
import 'package:pharmacy_app_updated/interceptor/dio.interceptor.dart';

class MedicineService {
  final Dio _http = DioConfig.createDio();

  dynamic getMedicines() async {
    try {
      final url = "$apiUrl/medicines";
      final res = await _http.get(url);
      logger.d("Get medicines response : $res");

      if (res.statusCode == 200) {
        return res.data;
      }
    } catch (e) {
      logger.e("Error while getting medicines $e");
    }
  }
}
