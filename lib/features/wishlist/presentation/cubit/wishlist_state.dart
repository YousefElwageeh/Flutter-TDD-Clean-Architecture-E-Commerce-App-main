part of 'wishlist_cubit.dart';

abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object> get props => [];
}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final WishListModel wishlist;
  const WishlistLoaded(this.wishlist);
}

class WishlistError extends WishlistState {
  final String errorMessage;
  const WishlistError({required this.errorMessage});
}
