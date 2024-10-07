import 'package:dartz/dartz.dart';
import 'package:dio/src/response.dart';
import 'package:eshop/core/usecases/usecase.dart';
import 'package:eshop/features/delivery/data/models/add_address_request.dart';
import 'package:eshop/features/delivery/data/models/address_response_model.dart';
import 'package:eshop/features/delivery/data/models/cities_model.dart';
import 'package:eshop/features/delivery/data/models/countries_model.dart';
import 'package:eshop/features/delivery/data/models/nearest_branches.dart';
import 'package:eshop/features/delivery/data/models/shipmet_price_model.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/delivery_info.dart';
import '../../domain/repositories/delivery_info_repository.dart';
import '../datasources/delivery_info_local_data_source.dart';
import '../../../auth/data/datasources/user_local_data_source.dart';
import '../datasources/delivery_info_remote_data_source.dart';
import '../models/delivery_info_model.dart';

class DeliveryInfoRepositoryImpl implements DeliveryInfoRepository {
  final DeliveryInfoRemoteDataSource remoteDataSource;
  final DeliveryInfoLocalDataSource localDataSource;
  final UserLocalDataSource userLocalDataSource;
  final NetworkInfo networkInfo;

  DeliveryInfoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.userLocalDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<AddressResponseModel>>>
      getRemoteDeliveryInfo() async {
    if (await networkInfo.isConnected) {
      if (await userLocalDataSource.isTokenAvailable()) {
        try {
          final String token = await userLocalDataSource.getToken();
          final result = await remoteDataSource.getDeliveryInfo();
          // await localDataSource.saveDeliveryInfo(result);
          return Right(result);
        } on Failure catch (failure) {
          return Left(failure);
        }
      } else {
        return Left(AuthenticationFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<DeliveryInfo>>> getCachedDeliveryInfo() async {
    try {
      final result = await localDataSource.getDeliveryInfo();
      return Right(result);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, AddressResponseModel>> addDeliveryInfo(
      AddressRequestModel addressRequestModel) async {
    if (await userLocalDataSource.isTokenAvailable()) {
      try {
        final String token = await userLocalDataSource.getToken();
        final AddressResponseModel deliveryInfo =
            await remoteDataSource.addDeliveryInfo(addressRequestModel);
        //      await localDataSource.updateDeliveryInfo(deliveryInfo);
        return Right(deliveryInfo);
      } on Failure catch (failure) {
        return Left(failure);
      }
    } else {
      return Left(AuthenticationFailure());
    }
  }

  @override
  Future<Either<Failure, AddressResponseModel>> editDeliveryInfo(
      AddressRequestModel addressRequestModel, String adderssID) async {
    if (await userLocalDataSource.isTokenAvailable()) {
      try {
        final String token = await userLocalDataSource.getToken();
        final AddressResponseModel deliveryInfo = await remoteDataSource
            .editDeliveryInfo(addressRequestModel, adderssID);
        //   await localDataSource.updateDeliveryInfo(deliveryInfo);
        return Right(deliveryInfo);
      } on Failure catch (failure) {
        return Left(failure);
      }
    } else {
      return Left(AuthenticationFailure());
    }
  }

  @override
  Future<Either<Failure, DeliveryInfo>> selectDeliveryInfo(
      DeliveryInfo params) async {
    try {
      await localDataSource
          .updateSelectedDeliveryInfo(DeliveryInfoModel.fromEntity(params));
      return Right(params);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, DeliveryInfo>> getSelectedDeliveryInfo() async {
    try {
      final result = await localDataSource.getSelectedDeliveryInfo();
      return Right(result);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, NoParams>> clearLocalDeliveryInfo() async {
    try {
      await localDataSource.clearDeliveryInfo();
      return Right(NoParams());
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, CitiesModel>> getCities(String countryId) async {
    try {
      var result = await remoteDataSource.getCities(countryId);
      return Right(result);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, CountriesModel>> getCountrys() async {
    try {
      var result = await remoteDataSource.getCountrys();
      return Right(result);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, List<NearestBrancheModel>>> getNearictsBranches(
      double lat, double long) async {
    try {
      var result = await remoteDataSource.getNearictsBranches(lat, long);
      return Right(result);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, ShipmentPriceModel>> getDeliveryPriceDependsOnZone(
      String cityId) async {
    try {
      var result = await remoteDataSource.getDeliveryPriceDependsOnZone(cityId);
      return Right(result);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, Response>> deleteDeliveryAdderss(
      String deliveryID) async {
    try {
      var result = await remoteDataSource.deleteDeliveryAdderss(deliveryID);
      return Right(result);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }
}
