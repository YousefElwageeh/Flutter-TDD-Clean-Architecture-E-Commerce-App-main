import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eshop/data/models/product/product_response_model.dart';
import 'package:eshop/domain/entities/category/category.dart';
import 'package:eshop/domain/entities/product/price_tag.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/product/pagination_meta_data.dart';
import '../../../domain/entities/product/product.dart';
import '../../../domain/usecases/product/get_product_usecase.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductUseCase _getProductUseCase;

  ProductBloc(this._getProductUseCase)
      : super(ProductInitial(
            products: ProductResponseModel(),
            params: const FilterProductParams(),
            metaData: PaginationMetaData(
              pageSize: 20,
              limit: 0,
              total: 0,
            ))) {
    on<GetProducts>(_onLoadProducts);
    on<GetMoreProducts>(_onLoadMoreProducts);
  }
  int countity = 1;
  void icreaseCountity() {
    emit(DecreaseProduct(
        countity: countity,
        products: state.products,
        metaData: state.metaData,
        params: state.params));
    countity++;
    emit(IncreseProduct(
        countity: countity,
        products: state.products,
        metaData: state.metaData,
        params: state.params));
  }

  void decreaseCountity() {
    if (countity > 1) {
      emit(IncreseProduct(
          countity: countity,
          products: state.products,
          metaData: state.metaData,
          params: state.params));
      countity--;
      emit(DecreaseProduct(
          countity: countity,
          products: state.products,
          metaData: state.metaData,
          params: state.params));
    }
  }

  void _onLoadProducts(GetProducts event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoading(
        products: state.products,
        metaData: state.metaData,
        params: event.params,
      ));
      final result = await _getProductUseCase(event.params);
      result.fold(
          (failure) => emit(ProductError(
                products: state.products,
                metaData: state.metaData,
                failure: failure,
                params: event.params,
              )), (productResponse) {
        log(productResponse.products?.length.toString() ?? '');
        emit(ProductLoaded(
          metaData: PaginationMetaData(limit: 100, pageSize: 1, total: 100),
          products: productResponse,
          params: event.params,
        ));
      });
    } catch (e) {
      emit(ProductError(
        products: state.products,
        metaData: state.metaData,
        failure: ExceptionFailure(),
        params: event.params,
      ));
    }
  }

  ProductResponseModel productsWithCategories = ProductResponseModel();

  void _onLoadMoreProducts(
      GetMoreProducts event, Emitter<ProductState> emit) async {
    var state = this.state;
    var limit = state.metaData.limit;
    var total = state.metaData.total;
    var loadedProductsLength = state.products.products?.length ?? 0;
    // check state and loaded products amount[loadedProductsLength] compare with
    // number of results total[total] results available in server
    if (state is ProductLoaded && (loadedProductsLength < total)) {
      try {
        emit(ProductLoading(
          products: state.products,
          metaData: state.metaData,
          params: state.params,
        ));
        final result =
            await _getProductUseCase(FilterProductParams(limit: limit + 10));
        result.fold(
          (failure) => emit(ProductError(
            products: state.products,
            metaData: state.metaData,
            failure: failure,
            params: state.params,
          )),
          (productResponse) {
            //    List<Product> products = state.products;

            emit(ProductLoaded(
              metaData: state.metaData,
              products: productResponse,
              params: state.params,
            ));
          },
        );
      } catch (e) {
        emit(ProductError(
          products: state.products,
          metaData: state.metaData,
          failure: ExceptionFailure(),
          params: state.params,
        ));
      }
    }
  }
}
