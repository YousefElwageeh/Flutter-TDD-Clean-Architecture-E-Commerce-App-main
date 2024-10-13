import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:eshop/core/services/services_locator.dart';
import 'package:eshop/features/order_chekout/domain/entities/order_request_model.dart';
import 'package:eshop/features/order_chekout/domain/repositories/order_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../order_chekout/domain/usecases/add_order_usecase.dart';

part 'order_add_state.dart';

class OrderAddCubit extends Cubit<OrderAddState> {
  final AddOrderUseCase _addOrderUseCase;
  final OrderRepository repository = sl();

  OrderAddCubit(this._addOrderUseCase) : super(OrderAddInitial());

  void addOrder(OrderRequestModel params) async {
    emit(OrderAddLoading());
    final result = await _addOrderUseCase(params);
    result.fold((failure) => emit(OrderAddFail()), (order) {
      emit(OrderAddSuccess());
     //   EasyLoading.showSuccess("Order Placed Successfully");
      getPaymentWebView(order.data['id']);
    });
  }

  String webViewUrl = "";
  getPaymentWebView(int orderID) {
   
    repository.getPaymentWebView(orderID: orderID.toString()).then(
      (value) {
        value.fold((failure) => log(failure.toString()), (order) {
          webViewUrl = order.data.toString();
                    emit(OrderGetWebViewSuccess());


          //  EasyLoading.showSuccess("Order Placed Successfully");
        });
      },
    );
  }
  // ignore: body_might_complete_normally_nullable
}
