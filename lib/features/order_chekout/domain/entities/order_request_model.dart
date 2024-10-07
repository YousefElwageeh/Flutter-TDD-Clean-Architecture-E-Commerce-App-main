import 'dart:convert';

class OrderRequestModel {
  List<int>? productsId;
  List<dynamic>? productsSize;
  List<int>? productsQu;
  List<dynamic>? productsColor;
  int? shipmentId;
  int? paymentMethod;
  int? addressId;
  int? isPickup;
  int? branchId;

  OrderRequestModel({
    this.productsId,
    this.productsSize,
    this.productsQu,
    this.productsColor,
    this.shipmentId,
    this.paymentMethod,
    this.addressId,
    this.isPickup,
    this.branchId,
  });

  factory OrderRequestModel.fromRawJson(String str) =>
      OrderRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderRequestModel.fromJson(Map<String, dynamic> json) =>
      OrderRequestModel(
        productsId: json["products_id"] == null
            ? []
            : List<int>.from(json["products_id"]!.map((x) => x)),
        productsSize: json["products_size"] == null
            ? []
            : List<dynamic>.from(json["products_size"]!.map((x) => x)),
        productsQu: json["products_qu"] == null
            ? []
            : List<int>.from(json["products_qu"]!.map((x) => x)),
        productsColor: json["products_color"] == null
            ? []
            : List<dynamic>.from(json["products_color"]!.map((x) => x)),
        shipmentId: json["shipment_id"],
        paymentMethod: json["payment_method"],
        addressId: json["address_id"],
        isPickup: json["is_pickup"],
        branchId: json["branch_id"],
      );

  Map<String, dynamic> toJson() => {
        "products_id": productsId == null
            ? []
            : List<dynamic>.from(productsId!.map((x) => x)),
        "products_size": productsSize == null
            ? []
            : List<dynamic>.from(productsSize!.map((x) => x)),
        "products_qu": productsQu == null
            ? []
            : List<dynamic>.from(productsQu!.map((x) => x)),
        "products_color": productsColor == null
            ? []
            : List<dynamic>.from(productsColor!.map((x) => x)),
        "shipment_id": shipmentId,
        "payment_method": paymentMethod,
        "address_id": addressId,
        "is_pickup": isPickup,
        "branch_id": branchId,
      };
}
