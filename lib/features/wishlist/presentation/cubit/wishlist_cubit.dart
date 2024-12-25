import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'package:eshop/features/product/data/models/product_response_model.dart';
import 'package:eshop/features/wishlist/data/models/wish_list_model.dart';
import 'package:eshop/features/wishlist/data/repositories/wishlist_repo.dart';

part 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistRepo wishlistRepo;

  WishlistCubit(
    this.wishlistRepo,
  ) : super(WishlistInitial());

  void getWishlist() async {
    emit(WishlistLoading());
    try {
      final wishlist = await wishlistRepo.getWishlist();
      wishlist.fold(
        (e) {
          emit(WishlistError(
              errorMessage:
                  e.errorMessage?.response?.data['message'].toString() ?? ""));
        },
        (data) {
          emit(WishlistLoaded(data));
        },
      );
    } catch (e) {
      log(e.toString());

      emit(WishlistError(errorMessage: e.toString()));
    }
  }

  addToWishlist(String productId) async {
    try {
      final wishlist = await wishlistRepo.addWishlist(productId);
      wishlist.fold(
        (e) {
          emit(WishlistError(
              errorMessage:
                  e.errorMessage?.response?.data['message'].toString() ?? ""));
        },
        (data) {
          getWishlist();
        },
      );
    } catch (e) {
      emit(WishlistError(errorMessage: e.toString()));
    }
  }

  removeFromWishlist(String productId) async {
    try {
      final wishlist = await wishlistRepo.removeWishlist(productId);
      wishlist.fold(
        (e) {
          emit(WishlistError(
              errorMessage:
                  e.errorMessage?.response?.data['message'].toString() ?? ""));
        },
        (data) {
          getWishlist();
        },
      );
    } catch (e) {
      log(e.toString());
      emit(WishlistError(errorMessage: e.toString()));
    }
  }
}
