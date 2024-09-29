import 'package:dartz/dartz.dart';
import 'package:eshop/features/category/data/models/category_model.dart';
import 'package:eshop/features/home/model/slider_model.dart';

import '../../../../../../core/error/failures.dart';

abstract class CategoryRepository {
  Future<Either<Failure, CategoryModel>> getRemoteCategories();
  Future<Either<Failure, CategoryModel>> getCachedCategories();
  Future<Either<Failure, SliderModel>> getSliders();

  Future<Either<Failure, List<Category>>> filterCachedCategories(
      String keyword);
}
