import 'package:dio/dio.dart';
import 'package:eshop/core/api/constant&endPoints.dart';
import 'package:eshop/core/api/dio_factory.dart';
import 'package:eshop/features/cart/data/models/add_to_card_request.dart';
import 'package:eshop/features/product/data/models/product_response_model.dart';
import 'package:http/http.dart' as http;

import '../models/cart_item_model.dart';

abstract class CartRemoteDataSource {
  Future<Response> addToCart(AddToCardRequest addToCardRequest);
  Future<CartModel> syncCart(String token);
  Future<Response> delteItemFromCart(int itemId);

  Future<List<Product>> searchProduct(String term);
}

class CartRemoteDataSourceSourceImpl implements CartRemoteDataSource {
  final http.Client client;
  CartRemoteDataSourceSourceImpl({required this.client});

  @override
  Future<Response> addToCart(AddToCardRequest addToCardRequest) async {
    var result = await DioFactory.postdata(
        url: EndPoints.addTocard, data: addToCardRequest.toJson());
    return result;
  }

  @override
  Future<CartModel> syncCart(String) async {
    var result = await DioFactory.getdata(
      url: EndPoints.getCard,
    );

    return CartModel.fromJson(result.data);
  }

  @override
  Future<Response> delteItemFromCart(int itemId) async {
    var result = await DioFactory.postdata(
        url: EndPoints.deleteFromCart, data: {"id": itemId});

    return result;
  }

  @override
  Future<List<Product>> searchProduct(String term) async {
    var result =
        await DioFactory.getdata(url: EndPoints.search, data: {"name": term});

    return List<Product>.from(
        result.data["products"].map((x) => Product.fromJson(x)));
  }
}
