import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eshop/core/api/constant&endPoints.dart';
import 'package:eshop/core/api/dio_factory.dart';
import 'package:eshop/features/product/data/models/product_response_model.dart';
import 'package:eshop/features/wishlist/data/models/wish_list_model.dart';

class WishlistDataSource {
  Future<WishListModel> getWishlist() async {
    final result = await DioFactory.getdata(url: EndPoints.wishlists);
    return WishListModel.fromJson(result.data);
  }

  Future<Response> addWishlist(String producrID) async {
    final result =
        await DioFactory.getdata(url: "${EndPoints.addwishlists}$producrID");
    return result;
  }

  Future<Response> removeWishlist(String producrID) async {
    final result =
        await DioFactory.getdata(url: "${EndPoints.removewishlists}$producrID");
    return result;
  }
}
