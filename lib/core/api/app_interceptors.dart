import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eshop/core/api/constant&endPoints.dart';
import 'package:eshop/core/api/dio_factory.dart';
import 'package:eshop/core/services/services_locator.dart';
import 'package:eshop/data/data_sources/local/user_local_data_source.dart';
import 'package:flutter/foundation.dart';

class AppIntercepters extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
    // const String token =
    //     'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiYTcxMjE2NThjYTMzZjRlZTc3ZjY5ZjJiYzIxZmIxMmJiNDUzOWRiODA4ODFmYjU5NDljZDllYWI3ZTA2NWFmZjc4OTIxNDZjYzUzYzI3YTUiLCJpYXQiOjE3MjY0MTQ1OTksIm5iZiI6MTcyNjQxNDU5OSwiZXhwIjoxNzU3OTUwNTk5LCJzdWIiOiIxNzciLCJzY29wZXMiOltdfQ.WWsZ74MrkRKnPE9_JEHWPk24kOUNi0p7kJ69GoVjz2qdDYBqfo_8RYIl79bzJ26DPGu6caXTW5gzXSrATL6nbUQuT_0Xc2yukl8zdNXKqNQE87MotlYM4_RjBB9Rdpy8mK61PQSA2yvKeebPwlCql3t3HWWQqB3kK8OrdgAm3oErS3G6f9Buia8fDtINruY4iX6wk-bg6Yf0E4Qg4Y3MFjwrolBDP1QoiYQUqlLAGCgifn3b6BgqvBAMSjd-W1LqET3dDDk8K_kbkyzE71AULPGyJSxEvo-KiR-48XCUeyFtDLCVyD2LqCenIcB-ErU_ZIpvieI7LZ4sI0xMDCuwf8AkrfAq9S2DxCJoAVU3AaVzch3omWjyXOKohyvj9abMDJiajk1OagEgWY508z8umywQhfwldzw5BfL_YmFBZHX1iSbBb1Ehax2AcLjrYeE8o0nt6aGD3eIc1Prkx3f5k3sDCM9seaLjB8s1Jtd0sQFJrkTGsrPFeiGUhp9Y9G8n032yki8P1gZ4jcN1XIgi9KJpHeSi8mqA2MmJFUdUepL8dxZBVOxhVAdPMWykJkTir7boHbHQMGUYVuZnw4lgotjhD5IDC1G_nGgYCUG8c8mqDLFIZNv9K-A95Fv_A_UfRRFIUNaic-aw2RNf3aeRJF5Mssq3UEx9Ct4aludxWzI';
    options.headers[AUTHORIZATION] = 'Bearer ${Constants.token}';
    super.onRequest(options, handler);
  }

  @override
  void onResponse(response, ResponseInterceptorHandler handler) {
    debugPrint(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}
