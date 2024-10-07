import 'package:dartz/dartz.dart';
import 'package:eshop/features/cart/data/models/cart_item_model.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class SyncCartUseCase implements UseCase<CartModel, NoParams> {
  final CartRepository repository;
  SyncCartUseCase(this.repository);

  @override
  Future<Either<Failure, CartModel>> call(NoParams params) async {
    return await repository.syncCart();
  }
}
