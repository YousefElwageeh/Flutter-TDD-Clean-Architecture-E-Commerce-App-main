import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:eshop/features/order/data/models/order_model.dart';
import 'package:eshop/features/order_chekout/domain/usecases/clear_local_order_usecase.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../order_chekout/domain/usecases/get_cached_orders_usecase.dart';
import '../../../../order_chekout/domain/usecases/get_remote_orders_usecase.dart';

part 'order_fetch_state.dart';

class OrderFetchCubit extends Cubit<OrderFetchState> {
  final GetRemoteOrdersUseCase _getOrdersUseCase;
  final GetCachedOrdersUseCase _getCachedOrdersUseCase;
  final ClearLocalOrdersUseCase _clearLocalOrdersUseCase;
  OrderFetchCubit(this._getOrdersUseCase, this._getCachedOrdersUseCase,
      this._clearLocalOrdersUseCase)
      : super(OrderFetchInitial(OrdersModel()));

  void getOrders() async {
    emit(OrderFetchLoading(state.orders));

    final remoteResult = await _getOrdersUseCase(NoParams());
    remoteResult.fold(
      (failure) {
        log(failure.toString());
        emit(OrderFetchFail(state.orders));
      },
      (orders) {
        emit(OrderFetchSuccess(orders));
      },
    );
  }

  /// clear current user's orders data from both local cache and state
  /// Use when user logout form device
  void clearLocalOrders() async {
    try {
      emit(OrderFetchLoading(state.orders));
      final cachedResult = await _clearLocalOrdersUseCase(NoParams());
      cachedResult.fold(
        (failure) => (),
        (result) => emit(OrderFetchInitial(OrdersModel())),
      );
    } catch (e) {
      emit(OrderFetchFail(state.orders));
    }
  }
}
