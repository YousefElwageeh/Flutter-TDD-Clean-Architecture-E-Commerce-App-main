import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:eshop/features/order/data/models/order_model.dart';
import 'package:eshop/features/order_chekout/domain/entities/order_request_model.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_details.dart';

abstract class OrderRepository {
  Future<Either<Failure, Response>> addOrder(OrderRequestModel params);
  Future<Either<Failure, OrdersModel>> getRemoteOrders();
  Future<Either<Failure, List<OrderDetails>>> getCachedOrders();
  Future<Either<Failure, NoParams>> clearLocalOrders();
  Future<Either<Failure, int>> getVatprectage();
  Future<Either<Failure, Response>> getPaymentWebView(
      {required String orderID});
}
