// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart';
import 'package:eshop/core/api/app_interceptors.dart';
import 'package:eshop/core/services/services_locator.dart';
import 'package:flutter/foundation.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'constant&endPoints.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "Content-Type";

const String connectTimeout = "Content-Type";
const String APPLICATION_file = 'multipart/form-data';

const String ACCEPT = "Accept";
const String AUTHORIZATION = "Authorization";
const String DEFAULT_LANGUAGE = "lang";

const int apiTimeOut = 600000000;

class DioFactory {
  static late Dio dio;
  static void getDio() {
    dio = Dio();

    // String language = await PrefData.getAppLanguage();
    // print(language);
    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,

      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: 'Bearer ${Constants.token}' ?? '',
      //   DEFAULT_LANGUAGE: await Get.find<PrefData>().getLanguage()
    };

    dio.options = BaseOptions(
        baseUrl: Constants.baseUrl,
        headers: headers,
        receiveDataWhenStatusError: true,
        receiveTimeout: const Duration(milliseconds: apiTimeOut),
        sendTimeout: const Duration(milliseconds: apiTimeOut));

    if (!kReleaseMode) {
      // its debug mode so print app logs
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ));
    }
    dio.interceptors.add(sl<AppIntercepters>());
  }

  static Future<Response> getdata({
    required String url,
    Map<String, dynamic>? quary,
    Map? data,
  }) async {
    return await dio.get(
      url,
      data: data,
      queryParameters: quary,
    );
  }

  static Future<Response> postdata({
    required String url,
    dynamic quary,
    dynamic data,
    Options? options,
  }) async {
    return await dio.post(url,
        queryParameters: quary, data: data, options: options);
  }

  static Future<Response> putdata({
    required String url,
    dynamic quary,
    required dynamic data,
  }) async {
    return await dio.put(url, queryParameters: quary, data: data);
  }

  static Future<Response> delteData({
    required String url,
    dynamic quary,
    dynamic data,
  }) async {
    return await dio.delete(url, queryParameters: quary, data: data);
  }

  static Future<Response> patchdata({
    required String url,
    dynamic quary,
    required dynamic data,
  }) async {
    return await dio.patch(url, queryParameters: quary, data: data);
  }
}
