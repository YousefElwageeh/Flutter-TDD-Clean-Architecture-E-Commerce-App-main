import 'package:dio/dio.dart';
import 'package:eshop/core/api/constant&endPoints.dart';
import 'package:eshop/core/api/dio_factory.dart';
import 'package:eshop/features/order/data/models/order_model.dart';
import 'package:eshop/features/order_chekout/domain/entities/order_request_model.dart';
import 'package:http/http.dart' as http;

abstract class OrderRemoteDataSource {
  Future<Response> addOrder(
    OrderRequestModel params,
  );
  Future<OrdersModel> getOrders();
  Future<Response> getPaymentWebView({required String orderID});

  Future<int> getVatprectage();
}

class OrderRemoteDataSourceSourceImpl implements OrderRemoteDataSource {
  final http.Client client;
  OrderRemoteDataSourceSourceImpl({required this.client});

  @override
  Future<Response> addOrder(
    params,
  ) async {
    final response = await DioFactory.postdata(
      url: EndPoints.creatOrder,
      data: params.toJson(),
    );
    return response;
  }

  @override
  Future<OrdersModel> getOrders() async {
    final response = await DioFactory.getdata(
      url: EndPoints.getOrders,
    );
    return OrdersModel.fromJson(response.data);
  }

  @override
  Future<int> getVatprectage() async {
    final response = await DioFactory.getdata(
      url: EndPoints.getVat,
    );
    return response.data["vat_percentage"];
  }

  @override
  Future<Response> getPaymentWebView({required String orderID}) async {
    final response = await DioFactory.getdata(
      url: "${EndPoints.getOrders}/$orderID/ccavenue-payment",
    );
    return response;
  }
}
