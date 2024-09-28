import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:eshop/data/models/cart/add_to_card_request.dart';
import 'package:eshop/data/models/cart/cart_item_model.dart';

import '../../../../core/error/failures.dart';
import '../entities/cart/cart_item.dart';

abstract class CartRepository {
  Future<Either<Failure, CartModel>> getCachedCart();
  Future<Either<Failure, CartModel>> syncCart();
  Future<Either<Failure, Response>> addToCart(AddToCardRequest params);
  Future<Either<Failure, bool>> deleteFormCart();
  Future<Either<Failure, bool>> clearCart();
  Future<Either<Failure, Response>> delteItemFromCart(int itemId);
}
