import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:eshop/core/usecases/usecase.dart';
import 'package:eshop/features/order/data/models/order_model.dart';
import 'package:eshop/features/order_chekout/domain/entities/order_request_model.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/order_details.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_local_data_source.dart';
import '../../../auth/data/datasources/user_local_data_source.dart';
import '../datasources/order_remote_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final OrderLocalDataSource localDataSource;
  final UserLocalDataSource userLocalDataSource;
  final NetworkInfo networkInfo;

  OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.userLocalDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Response>> addOrder(OrderRequestModel params) async {
    try {
      final remoteProduct = await remoteDataSource.addOrder(params);
      return Right(remoteProduct);
    } catch (e) {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, OrdersModel>> getRemoteOrders() async {
    try {
      final remoteProduct = await remoteDataSource.getOrders();
      log(remoteProduct.toRawJson().toString());

      return Right(remoteProduct);
    } on Failure catch (failure) {
      log(failure.toString());
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, List<OrderDetails>>> getCachedOrders() async {
    try {
      final localOrders = await localDataSource.getOrders();
      return Right(localOrders);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, NoParams>> clearLocalOrders() async {
    try {
      await localDataSource.clearOrder();
      return Right(NoParams());
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, int>> getVatprectage() async {
    try {
      final vatprectage = await remoteDataSource.getVatprectage();
      return Right(vatprectage);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }
}
