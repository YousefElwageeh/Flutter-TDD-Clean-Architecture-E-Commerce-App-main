part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
}

class GetCart extends CartEvent {
  const GetCart();

  @override
  List<Object> get props => [];
}

class AddProduct extends CartEvent {
  final AddToCardRequest cartItem;
  final bool isGuest;
  const AddProduct({
    required this.cartItem,
    required this.isGuest,
  });

  @override
  List<Object> get props => [];
}

class ClearCart extends CartEvent {
  const ClearCart();
  @override
  List<Object> get props => [];
}
