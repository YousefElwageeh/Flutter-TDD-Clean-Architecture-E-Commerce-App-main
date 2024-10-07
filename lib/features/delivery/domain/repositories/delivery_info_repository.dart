import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:eshop/features/delivery/data/models/add_address_request.dart';
import 'package:eshop/features/delivery/data/models/address_response_model.dart';
import 'package:eshop/features/delivery/data/models/cities_model.dart';
import 'package:eshop/features/delivery/data/models/countries_model.dart';
import 'package:eshop/features/delivery/data/models/nearest_branches.dart';
import 'package:eshop/features/delivery/data/models/shipmet_price_model.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/delivery_info_model.dart';
import '../entities/delivery_info.dart';

abstract class DeliveryInfoRepository {
  Future<Either<Failure, List<AddressResponseModel>>> getRemoteDeliveryInfo();
  Future<Either<Failure, List<DeliveryInfo>>> getCachedDeliveryInfo();
  Future<Either<Failure, AddressResponseModel>> addDeliveryInfo(
      AddressRequestModel addressRequestModel);
  Future<Either<Failure, AddressResponseModel>> editDeliveryInfo(
      AddressRequestModel addressRequestModel, String adderssID);
  Future<Either<Failure, DeliveryInfo>> selectDeliveryInfo(DeliveryInfo param);
  Future<Either<Failure, DeliveryInfo>> getSelectedDeliveryInfo();
  Future<Either<Failure, NoParams>> clearLocalDeliveryInfo();
  Future<Either<Failure, CitiesModel>> getCities(String countryId);
  Future<Either<Failure, CountriesModel>> getCountrys();
  Future<Either<Failure, List<NearestBrancheModel>>> getNearictsBranches(
      double lat, double long);
  Future<Either<Failure, Response>> deleteDeliveryAdderss(String deliveryID);

  Future<Either<Failure, ShipmentPriceModel>> getDeliveryPriceDependsOnZone(
      String cityId);
}
