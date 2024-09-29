import 'package:dartz/dartz.dart';
import 'package:eshop/features/category/data/models/category_model.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../repositories/category_repository.dart';

class GetRemoteCategoryUseCase implements UseCase<CategoryModel, NoParams> {
  final CategoryRepository repository;
  GetRemoteCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, CategoryModel>> call(NoParams params) async {
    return await repository.getRemoteCategories();
  }
}
