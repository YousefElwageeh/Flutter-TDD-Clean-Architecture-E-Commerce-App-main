import 'package:dartz/dartz.dart';
import 'package:eshop/data/models/cart/cart_item_model.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/cart/cart_item.dart';
import '../../repositories/cart_repository.dart';

class SyncCartUseCase implements UseCase<CartModel, NoParams> {
  final CartRepository repository;
  SyncCartUseCase(this.repository);

  @override
  Future<Either<Failure, CartModel>> call(NoParams params) async {
    return await repository.syncCart();
  }
}
