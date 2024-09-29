import 'dart:developer';

import 'package:eshop/core/api/constant&endPoints.dart';
import 'package:eshop/core/api/dio_factory.dart';
import 'package:eshop/core/error/failures.dart';
import 'package:eshop/features/home/model/slider_model.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constant/strings.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<CategoryModel> getCategories();
  Future<SliderModel> getSliders();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  CategoryRemoteDataSourceImpl();

  @override
  Future<CategoryModel> getCategories() async {
    final response = await DioFactory.getdata(
      url: '$baseUrl/categoryy',
    );
    CategoryModel data = CategoryModel.fromJson(response.data);
    log(data.category?.length.toString() ?? '');
    return data;
  }

  @override
  Future<SliderModel> getSliders() async {
    final response = await DioFactory.getdata(
      url: EndPoints.sliders,
    );
    SliderModel data = SliderModel.fromJson(response.data);
    return data;
  }
}
