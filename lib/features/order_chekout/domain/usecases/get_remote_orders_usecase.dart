import 'package:dartz/dartz.dart';
import 'package:eshop/features/order/data/models/order_model.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_details.dart';
import '../repositories/order_repository.dart';

class GetRemoteOrdersUseCase implements UseCase<OrdersModel, NoParams> {
  final OrderRepository repository;
  GetRemoteOrdersUseCase(this.repository);

  @override
  Future<Either<Failure, OrdersModel>> call(NoParams params) async {
    return await repository.getRemoteOrders();
  }
}
