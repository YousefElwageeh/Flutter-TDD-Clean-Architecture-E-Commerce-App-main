import 'package:dartz/dartz.dart';
import 'package:eshop/data/models/category/category_model.dart';
import 'package:eshop/data/models/slider/slider_model.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/category_repository.dart';
import '../data_sources/local/category_local_data_source.dart';
import '../data_sources/remote/category_remote_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;
  final CategoryLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CategoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CategoryModel>> getRemoteCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.getCategories();
        localDataSource.saveCategories(remoteProducts);
        return Right(remoteProducts);
      } on Failure catch (failure) {
        return Left(failure);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, CategoryModel>> getCachedCategories() async {
    try {
      final localProducts = await localDataSource.getCategories();
      return Right(localProducts);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, List<Category>>> filterCachedCategories(params) async {
    try {
      final cachedCategories = await localDataSource.getCategories();
      final categories = cachedCategories;
      final filteredCategories = categories.category != null
          ? categories.category!
              .where((element) => element.name != null
                  ? element.name!.toLowerCase().contains(params.toLowerCase())
                  : false)
              .toList()
          : <Category>[];
      return Right(filteredCategories);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, SliderModel>> getSliders() async {
    try {
      final sliders = await remoteDataSource.getSliders();
      return Right(sliders);
    } on CacheException {
      return Left(ServerFailure());
    }
  }
}
