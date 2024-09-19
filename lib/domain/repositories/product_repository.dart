import 'package:dartz/dartz.dart';
import 'package:eshop/data/models/product/product_response_model.dart';

import '../../../../core/error/failures.dart';
import '../entities/product/product_response.dart';
import '../usecases/product/get_product_usecase.dart';

abstract class ProductRepository {
  Future<Either<Failure, ProductResponseModel>> getProducts(
      FilterProductParams params);
}
