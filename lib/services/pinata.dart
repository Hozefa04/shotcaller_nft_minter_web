import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../utils/app_strings.dart';

class PinataClient {
  late Dio dio;

  PinataClient() {
    dio = Dio();
  }

  Future<void> setHeaders() async {
    await dotenv.load(fileName: '.env');
    dio.options.headers['Authorization'] =
        "Bearer " + dotenv.env['PINATA_JWT']!;
  }

  Future<String> uploadFileToPinata(
      Uint8List fileBytes, String fileName) async {
    try {
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
        ),
      });
      var result = await dio.post(AppStrings.pinataEndPoint, data: formData);
      debugPrint(result.data.toString());
      String url = "ipfs://ipfs/" + result.data['IpfsHash'];
      return url;
    } catch (e) {
      rethrow;
    }
  }
}
