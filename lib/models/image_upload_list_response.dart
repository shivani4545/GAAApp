// To parse this JSON data, do
//
//     final imageUploadListResponse = imageUploadListResponseFromJson(jsonString);

import 'dart:convert';

ImageUploadListResponse imageUploadListResponseFromJson(String str) => ImageUploadListResponse.fromJson(json.decode(str));

String imageUploadListResponseToJson(ImageUploadListResponse data) => json.encode(data.toJson());

class ImageUploadListResponse {
  bool? success;
  String? message;

  ImageUploadListResponse({
    this.success,
    this.message,
  });

  factory ImageUploadListResponse.fromJson(Map<String, dynamic> json) => ImageUploadListResponse(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}