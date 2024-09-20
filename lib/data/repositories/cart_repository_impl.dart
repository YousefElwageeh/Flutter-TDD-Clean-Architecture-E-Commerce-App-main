import 'package:dartz/dartz.dart';
import 'package:eshop/data/models/cart/add_to_card_request.dart';

import '../../../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/cart/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../data_sources/local/cart_local_data_source.dart';
import '../data_sources/local/user_local_data_source.dart';
import '../data_sources/remote/cart_remote_data_source.dart';
import '../models/cart/cart_item_model.dart';

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
  Future<Either<Failure, CartModel>> addToCart(AddToCardRequest params) async {
    try {
      // await localDataSource.saveCartItem(CartItemModel.fromParent(params));
      //final String token = await userLocalDataSource.getToken();
      final remoteProduct = await remoteDataSource.addToCart(
        params,
        //  token,
      );
      return Right(remoteProduct);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
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
}
