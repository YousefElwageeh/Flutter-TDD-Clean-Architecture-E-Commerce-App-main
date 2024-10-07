import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:eshop/core/services/services_locator.dart';
import 'package:eshop/features/order_chekout/domain/entities/order_request_model.dart';
import 'package:eshop/features/order_chekout/domain/repositories/order_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';

import '../../../../order_chekout/domain/usecases/add_order_usecase.dart';

part 'order_add_state.dart';

class OrderAddCubit extends Cubit<OrderAddState> {
  final AddOrderUseCase _addOrderUseCase;
  final OrderRepository repo = sl();

  OrderAddCubit(this._addOrderUseCase) : super(OrderAddInitial());

  void addOrder(OrderRequestModel params) async {
    try {
      emit(OrderAddLoading());
      final result = await _addOrderUseCase(params);
      result.fold((failure) => emit(OrderAddFail()), (order) {
        EasyLoading.showSuccess("Order Placed Successfully");

        emit(OrderAddSuccess());
      });
    } catch (e) {
      emit(OrderAddFail());
    }
  }

  // ignore: body_might_complete_normally_nullable
  Future<int?> getVat() async {
    emit(OrderGetVatLoading());
    final result = await repo.getVatprectage();
    // ignore: void_checks
    result.fold((failure) => emit(OrderGEtVatError()), (value) {
      emit(OrderGEtVatSuccess());
      log(value.toString());
      return value;
    });
  }
}
