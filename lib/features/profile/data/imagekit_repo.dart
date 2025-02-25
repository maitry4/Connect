import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:connect/config/api_keys.dart';
import 'package:dio/dio.dart';

class ImageKitRepo {
  final Dio _dio = Dio();

  final String _uploadUrl = "https://upload.imagekit.io/api/v1/files/upload";
  final String _privateApiKey = image_kit_private_api;

  Future<Map<String, String>?> uploadImage(dynamic file, String uid) async {
    try {
      MultipartFile multipartFile;
      if (file is File) {
        multipartFile = await MultipartFile.fromFile(file.path);
      } else if (file is Uint8List) {
        multipartFile = MultipartFile.fromBytes(file, filename: "profile_$uid.webp");
      } else {
        return null;
      }

      FormData formData = FormData.fromMap({
        "file": multipartFile,
        "fileName": "profile_$uid.webp",
        "folder": "/user_profiles",
      });

      Response response = await _dio.post(
        _uploadUrl,
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Basic ${base64Encode(utf8.encode("$_privateApiKey:"))}"
          },
        ),
      );

      if (response.statusCode == 200) {
        return {
          "url": response.data["url"],
          "fileId": response.data["fileId"],
        };
      }
    } catch (e) {
      print("ImageKit Upload Error: $e");
    }
    return null;
  }
  Future<void> deleteImage(String fileId) async {
    try {
      Response response = await _dio.delete(
        "https://api.imagekit.io/v1/files/$fileId",
        options: Options(
          headers: {
            "Authorization": "Basic ${base64Encode(utf8.encode("$_privateApiKey:"))}"
          },
        ),
      );

      if (response.statusCode == 204) {
        print("Image deleted successfully.");
      } else {
        throw Exception("Failed to delete image.");
      }
    } catch (e) {
      print("ImageKit Delete Error: $e");
    }
  }

  Future<String?> getFileId(String imageUrl) async {
    try {
      Response response = await _dio.get(
        "https://api.imagekit.io/v1/files/",
        queryParameters: {"searchQuery": imageUrl},
        options: Options(
          headers: {
            "Authorization": "Basic ${base64Encode(utf8.encode("$_privateApiKey:"))}"
          },
        ),
      );

      if (response.statusCode == 200) {
        List files = response.data;
        for (var file in files) {
          if (file["url"] == imageUrl) {
            return file["fileId"];
          }
        }
      }
    } catch (e) {
      print("Error fetching file ID: $e");
    }
    return null;
  }
}
