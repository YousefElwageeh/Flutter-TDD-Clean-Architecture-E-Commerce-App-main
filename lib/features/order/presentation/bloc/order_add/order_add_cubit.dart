import 'package:bloc/bloc.dart';
import 'package:eshop/features/order_chekout/domain/entities/order_reponce_model.dart';
import 'package:eshop/features/order_chekout/domain/entities/order_request_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../../order_chekout/domain/entities/order_details.dart';
import '../../../../order_chekout/domain/usecases/add_order_usecase.dart';

part 'order_add_state.dart';

class OrderAddCubit extends Cubit<OrderAddState> {
  final AddOrderUseCase _addOrderUseCase;
  OrderAddCubit(this._addOrderUseCase) : super(OrderAddInitial());

  void addOrder(OrderRequestModel params) async {
    try {
      emit(OrderAddLoading());
      final result = await _addOrderUseCase(params);
      result.fold(
        (failure) => emit(OrderAddFail()),
        (order) => emit(OrderAddSuccess(order)),
      );
    } catch (e) {
      emit(OrderAddFail());
    }
  }
}
