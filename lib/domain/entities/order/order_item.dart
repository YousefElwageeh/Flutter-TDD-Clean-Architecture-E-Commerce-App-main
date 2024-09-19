import 'package:equatable/equatable.dart';
import 'package:eshop/data/models/cart/cart_item_model.dart';
import 'package:eshop/data/models/product/product_response_model.dart';

import '../product/price_tag.dart';

class OrderItem extends Equatable {
  final String id;
  final Product product;
  final String priceTag;
  final num price;
  final num quantity;

  const OrderItem({
    required this.id,
    required this.product,
    required this.priceTag,
    required this.price,
    required this.quantity,
  });

  @override
  List<Object> get props => [
        id,
      ];
}
