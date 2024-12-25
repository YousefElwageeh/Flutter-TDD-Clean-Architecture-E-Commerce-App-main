import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:eshop/features/cart/data/models/add_to_card_request.dart';
import 'package:eshop/features/cart/data/models/cart_item_model.dart';
import 'package:eshop/features/product/data/models/product_response_model.dart';

import '../../../../../../core/error/failures.dart';

abstract class CartRepository {
  Future<Either<Failure, CartModel>> getCachedCart();
  Future<Either<Failure, CartModel>> syncCart();
  Future<Either<Failure, Response>> addToCart(AddToCardRequest params);
  Future<Either<Failure, bool>> deleteFormCart();
  Future<Either<Failure, bool>> clearCart();
  Future<Either<Failure, Response>> delteItemFromCart(int itemId);
  Future<Either<Failure, List<Product>>> searchProduct(String term);
}
