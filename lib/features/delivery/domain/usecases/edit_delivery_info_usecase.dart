import 'package:dartz/dartz.dart';
import 'package:eshop/features/delivery/data/models/add_address_request.dart';
import 'package:eshop/features/delivery/data/models/address_response_model.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/delivery_info_repository.dart';

class EditDeliveryInfoUseCase
    implements UseCase<AddressResponseModel, AddressRequestModel> {
  final DeliveryInfoRepository repository;
  EditDeliveryInfoUseCase(this.repository);

  @override
  Future<Either<Failure, AddressResponseModel>> call(
    AddressRequestModel params,
  ) async {
    return await repository.editDeliveryInfo(params, params.id!);
  }
}
