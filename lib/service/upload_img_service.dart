import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:gaa_adv/service/shared_pref_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ImageUploadListResponse.dart';
import '../utils/apis.dart'; // Adjust path if needed


// Custom Exceptions
class AuthenticationException implements Exception {
  final String message;
  AuthenticationException(this.message);
  @override
  String toString() => message;
}

class ImageUploadApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic errorBody;

  ImageUploadApiException(this.message, {this.statusCode, this.errorBody});
  @override
  String toString() => "ImageUploadApiException: $message (Status: $statusCode)";
}

class ImageUploadService {
  Future<ImageUploadListResponse> uploadImage({
    required File imageFile,
    required String appointmentId,
    required String roomName,
  }) async {
    SharedPrefService sharedPrefService = SharedPrefService();

   // SharedPrefService sharedPrefService = await SharedPrefService.getInstance();
    var token = await sharedPrefService.getAccessToken();

    if (kDebugMode) {
      print("[ImageUploadService] Token: ${token ?? 'NULL (THIS IS THE PROBLEM IF TOKEN NOT FOUND)'}");
      print("[ImageUploadService] Ensure token is saved correctly via: await prefs.setString('token', yourTokenValue);");
    }

    if (token == null) {
      throw AuthenticationException('Authentication token not found. Please log in again.');
    }

    try {
      // ENSURE THIS URL IS CORRECT: Apis.uploadImage
      // From your Postman: "https://gaa.novuslogic.in/api/upload_image"
      final uri = Uri.parse(Apis.uploadImage);
      var request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // Field names 'appointment_id', 'room_name', 'image' must match backend
      request.fields['appointment_id'] = appointmentId;
      request.fields['room_name'] = roomName;

      String fileName = path.basename(imageFile.path);
      String extension = path.extension(fileName).toLowerCase();
      String mimeType = 'image/jpeg'; // Default
      if (extension == '.png') mimeType = 'image/png';
      if (extension == '.gif') mimeType = 'image/gif';
      // Add more types if needed

      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // Field name for the file part, must match backend
          imageFile.path,
          filename: fileName, // This is the original filename sent to backend
          contentType: MediaType.parse(mimeType),
        ),
      );

      if (kDebugMode) {
        print('[ImageUploadService] Sending request to: $uri');
        print('[ImageUploadService] Headers: ${request.headers}');
        print('[ImageUploadService] Fields: ${request.fields}');
        request.files.forEach((file) {
          print('[ImageUploadService] File: name=${file.field}, filename=${file.filename}, length=${file.length}, contentType=${file.contentType}');
        });
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        print('[ImageUploadService] Response Status Code: ${response.statusCode}');
        print('[ImageUploadService] Response Body: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          ImageUploadListResponse successResponse = imageUploadListResponseFromJson(response.body);
          if (successResponse.success == true) {
            return successResponse;
          } else {
            throw ImageUploadApiException(
              successResponse.message ?? 'API indicated failure despite success status.',
              statusCode: response.statusCode,
              errorBody: response.body,
            );
          }
        } catch (e) {
          throw ImageUploadApiException(
            'Failed to parse successful server response: $e. Raw body: ${response.body}',
            statusCode: response.statusCode,
            errorBody: response.body,
          );
        }
      } else {
        // Handle HTTP error codes (e.g., 422, 500)
        String extractedErrorMessage = "Upload failed";
        dynamic parsedErrorBody = response.body;
        int responseStatusCode = response.statusCode;

        try {
          var errorJson = jsonDecode(response.body);
          parsedErrorBody = errorJson;

          if (errorJson is Map<String, dynamic>) {
            if (errorJson.containsKey('message') && errorJson['message'] is String) {
              extractedErrorMessage = errorJson['message'];
              if (errorJson.containsKey('errors') && errorJson['errors'] is Map) {
                Map<String, dynamic> validationErrors = errorJson['errors'];
                StringBuffer specificErrors = StringBuffer();
                validationErrors.forEach((key, value) {
                  if (value is List && value.isNotEmpty) {
                    specificErrors.writeln("- $key: ${value.join(', ')}");
                  } else if (value is String) {
                    specificErrors.writeln("- $key: $value");
                  }
                });
                if (specificErrors.isNotEmpty) {
                  extractedErrorMessage += "\nDetails:\n${specificErrors.toString().trim()}";
                }
              }
            } else if (response.reasonPhrase != null && response.reasonPhrase!.isNotEmpty) {
              extractedErrorMessage = response.reasonPhrase!;
            } else {
              extractedErrorMessage = 'Unknown API error (Status: $responseStatusCode)';
            }
          } else if (response.reasonPhrase != null && response.reasonPhrase!.isNotEmpty) {
            extractedErrorMessage = response.reasonPhrase!;
          } else {
            extractedErrorMessage = 'Unknown API error (Status: $responseStatusCode). Response is not a JSON object.';
          }
        } catch (e) {
          if (kDebugMode) print("[ImageUploadService] Error decoding error JSON: $e. Raw body: ${response.body}");
          extractedErrorMessage = response.reasonPhrase ?? 'Upload failed (Status: $responseStatusCode). Non-JSON response.';
        }

        // THIS IS WHERE THE "Data too long for column 'name'" ERROR FROM BACKEND IS CAUGHT
        // The 'extractedErrorMessage' will contain the SQL error message if parsed correctly.
        // The 'statusCode' will be 500 (or 422 if it's a validation layer before DB).
        if (kDebugMode) {
          print('[ImageUploadService] API Error (Status: $responseStatusCode): $extractedErrorMessage');
          print('[ImageUploadService] Error Body Sent to Exception: ${parsedErrorBody is String ? parsedErrorBody : jsonEncode(parsedErrorBody)}');
        }
        throw ImageUploadApiException(
          extractedErrorMessage,
          statusCode: responseStatusCode,
          errorBody: parsedErrorBody,
        );
      }
    } on SocketException catch (e) {
      if (kDebugMode) print('[ImageUploadService] Network Error: $e');
      throw ImageUploadApiException('Network error: Please check your internet connection. ($e)');
    } catch (e) {
      if (kDebugMode) print('[ImageUploadService] Unexpected Error: $e');
      if (e is AuthenticationException || e is ImageUploadApiException) {
        rethrow;
      }
      throw ImageUploadApiException('An unexpected error occurred during upload: $e');
    }
  }
}