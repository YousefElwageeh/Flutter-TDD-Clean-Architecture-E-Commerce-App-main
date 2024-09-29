import 'package:eshop/core/error/failures.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<CartModel> getCart();
  Future<void> saveCart(CartModel cart);
  Future<void> saveCartItem(CartModel cartItem);
  Future<bool> clearCart();
}

const cachedCart = 'CACHED_CART';

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;
  CartLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> clearCart() {
    // TODO: implement clearCart
    throw UnimplementedError();
  }

  @override
  Future<CartModel> getCart() {
    // TODO: implement getCart
    throw UnimplementedError();
  }

  @override
  Future<void> saveCart(CartModel cart) {
    // TODO: implement saveCart
    throw UnimplementedError();
  }

  @override
  Future<void> saveCartItem(CartModel cartItem) {
    // TODO: implement saveCartItem
    throw UnimplementedError();
  }

  // @override
  // Future<void> saveCart(CartModel cart) {
  //   return sharedPreferences.setString(
  //     cachedCart,
  //     cartItemModelToJson(cart),
  //   );
  // }

  // @override
  // Future<void> saveCartItem(CartModel cartItem) {
  //   final jsonString = sharedPreferences.getString(cachedCart);
  //   final CartModel cart;
  //   if (jsonString != null) {
  //     cart = CartModel.fromJson(jsonString);
  //   }
  //   if (!cart.any((element) =>
  //       element.product.id == cartItem.product.id &&
  //       element.priceTag == cartItem.priceTag)) {
  //     cart.add(cartItem);
  //   }
  //   return sharedPreferences.setString(
  //     cachedCart,
  //     cartItemModelToJson(cart),
  //   );
  // }

  // @override
  // Future<List<CartItemModel>> getCart() {
  //   final jsonString = sharedPreferences.getString(cachedCart);
  //   if (jsonString != null) {
  //     return Future.value(cartItemModelListFromLocalJson(jsonString));
  //   } else {
  //     throw CacheFailure();
  //   }
  // }

  // @override
  // Future<bool> clearCart() async {
  //   return sharedPreferences.remove(cachedCart);
  // }
}
