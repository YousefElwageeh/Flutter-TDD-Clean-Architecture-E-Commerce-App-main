import 'package:dartz/dartz.dart';
import 'package:eshop/features/delivery/data/models/add_address_request.dart';
import 'package:eshop/features/delivery/data/models/address_response_model.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/delivery_info_repository.dart';

class AddDeliveryInfoUseCase
    implements UseCase<AddressResponseModel, AddressRequestModel> {
  final DeliveryInfoRepository repository;
  AddDeliveryInfoUseCase(this.repository);

  @override
  Future<Either<Failure, AddressResponseModel>> call(
      AddressRequestModel params) async {
    return await repository.addDeliveryInfo(params);
  }
}
