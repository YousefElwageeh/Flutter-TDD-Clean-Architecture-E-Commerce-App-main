part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  CartModel cart;
  CartState({required this.cart});
}

class CartInitial extends CartState {
  CartInitial({required super.cart});

  @override
  List<Object> get props => [];
}

class CartLoading extends CartState {
  CartLoading({required super.cart});

  @override
  List<Object> get props => [];
}

class CartLoaded extends CartState {
  CartLoaded({required super.cart});

  @override
  List<Object> get props => [];
}

class CartError extends CartState {
  final Failure failure;
  CartError({required this.failure, required super.cart});

  @override
  List<Object> get props => [];
}
