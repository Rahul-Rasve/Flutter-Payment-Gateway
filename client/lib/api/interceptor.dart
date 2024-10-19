import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.baseUrl = "http:localhost:8000/api";
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 200) {
      debugPrint("Response fetched successfully");
    } else {
      debugPrint("Error fetching response");
    }
    super.onResponse(response, handler);
  }
}
