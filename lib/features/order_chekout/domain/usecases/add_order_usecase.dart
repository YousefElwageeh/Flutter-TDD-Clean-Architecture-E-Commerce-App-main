import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:eshop/features/order_chekout/domain/entities/order_request_model.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/order_repository.dart';

class AddOrderUseCase implements UseCase<Response, OrderRequestModel> {
  final OrderRepository repository;
  AddOrderUseCase(this.repository);

  @override
  Future<Either<Failure, Response>> call(OrderRequestModel params) async {
    return await repository.addOrder(params);
  }
}
