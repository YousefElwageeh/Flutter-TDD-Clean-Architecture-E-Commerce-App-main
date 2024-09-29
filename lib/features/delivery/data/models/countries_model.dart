import 'dart:convert';

class CountriesModel {
  List<Country>? country;

  CountriesModel({
    this.country,
  });

  factory CountriesModel.fromRawJson(String str) =>
      CountriesModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CountriesModel.fromJson(Map<String, dynamic> json) => CountriesModel(
        country: json["Country"] == null
            ? []
            : List<Country>.from(
                json["Country"]!.map((x) => Country.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Country": country == null
            ? []
            : List<dynamic>.from(country!.map((x) => x.toJson())),
      };
}

class Country {
  int? id;
  String? countryName;
  dynamic nameAr;
  String? countryCode;
  dynamic nicename;
  dynamic iso3;
  dynamic numcode;
  int? phonecode;
  dynamic photo;
  int? status;
  int? isDefault;
  int? phoneNumbers;
  int? zoneId;

  Country({
    this.id,
    this.countryName,
    this.nameAr,
    this.countryCode,
    this.nicename,
    this.iso3,
    this.numcode,
    this.phonecode,
    this.photo,
    this.status,
    this.isDefault,
    this.phoneNumbers,
    this.zoneId,
  });

  factory Country.fromRawJson(String str) => Country.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        countryName: json["country_name"],
        nameAr: json["name_ar"],
        countryCode: json["country_code"],
        nicename: json["nicename"],
        iso3: json["iso3"],
        numcode: json["numcode"],
        phonecode: json["phonecode"],
        photo: json["photo"],
        status: json["status"],
        isDefault: json["is_default"],
        phoneNumbers: json["phone_numbers"],
        zoneId: json["zone_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country_name": countryName,
        "name_ar": nameAr,
        "country_code": countryCode,
        "nicename": nicename,
        "iso3": iso3,
        "numcode": numcode,
        "phonecode": phonecode,
        "photo": photo,
        "status": status,
        "is_default": isDefault,
        "phone_numbers": phoneNumbers,
        "zone_id": zoneId,
      };
}
