import 'package:dartz/dartz.dart';
import 'package:eshop/features/order_chekout/domain/entities/order_reponce_model.dart';
import 'package:eshop/features/order_chekout/domain/entities/order_request_model.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_details.dart';

abstract class OrderRepository {
  Future<Either<Failure, OrderResponseModel>> addOrder(
      OrderRequestModel params);
  Future<Either<Failure, List<OrderDetails>>> getRemoteOrders();
  Future<Either<Failure, List<OrderDetails>>> getCachedOrders();
  Future<Either<Failure, NoParams>> clearLocalOrders();
}
