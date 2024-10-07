import 'package:dartz/dartz.dart';
import 'package:eshop/features/product/data/models/product_response_model.dart';

import '../../../../../../core/error/failures.dart';
import '../usecases/get_product_usecase.dart';

abstract class ProductRepository {
  Future<Either<Failure, ProductResponseModel>> getProducts(
      FilterProductParams params);
}
