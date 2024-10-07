part of 'order_add_cubit.dart';

@immutable
abstract class OrderAddState {}

class OrderAddInitial extends OrderAddState {}

class OrderAddLoading extends OrderAddState {}

class OrderAddSuccess extends OrderAddState {
  OrderAddSuccess();
}

class OrderAddFail extends OrderAddState {}

class OrderGetVatLoading extends OrderAddState {}

class OrderGEtVatSuccess extends OrderAddState {}

class OrderGEtVatError extends OrderAddState {}
