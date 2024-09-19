import 'dart:convert';

import 'package:eshop/domain/entities/user/delivery_info.dart';

class AddressResponseModel {
  String? country;
  String? city;
  String? address;
  String? phone;
  int? userId;
  int? id;

  AddressResponseModel({
    this.country,
    this.city,
    this.address,
    this.phone,
    this.userId,
    this.id,
  });

  factory AddressResponseModel.fromRawJson(String str) =>
      AddressResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddressResponseModel.fromJson(Map<String, dynamic> json) =>
      AddressResponseModel(
        country: json["country"],
        city: json["city"],
        address: json["address"],
        phone: json["phone"],
        userId: json["user_id"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "country": country,
        "city": city,
        "address": address,
        "phone": phone,
        "user_id": userId,
        "id": id,
      };
  factory AddressResponseModel.fromEntity(AddressResponseModel entity) =>
      AddressResponseModel(
        country: entity.country,
        city: entity.city,
        address: entity.address,
        phone: entity.phone,
        userId: entity.userId,
        id: entity.id,
      );
}
