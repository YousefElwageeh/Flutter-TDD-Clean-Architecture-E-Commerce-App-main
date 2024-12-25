import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:eshop/features/cart/data/models/add_to_card_request.dart';
import 'package:eshop/features/product/data/models/product_response_model.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';
import '../../../auth/data/datasources/user_local_data_source.dart';
import '../datasources/cart_remote_data_source.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  final CartLocalDataSource localDataSource;
  final UserLocalDataSource userLocalDataSource;
  final NetworkInfo networkInfo;

  CartRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.userLocalDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Response>> addToCart(AddToCardRequest params) async {
    try {
      // await localDataSource.saveCartItem(CartItemModel.fromParent(params));
      //final String token = await userLocalDataSource.getToken();
      final remoteProduct = await remoteDataSource.addToCart(
        params,
        //  token,
      );
      return Right(remoteProduct);
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteFormCart() {
    // TODO: implement deleteFormCart
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, CartModel>> getCachedCart() async {
    try {
      final localProducts = await localDataSource.getCart();
      return Right(localProducts);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, CartModel>> syncCart() async {
    if (await networkInfo.isConnected) {
      if (await userLocalDataSource.isTokenAvailable()) {
        try {
          final String token = await userLocalDataSource.getToken();
          final syncedResult = await remoteDataSource.syncCart(
            token,
          );
          //   await localDataSource.saveCart(syncedResult);
          return Right(syncedResult);
        } on Failure catch (failure) {
          return Left(failure);
        }
      } else {
        return Left(NetworkFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> clearCart() async {
    bool result = await localDataSource.clearCart();
    if (result) {
      return Right(result);
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Response>> delteItemFromCart(int itemId) async {
    try {
      final delteItemFromCart = await remoteDataSource.delteItemFromCart(
        itemId,
        //  token,
      );
      return Right(delteItemFromCart);
    } catch (e) {
      log(e.toString());
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProduct(String term) async {
    try {
      final delteItemFromCart = await remoteDataSource.searchProduct(
        term,
        //  token,
      );
      return Right(delteItemFromCart);
    } catch (e) {
      log(e.toString());
      return Left(ServerFailure());
    }
  }
}
