import 'package:eshop/core/api/constant&endPoints.dart';
import 'package:eshop/core/api/dio_factory.dart';
import 'package:eshop/core/error/failures.dart';
import 'package:eshop/domain/entities/order/order_reponce_model.dart';
import 'package:eshop/domain/entities/order/order_request_model.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../core/constant/strings.dart';
import '../../models/order/order_details_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderResponseModel> addOrder(
    OrderRequestModel params,
  );
  Future<List<OrderDetailsModel>> getOrders(String token);
}

class OrderRemoteDataSourceSourceImpl implements OrderRemoteDataSource {
  final http.Client client;
  OrderRemoteDataSourceSourceImpl({required this.client});

  @override
  Future<OrderResponseModel> addOrder(
    params,
  ) async {
    final response = await DioFactory.postdata(
        url: EndPoints.creatOrder, data: params.toJson());
    return OrderResponseModel.fromJson(response.data);
  }

  @override
  Future<List<OrderDetailsModel>> getOrders(String token) async {
    final response = await client.get(
      Uri.parse('$baseUrl/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return orderDetailsModelListFromJson(response.body);
    } else {
      throw ServerFailure();
    }
  }
}
