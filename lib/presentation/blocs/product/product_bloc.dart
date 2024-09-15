import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
            products: const [],
            params: const FilterProductParams(),
            metaData: PaginationMetaData(
              pageSize: 20,
              limit: 0,
              total: 0,
            ))) {
    on<GetProducts>(_onLoadProducts);
    on<GetMoreProducts>(_onLoadMoreProducts);
  }

  void _onLoadProducts(GetProducts event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoading(
        products: products,
        metaData: state.metaData,
        params: event.params,
      ));
      final result = await _getProductUseCase(event.params);
      result.fold(
        (failure) => emit(ProductError(
          products: products,
          metaData: state.metaData,
          failure: failure,
          params: event.params,
        )),
        (productResponse) => emit(ProductLoaded(
          metaData: productResponse.paginationMetaData,
          products: products,
          params: event.params,
        )),
      );
    } catch (e) {
      emit(ProductError(
        products: state.products,
        metaData: state.metaData,
        failure: ExceptionFailure(),
        params: event.params,
      ));
    }
  }

  void _onLoadMoreProducts(
      GetMoreProducts event, Emitter<ProductState> emit) async {
    var state = this.state;
    var limit = state.metaData.limit;
    var total = state.metaData.total;
    var loadedProductsLength = state.products.length;
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
            products: products,
            metaData: state.metaData,
            failure: failure,
            params: state.params,
          )),
          (productResponse) {
            //    List<Product> products = state.products;
            products.addAll(productResponse.products);
            emit(ProductLoaded(
              metaData: state.metaData,
              products: products,
              params: state.params,
            ));
          },
        );
      } catch (e) {
        emit(ProductError(
          products: products,
          metaData: state.metaData,
          failure: ExceptionFailure(),
          params: state.params,
        ));
      }
    }
  }
}

final products = [
  Product(
    id: '1',
    name: 'Laptop',
    description: 'High-performance laptop with 16GB RAM and 512GB SSD.',
    priceTags: [PriceTag(price: 1200.00, id: 'USD', name: 'USD')],
    categories: const [],
    images: const [
      'https://d2v5dzhdg4zhx3.cloudfront.net/web-assets/images/storypages/rem_bg_tab_product_show/E-commerce.webp',
      'https://d2v5dzhdg4zhx3.cloudfront.net/web-assets/images/storypages/rem_bg_tab_product_show/E-commerce.webp'
    ],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Product(
    id: '2',
    name: 'Smartphone',
    description: 'Latest smartphone with a 6.5-inch display and 5G support.',
    priceTags: [PriceTag(price: 900.00, id: 'USD', name: 'USD')],
    categories: const [
      ////Category(id: '1', name: 'Electronics', image: 'electronics_image.jpg')
    ],
    images: const ['smartphone1.jpg', 'smartphone2.jpg'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Product(
    id: '3',
    name: 'Headphones',
    description:
        'Noise-cancelling wireless headphones with 30-hour battery life.',
    priceTags: [PriceTag(price: 250.00, id: 'USD', name: 'USD')],
    categories: const [
      ////Category(id: '1', name: 'Electronics', image: 'audio_image.jpg')
    ],
    images: const ['headphones1.jpg', 'headphones2.jpg'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Product(
    id: '4',
    name: 'Running Shoes',
    description: 'Lightweight running shoes with breathable fabric.',
    priceTags: [PriceTag(price: 120.00, id: 'USD', name: 'USD')],
    categories: const [
      //Category(id: '3', name: 'Sports', image: 'sports_image.jpg')
    ],
    images: const ['shoes1.jpg', 'shoes2.jpg'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Product(
    id: '5',
    name: 'Backpack',
    description:
        'Durable backpack with multiple compartments for laptops and accessories.',
    priceTags: [PriceTag(price: 80.00, id: 'USD', name: 'USD')],
    categories: const [
      //Category(id: '4', name: 'Accessories', image: 'accessories_image.jpg')
    ],
    images: const ['backpack1.jpg', 'backpack2.jpg'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Product(
    id: '6',
    name: 'Wristwatch',
    description: 'Waterproof wristwatch with a stainless steel band.',
    priceTags: [PriceTag(price: 300.00, id: 'USD', name: 'USD')],
    categories: const [
      //Category(id: '4', name: 'Accessories', image: 'accessories_image.jpg')
    ],
    images: const ['watch1.jpg', 'watch2.jpg'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Product(
    id: '7',
    name: 'Gaming Chair',
    description:
        'Ergonomic gaming chair with lumbar support and adjustable height.',
    priceTags: [PriceTag(price: 400.00, id: 'USD', name: 'USD')],
    categories: const [
      //Category(id: '5', name: 'Furniture', image: 'furniture_image.jpg')
    ],
    images: const ['chair1.jpg', 'chair2.jpg'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Product(
    id: '8',
    name: 'Electric Guitar',
    description:
        'Six-string electric guitar with a solid wood body and maple neck.',
    priceTags: [PriceTag(price: 700.00, id: 'USD', name: 'USD')],
    categories: const [
      //Category(id: '2', name: 'Audio', image: 'audio_image.jpg')
    ],
    images: const ['guitar1.jpg', 'guitar2.jpg'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Product(
    id: '9',
    name: 'Office Desk',
    description: 'Spacious office desk made of oak wood.',
    priceTags: [PriceTag(price: 500.00, id: 'USD', name: 'USD')],
    categories: const [
      //Category(id: '5', name: 'Furniture', image: 'furniture_image.jpg')
    ],
    images: const ['desk1.jpg', 'desk2.jpg'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Product(
    id: '10',
    name: 'Coffee Maker',
    description: 'Automatic coffee maker with programmable timer.',
    priceTags: [PriceTag(price: 150.00, id: 'USD', name: 'USD')],
    categories: const [
      //Category(id: '6', name: 'Appliances', image: 'appliances_image.jpg')
    ],
    images: const ['coffee_maker1.jpg', 'coffee_maker2.jpg'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
];
