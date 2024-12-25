import 'dart:core';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:eshop/core/error/failures.dart';
import 'package:eshop/features/product/data/models/product_response_model.dart';
import 'package:eshop/features/wishlist/data/datasources/wishlist_data_source.dart';
import 'package:eshop/features/wishlist/data/models/wish_list_model.dart';

class WishlistRepo {
  WishlistDataSource wishlistDataSource;
  WishlistRepo({
    required this.wishlistDataSource,
  });

  Future<Either<Failure, WishListModel>> getWishlist() async {
    try {
      return Right(await wishlistDataSource.getWishlist());
    } on DioException catch (e) {
      return Left(Failure(errorMessage: e));
    }
  }

  Future<Either<Failure, Response>> addWishlist(String producrID) async {
    try {
      return Right(await wishlistDataSource.addWishlist(producrID));
    } on DioException catch (e) {
      return Left(Failure(errorMessage: e));
    }
  }

  Future<Either<Failure, Response>> removeWishlist(String producrID) async {
    try {
      return Right(await wishlistDataSource.removeWishlist(producrID));
    } on DioException catch (e) {
      return Left(Failure(errorMessage: e));
    }
  }
}
