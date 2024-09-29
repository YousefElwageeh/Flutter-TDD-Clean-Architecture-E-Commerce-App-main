import 'dart:convert';

import 'package:dio/dio.dart';

class UpdateProfileRequest {
  String? name;
  String? email;
  String? phone;
  String? photo;
  UpdateProfileRequest({
    this.name,
    this.email,
    this.phone,
    this.photo,
  });

  Future<Map<String, dynamic>> toMap() async {
    final result = <String, dynamic>{};

    if (name != null) {
      result.addAll({'name': name});
    }
    if (email != null) {
      result.addAll({'email': email});
    }

    if (phone != null) {
      result.addAll({'phone': phone});
    }
    if (photo != null) {
      result.addAll({'photo': await MultipartFile.fromFile(photo!)});
    }

    return result;
  }

  factory UpdateProfileRequest.fromMap(Map<String, dynamic> map) {
    return UpdateProfileRequest(
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      photo: map['photo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateProfileRequest.fromJson(String source) =>
      UpdateProfileRequest.fromMap(json.decode(source));
}
