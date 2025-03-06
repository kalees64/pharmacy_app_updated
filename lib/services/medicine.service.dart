import 'package:dio/dio.dart';
import 'package:pharmacy_app_updated/constants/environment.dart';
import 'package:pharmacy_app_updated/constants/logger.dart';
import 'package:pharmacy_app_updated/interceptor/dio.interceptor.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';

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

  dynamic getMedicineByOriginalQrCodedata(String data) async {
    try {
      final url = "$apiUrl/medicines?originalQrCodeData=$data";
      final res = await _http.get(url);
      logger.d("Get medicine by original qr code data response : $res");

      if (res.statusCode == 200) {
        return res.data;
      }
    } catch (e) {
      logger.e("Error while getting medicine by original qr code data $e");
    }
  }

  dynamic getMedicineAccessCode(String data) async {
    try {
      final url = "$apiUrl/medicines?currentQrAccessCode=$data";
      final res = await _http.get(url);
      logger.d("Get medicine by access code response : $res");

      if (res.statusCode == 200) {
        return res.data;
      }
    } catch (e) {
      logger.e("Error while getting medicine by access code $e");
    }
  }

  dynamic getDosageForms() async {
    try {
      final url = "$apiUrl/medicines/dosage/all";
      final res = await _http.get(url);
      logger.d("Get dosage forms response : $res");

      if (res.statusCode == 200) {
        return res.data;
      }
    } catch (e) {
      logger.e("Error while getting dosage forms $e");
    }
  }

  dynamic getDoses() async {
    try {
      final url = "$apiUrl/medicines/units/all";
      final res = await _http.get(url);
      logger.d("Get doses response : $res");

      if (res.statusCode == 200) {
        return res.data;
      }
    } catch (e) {
      logger.e("Error while getting doses $e");
    }
  }

  dynamic addMedicine(dynamic data) async {
    try {
      final url = "$apiUrl/medicines";
      final res = await _http.post(url, data: data);
      logger.d("Add Medicine Response : $res");

      if (res.statusCode == 201) {
        return res.data;
      }
    } catch (e) {
      logger.e("Error while adding medicine : $e");
    }
  }

  dynamic updateMedicine(dynamic data, int id) async {
    try {
      final url = "$apiUrl/medicines/$id";
      final res = await _http.patch(url, data: data);
      logger.d("Update Medicine Response : $res");

      if (res.statusCode == 201) {
        return res.data;
      }
    } catch (e) {
      logger.e("Error while updating medicine : $e");
    }
  }

  dynamic generateQrCodeDataUrl(String data) async {
    // final qrCode = QrCode(8, QrErrorCorrectLevel.H)..addData(data);

    // final qrImage = QrImage(qrCode);

    try {
      final qrPainter = QrPainter(
        data: data,
        version: QrVersions.auto,
        gapless: true,
      );

      final ui.Image qrImage = await qrPainter.toImage(400);

      final ByteData? byteData =
          await qrImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception('Failed to convert QR image to bytes');
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      final qrCodeDataUrl = "data:image/png;base64,${base64Encode(pngBytes)}";
      return qrCodeDataUrl;
    } catch (e) {
      logger.e("Error while generating QR code data url $e");
    }
  }
}
