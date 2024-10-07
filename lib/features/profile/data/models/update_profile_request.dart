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
  Future<FormData> toMap() async {
    final formData = FormData(); // Initialize an empty FormData

    if (name != null) {
      formData.fields
          .add(MapEntry('name', name!)); // Add 'name' field if not null
    }
    if (email != null) {
      formData.fields
          .add(MapEntry('email', email!)); // Add 'email' field if not null
    }
    if (phone != null) {
      formData.fields
          .add(MapEntry('phone', phone!)); // Add 'phone' field if not null
    }
    if (photo != null) {
      formData.files.add(MapEntry('photo',
          await MultipartFile.fromFile(photo!) // Add 'photo' file if not null
          ));
    }

    return formData; // Return the FormData object
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
