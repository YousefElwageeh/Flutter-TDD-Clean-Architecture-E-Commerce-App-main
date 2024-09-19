part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  final CategoryModel categories;
  const CategoryState({required this.categories});
}

class CategoryInitial extends CategoryState {
  const CategoryInitial({required super.categories});
  @override
  List<Object> get props => [];
}

class CategoryLoading extends CategoryState {
  const CategoryLoading({required super.categories});
  @override
  List<Object> get props => [];
}

class CategoryCacheLoaded extends CategoryState {
  const CategoryCacheLoaded({required super.categories});
  @override
  List<Object> get props => [];
}

class CategoryLoaded extends CategoryState {
  const CategoryLoaded({required super.categories});
  @override
  List<Object> get props => [];
}

class CategoryError extends CategoryState {
  final Failure failure;
  const CategoryError({required super.categories, required this.failure});
  @override
  List<Object> get props => [];
}

class SliderSuccess extends CategoryState {
  const SliderSuccess({
    required super.categories,
  });
  @override
  List<Object> get props => [];
}

class SliderError extends CategoryState {
  final Failure failure;
  const SliderError({required super.categories, required this.failure});
  @override
  List<Object> get props => [];
}
