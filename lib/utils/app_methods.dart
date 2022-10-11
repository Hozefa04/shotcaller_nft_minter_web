// ignore: avoid_web_libraries_in_flutter, library_prefixes
import 'dart:html' as webFile;
import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/pinata.dart';

class AppMethods {
  static Future<void> openUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $uri';
    }
  }

  static Future<PlatformFile?> pickImage() async {
    // final ImagePicker _picker = ImagePicker();
    final result = await FilePicker.platform.pickFiles();
    // return await _picker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      return result.files.single;
    } else {
      return null;
    }
  }

  static Future<String> uploadImage(PlatformFile image) async {
    try {
      final imageBytes = image.bytes;
      PinataClient pinataClient = PinataClient();
      await pinataClient.setHeaders();
      String url =
          await pinataClient.uploadFileToPinata(imageBytes!, image.name);
      return url;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<void> createMetadata({
    required PlatformFile image,
    required String imageUrl,
    required String nftName,
    required String nftDescription,
    String type = "",
  }) async {
    try {
      Random random = Random();
      final fileName = image.name + random.nextInt(1919).toString() + ".json";
      String validDescription = "";
      if (nftDescription.contains("\n")) {
        validDescription = nftDescription.replaceAll("\n", "\\n");
      } else {
        validDescription = nftDescription;
      }
      String metaString =
          "{\"name\":\"$nftName\",\"description\":\"$validDescription\",\"image\":\"$imageUrl\",\"external_url\":\"\",\"attributes\":[{\"trait_type\":\"Rarity\",\"value\":\"$type\"}]}";

      var blob = webFile.Blob([metaString], 'text/plain', 'native');

      // ignore: unused_local_variable
      var anchorElement = webFile.AnchorElement(
        href: webFile.Url.createObjectUrlFromBlob(blob).toString(),
      )
        ..setAttribute("download", fileName)
        ..click();
    } catch (e) {
      debugPrint("Create metadata error " + e.toString());
      rethrow;
    }
  }

  static Future<String> uploadMetadata(
      {required Uint8List fileBytes, required String name}) async {
    try {
      PinataClient pinataClient = PinataClient();
      await pinataClient.setHeaders();
      return await pinataClient.uploadFileToPinata(fileBytes, name);
    } catch (e) {
      debugPrint("Upload metadata error " + e.toString());
      rethrow;
    }
  }
}
