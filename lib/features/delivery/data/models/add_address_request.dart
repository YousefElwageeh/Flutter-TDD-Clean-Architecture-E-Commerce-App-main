import 'dart:convert';

class AddressRequestModel {
  String? country;
  String? city;
  String? address;
  String? phone;
  String? id;
  int? cityid;
  int? countryid;

  AddressRequestModel({
    this.country,
    this.city,
    this.address,
    this.id,
    this.phone,
    this.cityid,
    this.countryid,
  });

  factory AddressRequestModel.fromRawJson(String str) =>
      AddressRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddressRequestModel.fromJson(Map<String, dynamic> json) =>
      AddressRequestModel(
        country: json["country"],
        city: json["city"],
        address: json["address"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "country": country,
        "city": city,
        "address": address,
        "phone": phone,
        "id": id,
      };
}
