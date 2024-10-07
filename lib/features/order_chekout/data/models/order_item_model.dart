import 'package:eshop/features/product/data/models/product_response_model.dart';

import '../../domain/entities/order_item.dart';
import '../../../product/data/models/price_tag_model.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.id,
    required super.product,
    required super.priceTag,
    required super.price,
    required super.quantity,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
      id: json["_id"],
      product: Product.fromJson(json["product"]),
      priceTag: "priceTag",
      price: json["price"],
      quantity: json["quantity"]);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "product": (product).toJson(),
        "priceTag": (priceTag as PriceTagModel).toJson(),
        "price": price,
        "quantity": quantity,
      };

  Map<String, dynamic> toJsonBody() => {
        "_id": id,
        "product": product.id,
        "priceTag": priceTag,
        "price": price,
        "quantity": quantity,
      };

  factory OrderItemModel.fromEntity(OrderItem entity) => OrderItemModel(
        id: entity.id,
        product: Product(),
        priceTag: entity.priceTag,
        price: entity.price,
        quantity: entity.quantity,
      );
}
