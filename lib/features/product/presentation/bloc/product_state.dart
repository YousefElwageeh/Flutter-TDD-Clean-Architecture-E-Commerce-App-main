part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  final ProductResponseModel products;
  final PaginationMetaData metaData;
  final FilterProductParams params;
  int countity = 1;

  ProductState(
      {required this.products,
      required this.metaData,
      required this.params,
      this.countity = 1});
}

class ProductInitial extends ProductState {
  ProductInitial(
      {required super.products,
      required super.metaData,
      required super.params,
      super.countity = 1});
  @override
  List<Object> get props => [];
}

class ProductEmpty extends ProductState {
  ProductEmpty(
      {required super.products,
      required super.metaData,
      required super.params,
      super.countity = 1});
  @override
  List<Object> get props => [];
}

class ProductLoading extends ProductState {
  ProductLoading(
      {required super.products,
      required super.metaData,
      required super.params,
      super.countity = 1});
  @override
  List<Object> get props => [];
}

class ProductLoaded extends ProductState {
  ProductLoaded(
      {required super.products,
      required super.metaData,
      required super.params,
      super.countity = 1});
  @override
  List<Object> get props => [products];
}

class ProductError extends ProductState {
  final Failure failure;
  ProductError(
      {required super.products,
      required super.metaData,
      required super.params,
      required this.failure,
      super.countity = 1});
  @override
  List<Object> get props => [];
}

class IncreseProduct extends ProductState {
  IncreseProduct(
      {required super.products,
      required super.metaData,
      required super.params,
      super.countity = 1});
  @override
  List<Object> get props => [];
}

class DecreaseProduct extends ProductState {
  DecreaseProduct(
      {required super.products,
      required super.metaData,
      required super.params,
      super.countity = 1});
  @override
  List<Object> get props => [];
}
