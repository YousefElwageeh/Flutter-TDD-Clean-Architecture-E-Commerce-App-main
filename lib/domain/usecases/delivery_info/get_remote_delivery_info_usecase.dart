import 'package:dartz/dartz.dart';
import 'package:eshop/data/models/adderss/address_response_model.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/user/delivery_info.dart';
import '../../repositories/delivery_info_repository.dart';

class GetRemoteDeliveryInfoUseCase
    implements UseCase<List<AddressResponseModel>, NoParams> {
  final DeliveryInfoRepository repository;
  GetRemoteDeliveryInfoUseCase(this.repository);

  @override
  Future<Either<Failure, List<AddressResponseModel>>> call(
      NoParams params) async {
    return await repository.getRemoteDeliveryInfo();
  }
}
