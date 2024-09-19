import 'package:dartz/dartz.dart';
import 'package:eshop/data/models/adderss/add_address_request.dart';
import 'package:eshop/data/models/adderss/address_response_model.dart';

import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../../data/models/user/delivery_info_model.dart';
import '../entities/user/delivery_info.dart';

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
}
