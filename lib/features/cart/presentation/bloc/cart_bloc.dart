import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eshop/config/helpers/app_states.dart';
import 'package:eshop/config/locale/tranlslations.dart';
import 'package:eshop/config/util/widgets/delivery_info_card.dart';
import 'package:eshop/core/extension/string_extension.dart';
import 'package:eshop/core/services/services_locator.dart';
import 'package:eshop/features/cart/data/models/add_to_card_request.dart';
import 'package:eshop/features/cart/data/models/cart_item_model.dart';
import 'package:eshop/features/cart/domain/repositories/cart_repository.dart';
import 'package:eshop/features/product/data/models/product_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/clear_cart_usecase.dart';
import '../../domain/usecases/sync_cart_usecase.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  ///final GetCachedCartUseCase _getCachedCartUseCase;
  final CartRepository repository = sl();

  final SyncCartUseCase _syncCartUseCase;
  final ClearCartUseCase _clearCartUseCase;
  CartBloc(
    // this._getCachedCartUseCase,
    this._syncCartUseCase,
    this._clearCartUseCase,
  ) : super(CartInitial(cart: CartModel())) {
    on<GetCart>(_onGetCart);
    on<AddProduct>(_onAddToCart);
    on<ClearCart>(_onClearCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
  }

  void _onGetCart(GetCart event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading(cart: CartModel()));

      // final result = await _getCachedCartUseCase(NoParams());
      // result.fold(
      //   (failure) => emit(CartError(cart: state.cart, failure: failure)),
      //   (cart) => emit(CartLoaded(cart: cart)),
      // );

      final syncResult = await _syncCartUseCase(NoParams());
      syncResult.fold((failure) {
        log(failure.toString());
        emit(CartError(cart: state.cart, failure: failure));
      }, (cart) {
        emit(CartLoaded(cart: cart));
      });
    } catch (e) {
      emit(CartError(failure: ExceptionFailure(), cart: state.cart));
    }
  }

  void _onAddToCart(
    AddProduct event,
    Emitter<CartState> emit,
  ) async {
    try {
      // Start with loading state
      emit(CartLoading(cart: state.cart));

      // Call repository with await
      final result = await repository.addToCart(event.cartItem);

      // Handle the result using fold from dartz package
      result.fold(
        (failure) {
          // Show error and emit CartError state
          EasyLoading.showError(AppLocale.somethingWentWrong.getTranslation());
          emit(CartError(cart: state.cart, failure: failure));
        },
        (cart) {
          // Emit success state
          emit(CartLoaded(cart: state.cart));
          EasyLoading.showSuccess(
              AppLocale.productAddedSuccess.getTranslation());
        },
      );
    } catch (e) {
      // Catch any other exceptions and emit error state

      EasyLoading.showError(AppLocale.unexpectedErrorOccurred.getTranslation());
      emit(CartError(cart: state.cart, failure: ExceptionFailure()));
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading(cart: CartModel()));
      emit(CartLoaded(cart: CartModel()));
    } catch (e) {
      emit(CartError(cart: CartModel(), failure: ExceptionFailure()));
    }
  }

  void delteItem(int id) {
    emit(CartLoading(cart: state.cart));

    repository.delteItemFromCart(id).then((value) {
      value.fold((l) {
        log(l.toString());
        emit(CartError(cart: state.cart, failure: l));
      }, (r) {
        state.cart.cart?.removeWhere((element) => element.item!.id == id);
        emit(CartLoaded(cart: state.cart));
      });
    });
  }

  // cart_bloc.dart
  void _onUpdateCartItemQuantity(
      UpdateCartItemQuantity event, Emitter<CartState> emit) {
    final cart = state.cart;
    if (cart.cart != null && event.itemIndex < cart.cart!.length) {
      final currentItem = cart.cart![event.itemIndex];
      final updatedQuantity = (currentItem.qty ?? 0) + event.quantity;

      // Create a new CartModel with updated quantity
      state.cart.cart?[event.itemIndex].qty = updatedQuantity;
      emit(CartLoaded(cart: state.cart));

      log(state.cart.cart?[event.itemIndex].qty.toString() ?? '');
    }
  }

  List<Product> serchResult = [];
  searchProduct(String term) {
    emit(CartLoading(cart: state.cart));
    repository.searchProduct(term).then((value) {
      value.fold((l) {
        log(l.toString());
        emit(CartError(cart: state.cart, failure: l));
      }, (r) {
        serchResult = r;
        emit(CartLoaded(cart: state.cart));
      });
    });
  }
}
