import 'dart:convert';

class ShipmentPriceModel {
  bool? success;
  Data? data;

  ShipmentPriceModel({
    this.success,
    this.data,
  });

  factory ShipmentPriceModel.fromRawJson(String str) =>
      ShipmentPriceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ShipmentPriceModel.fromJson(Map<String, dynamic> json) =>
      ShipmentPriceModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
      };
}

class Data {
  bool? isFreeShipping;
  ShipmentPrice? shipmentPrice;

  Data({
    this.isFreeShipping,
    this.shipmentPrice,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        isFreeShipping: json["is_free_shipping"],
        shipmentPrice: json["shipment_price"] == null
            ? null
            : ShipmentPrice.fromJson(json["shipment_price"]),
      );

  Map<String, dynamic> toJson() => {
        "is_free_shipping": isFreeShipping,
        "shipment_price": shipmentPrice?.toJson(),
      };
}

class ShipmentPrice {
  int? id;
  dynamic from;
  int? to;
  int? value;
  int? shipmentId;
  int? extra;
  Shipment? shipment;

  ShipmentPrice({
    this.id,
    this.from,
    this.to,
    this.value,
    this.shipmentId,
    this.extra,
    this.shipment,
  });

  factory ShipmentPrice.fromRawJson(String str) =>
      ShipmentPrice.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ShipmentPrice.fromJson(Map<String, dynamic> json) => ShipmentPrice(
        id: json["id"],
        from: json["from"],
        to: json["to"],
        value: json["value"],
        shipmentId: json["shipment_id"],
        extra: json["extra"],
        shipment: json["shipment"] == null
            ? null
            : Shipment.fromJson(json["shipment"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "from": from,
        "to": to,
        "value": value,
        "shipment_id": shipmentId,
        "extra": extra,
        "shipment": shipment?.toJson(),
      };
}

class Shipment {
  int? id;
  String? name;
  String? nameAr;
  String? desc;
  String? descAr;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? phone;
  int? shippingTax;
  String? photo;

  Shipment({
    this.id,
    this.name,
    this.nameAr,
    this.desc,
    this.descAr,
    this.createdAt,
    this.updatedAt,
    this.phone,
    this.shippingTax,
    this.photo,
  });

  factory Shipment.fromRawJson(String str) =>
      Shipment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Shipment.fromJson(Map<String, dynamic> json) => Shipment(
        id: json["id"],
        name: json["name"],
        nameAr: json["name_ar"],
        desc: json["desc"],
        descAr: json["desc_ar"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        phone: json["phone"],
        shippingTax: json["shipping_tax"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "name_ar": nameAr,
        "desc": desc,
        "desc_ar": descAr,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "phone": phone,
        "shipping_tax": shippingTax,
        "photo": photo,
      };
}
