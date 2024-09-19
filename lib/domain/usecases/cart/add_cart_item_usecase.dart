// import 'package:dartz/dartz.dart';
// import 'package:eshop/data/models/cart/add_to_card_request.dart';
// import 'package:eshop/data/models/cart/cart_item_model.dart';

// import '../../../../../core/error/failures.dart';
// import '../../../../../core/usecases/usecase.dart';
// import '../../entities/cart/cart_item.dart';
// import '../../repositories/cart_repository.dart';

// class AddCartUseCase implements UseCase<void, CartItemModel> {
//   final CartRepository repository;
//   AddCartUseCase(this.repository);

//   @override
//   Future<Either<Failure, void>> call(AddToCardRequest params) async {
//     return await repository.addToCart(params);
//   }
// }
