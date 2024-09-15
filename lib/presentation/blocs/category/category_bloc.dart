import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eshop/data/models/category/category_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/entities/category/category.dart';
import '../../../domain/usecases/category/filter_category_usecase.dart';
import '../../../domain/usecases/category/get_cached_category_usecase.dart';
import '../../../domain/usecases/category/get_remote_category_usecase.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetRemoteCategoryUseCase _getCategoryUseCase;
  final GetCachedCategoryUseCase _getCashedCategoryUseCase;
  final FilterCategoryUseCase _filterCategoryUseCase;

  CategoryBloc(this._getCategoryUseCase, this._getCashedCategoryUseCase,
      this._filterCategoryUseCase)
      : super(const CategoryLoading(categories: [])) {
    on<GetCategories>(_onLoadCategories);
    on<FilterCategories>(_onFilterCategories);
  }

  void _onLoadCategories(
      GetCategories event, Emitter<CategoryState> emit) async {
    try {
      ///Initial Category loading with minimal loading animation
      ///
      ///Cashed category
      emit(const CategoryLoading(categories: []));
      final cashedResult = await _getCashedCategoryUseCase(NoParams());
      cashedResult.fold(
        (failure) => (),
        (categories) => emit(CategoryCacheLoaded(
          categories: state.categories,
        )),
      );

      ///Check remote data source to find categories
      ///Method will find and update if there any new category update from server
      ///Remote Category
      final result = await _getCategoryUseCase(NoParams());
      result.fold(
        (failure) => emit(CategoryError(
          categories: state.categories,
          failure: failure,
        )),
        (categories) => emit(CategoryLoaded(
          categories: state.categories,
        )),
      );
    } catch (e) {
      EasyLoading.showError(e.toString());
      emit(CategoryError(
        categories: state.categories,
        failure: ExceptionFailure(),
      ));
    }
  }

  void _onFilterCategories(
      FilterCategories event, Emitter<CategoryState> emit) async {
    try {
      ///Initial Category loading with minimal loading animation
      ///
      ///Cashed category
      emit(CategoryLoading(categories: state.categories));
      final cashedResult = await _filterCategoryUseCase(event.keyword);
      cashedResult.fold(
        (failure) => emit(CategoryError(
          categories: state.categories,
          failure: failure,
        )),
        (categories) => emit(CategoryCacheLoaded(
          categories: state.categories,
        )),
      );
    } catch (e) {
      emit(CategoryError(
        categories: state.categories,
        failure: ExceptionFailure(),
      ));
    }
  }
}

// final categoriess = [
//   const Category(
//       id: '1',
//       name: 'Electronics',
//       image:
//           'https://i.pinimg.com/564x/51/d3/88/51d38806d50482762c700eca5717a32f.jpg'),
//   const Category(id: '2', name: 'Audio', image: 'audio_image.jpg'),
//   const Category(id: '3', name: 'Sports', image: 'sports_image.jpg'),
//   const Category(id: '4', name: 'Accessories', image: 'accessories_image.jpg'),
//   const Category(id: '5', name: 'Furniture', image: 'furniture_image.jpg'),
//   const Category(id: '6', name: 'Appliances', image: 'appliances_image.jpg'),
//   const Category(id: '7', name: 'Toys', image: 'toys_image.jpg'),
//   const Category(id: '8', name: 'Fashion', image: 'fashion_image.jpg'),
//   const Category(id: '9', name: 'Beauty', image: 'beauty_image.jpg'),
//   const Category(id: '10', name: 'Books', image: 'books_image.jpg'),
// ];
