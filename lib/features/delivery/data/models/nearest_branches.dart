import 'dart:convert';

import 'package:flutter_localization/flutter_localization.dart';

class NearestBrancheModel {
  int? id;
  String? name;
  String? nameAr;
  String? latitude;
  String? longitude;
  DateTime? createdAt;
  DateTime? updatedAt;
  double? distance;
  bool isSelceted = false;
  NearestBrancheModel({
    this.id,
    this.name,
    this.nameAr,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.distance,
    this.isSelceted = false,
  }) {
    final FlutterLocalization localization = FlutterLocalization.instance;
    if (localization.currentLocale.localeIdentifier == 'ar') {
      name = nameAr;
    }
  }

  factory NearestBrancheModel.fromRawJson(String str) =>
      NearestBrancheModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NearestBrancheModel.fromJson(Map<String, dynamic> json) =>
      NearestBrancheModel(
        id: json["id"],
        name: json["name"],
        nameAr: json["name_ar"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        distance: json["distance"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "name_ar": nameAr,
        "latitude": latitude,
        "longitude": longitude,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "distance": distance,
      };
}
