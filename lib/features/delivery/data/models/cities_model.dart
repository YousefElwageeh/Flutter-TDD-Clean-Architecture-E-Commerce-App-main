import 'dart:convert';

class CitiesModel {
  List<City>? city;

  CitiesModel({
    this.city,
  });

  factory CitiesModel.fromRawJson(String str) =>
      CitiesModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CitiesModel.fromJson(Map<String, dynamic> json) => CitiesModel(
        city: json["City"] == null
            ? []
            : List<City>.from(json["City"]!.map((x) => City.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "City": city == null
            ? []
            : List<dynamic>.from(city!.map((x) => x.toJson())),
      };
}

class City {
  int? id;
  String? name;
  String? nameAr;
  int? countryId;
  int? zoneId;
  int? status;
  dynamic allowCash;

  City({
    this.id,
    this.name,
    this.nameAr,
    this.countryId,
    this.zoneId,
    this.status,
    this.allowCash,
  });

  factory City.fromRawJson(String str) => City.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
        nameAr: json["name_ar"],
        countryId: json["country_id"],
        zoneId: json["zone_id"],
        status: json["status"],
        allowCash: json["allow_cash"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "name_ar": nameAr,
        "country_id": countryId,
        "zone_id": zoneId,
        "status": status,
        "allow_cash": allowCash,
      };
}
