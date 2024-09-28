import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eshop/core/services/services_locator.dart';
import 'package:eshop/data/models/cart/add_to_card_request.dart';
import 'package:eshop/data/models/cart/cart_item_model.dart';
import 'package:eshop/domain/repositories/cart_repository.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/entities/cart/cart_item.dart';
import '../../../domain/usecases/cart/add_cart_item_usecase.dart';
import '../../../domain/usecases/cart/clear_cart_usecase.dart';
import '../../../domain/usecases/cart/get_cached_cart_usecase.dart';
import '../../../domain/usecases/cart/sync_cart_usecase.dart';

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

  void _onAddToCart(AddProduct event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading(cart: state.cart));
      CartModel cart = CartModel();
      cart = state.cart;
      // cart.add();
      repository.addToCart(event.cartItem).then((va) {
        va.fold((failure) {
          log(failure.errorMessage.toUpperCase());
          EasyLoading.showError('SomeThing Went Wrong');

          emit(CartError(cart: state.cart, failure: failure));
        }, (cart) async {
          EasyLoading.showSuccess('Product added to cart successfully');

          emit(CartLoaded(cart: state.cart));
        });
      });
    } catch (e) {
      //   emit(CartError(cart: state.cart, failure: ExceptionFailure()));
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading(cart: CartModel()));
      emit(CartLoaded(cart: CartModel()));
      await _clearCartUseCase(NoParams());
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
}
