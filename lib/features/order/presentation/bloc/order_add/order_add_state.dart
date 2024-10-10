part of 'order_add_cubit.dart';

@immutable
abstract class OrderAddState {}

class OrderAddInitial extends OrderAddState {}

class OrderAddLoading extends OrderAddState {}

class OrderAddSuccess extends OrderAddState {}

class OrderAddFail extends OrderAddState {}

class OrderGetWebViewLoading extends OrderAddState {}

class OrderGetWebViewSuccess extends OrderAddState {}

class OrderGetWebViewFail extends OrderAddState {}
