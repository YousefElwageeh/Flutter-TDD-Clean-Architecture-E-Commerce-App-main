import 'package:equatable/equatable.dart';
import 'package:eshop/data/models/product/product_response_model.dart';

import '../product/price_tag.dart';

class CartItem extends Equatable {
  final String? id;
  final Product product;
  final String priceTag;

  const CartItem({this.id, required this.product, required this.priceTag});

  @override
  List<Object?> get props => [id];
}
