import 'package:dartz/dartz.dart';
import 'package:eshop/data/models/cart/add_to_card_request.dart';
import 'package:eshop/data/models/cart/cart_item_model.dart';

import '../../../../core/error/failures.dart';
import '../entities/cart/cart_item.dart';

abstract class CartRepository {
  Future<Either<Failure, CartModel>> getCachedCart();
  Future<Either<Failure, CartModel>> syncCart();
  Future<Either<Failure, CartModel>> addToCart(AddToCardRequest params);
  Future<Either<Failure, bool>> deleteFormCart();
  Future<Either<Failure, bool>> clearCart();
}
