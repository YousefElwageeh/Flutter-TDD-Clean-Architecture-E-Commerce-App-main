import 'package:eshop/core/api/dio_factory.dart';
import 'package:http/http.dart' as http;

import '../../domain/usecases/get_product_usecase.dart';
import '../models/product_response_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductResponseModel> getProducts(FilterProductParams params);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<ProductResponseModel> getProducts(params) async {
    final result = await DioFactory.getdata(
        url: '/api/ProductByCategory/${params.categories.first.id}');
    return ProductResponseModel.fromJson(result.data);
  }
}
