import 'package:dartz/dartz.dart';
import 'package:eshop/data/models/adderss/add_address_request.dart';
import 'package:eshop/data/models/adderss/address_response_model.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../data/models/user/delivery_info_model.dart';
import '../../entities/user/delivery_info.dart';
import '../../repositories/delivery_info_repository.dart';

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
