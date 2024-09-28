import 'dart:convert';

class OrderResponseModel {
  String? status;
  String? message;
  int? id;

  OrderResponseModel({
    this.status,
    this.message,
    this.id,
  });

  factory OrderResponseModel.fromRawJson(String str) =>
      OrderResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) =>
      OrderResponseModel(
        status: json["status"],
        message: json["message"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "id": id,
      };
}
