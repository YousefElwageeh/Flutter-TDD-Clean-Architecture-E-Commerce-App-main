import 'dart:convert';

import 'package:eshop/features/delivery/data/models/address_response_model.dart';

import '../../domain/entities/order_details.dart';
import '../../../delivery/data/models/delivery_info_model.dart';
import 'order_item_model.dart';

List<OrderDetailsModel> orderDetailsModelListFromJson(String str) =>
    List<OrderDetailsModel>.from(
        json.decode(str)['data'].map((x) => OrderDetailsModel.fromJson(x)));

List<OrderDetailsModel> orderDetailsModelListFromLocalJson(String str) =>
    List<OrderDetailsModel>.from(
        json.decode(str).map((x) => OrderDetailsModel.fromJson(x)));

OrderDetailsModel orderDetailsModelFromJson(String str) =>
    OrderDetailsModel.fromJson(json.decode(str)['data']);

String orderModelListToJsonBody(List<OrderDetailsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJsonBody())));

String orderModelListToJson(List<OrderDetailsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

String orderDetailsModelToJson(OrderDetailsModel data) =>
    json.encode(data.toJsonBody());

class OrderDetailsModel extends OrderDetails {
  const OrderDetailsModel({
    required super.id,
    required List<OrderItemModel> super.orderItems,
    required super.deliveryInfo,
    required super.discount,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailsModel(
        id: json["_id"],
        orderItems: List<OrderItemModel>.from(
            json["orderItems"].map((x) => OrderItemModel.fromJson(x))),
        deliveryInfo: AddressResponseModel.fromJson(json["deliveryInfo"]),
        discount: json["discount"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "orderItems": List<dynamic>.from(
            (orderItems as List<OrderItemModel>).map((x) => x.toJson())),
        "deliveryInfo": (deliveryInfo as DeliveryInfoModel).toJson(),
        "discount": discount,
      };

  Map<String, dynamic> toJsonBody() => {
        "_id": id,
        "orderItems": List<dynamic>.from(
            (orderItems as List<OrderItemModel>).map((x) => x.toJsonBody())),
        "deliveryInfo": deliveryInfo.id,
        "discount": discount,
      };

  // factory OrderDetailsModel.fromEntity(OrderRequestModel entity) =>
  //     OrderDetailsModel(
  //         id: entity.id,
  //         orderItems: entity.orderItems
  //             .map((orderItem) => OrderItemModel.fromEntity(orderItem))
  //             .toList(),
  //         deliveryInfo: AddressResponseModel.fromEntity(entity.deliveryInfo),
  //         discount: entity.discount);
}
