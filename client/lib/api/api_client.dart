import 'package:client/api/interceptor.dart';
import 'package:client/models/api_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiClient {
  ApiClient._internal() {
    dio.interceptors.add(_dioInterceptor);
  }

  static final ApiClient _apiClient = ApiClient._internal();
  static final DioInterceptor _dioInterceptor = DioInterceptor();
  Dio dio = Dio();

  factory ApiClient() {
    return _apiClient;
  }

  Future<ApiResponse> loginUser(String? email, String? pasword) async {
    Map<String, dynamic> payload = {"email": email, "password": pasword};
    final ApiResponse apiResponse = ApiResponse();
    try {
      final Response reponse = await dio.post("/auth/login", data: payload);
      if (reponse.statusCode == 200) {
        apiResponse.resultStatus = ResultStatus.success;
        apiResponse.message = reponse.data["message"];
        apiResponse.responseData = reponse.data["user"];
      } else {
        apiResponse.resultStatus = ResultStatus.failure;
        apiResponse.message = reponse.data["message"];
      }
      return apiResponse;
    } catch (e) {
      debugPrint(e.toString());
      apiResponse.resultStatus = ResultStatus.failure;
      apiResponse.message = "Error fetching response";
      return apiResponse;
    }
  }

  Future<ApiResponse> signUpUser(
      String? name, String? email, String? pasword) async {
    Map<String, dynamic> payload = {
      "name": name,
      "email": email,
      "password": pasword
    };
    final ApiResponse apiResponse = ApiResponse();
    try {
      final Response reponse = await dio.post("/auth/signup", data: payload);
      if (reponse.statusCode == 201) {
        apiResponse.resultStatus = ResultStatus.success;
        apiResponse.message = reponse.data["message"];
        apiResponse.responseData = reponse.data["data"];
      } else {
        apiResponse.resultStatus = ResultStatus.failure;
        apiResponse.message = reponse.data["message"];
      }
      return apiResponse;
    } catch (e) {
      debugPrint(e.toString());
      apiResponse.resultStatus = ResultStatus.failure;
      apiResponse.message = "Error fetching response";
      return apiResponse;
    }
  }
}
