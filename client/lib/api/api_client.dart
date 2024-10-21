import 'package:client/api/interceptor.dart';
import 'package:client/models/api_response.dart';
import 'package:client/models/payment_model.dart';
import 'package:client/models/user_portfolio_model.dart';
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
    String? name,
    String? email,
    String? pasword,
  ) async {
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

  Future<ApiResponse> createPayementOrder(double amount, String userId) async {
    Map<String, dynamic> payload = {
      "amount": amount,
      "userId": userId,
    };
    final ApiResponse apiResponse = ApiResponse();
    try {
      final Response reponse = await dio.post("/payment/order", data: payload);
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

  Future<ApiResponse> verifyPayment(Map<String, dynamic> payload) async {
    final ApiResponse apiResponse = ApiResponse();
    try {
      final Response reponse =
          await dio.post("/payment/verify-payment", data: payload);
      if (reponse.statusCode == 200) {
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

  Future<ApiResponse> getPortfolio(String userId) async {
    final ApiResponse apiResponse = ApiResponse();
    try {
      final Response response = await dio.get(
        "/payment/portfolio-stats",
        data: {'userId': userId},
      );
      if (response.statusCode == 200) {
        apiResponse.resultStatus = ResultStatus.success;
        apiResponse.message = response.data["message"];
        apiResponse.responseData =
            UserPortfolio.fromJson(response.data["data"]);
      } else {
        apiResponse.resultStatus = ResultStatus.failure;
        apiResponse.message = response.data["message"];
      }
      return apiResponse;
    } catch (e) {
      debugPrint(e.toString());
      apiResponse.resultStatus = ResultStatus.failure;
      apiResponse.message = "Error fetching response";
      return apiResponse;
    }
  }

  Future<ApiResponse> getTransactionHistory(String userId) async {
    final ApiResponse apiResponse = ApiResponse();
    try {
      final Response response = await dio.get(
        "/payment/transaction-history",
        data: {'userId': userId},
      );
      if (response.statusCode == 200) {
        apiResponse.resultStatus = ResultStatus.success;
        apiResponse.message = response.data["message"];
        List<dynamic> dataList = response.data["data"];
        apiResponse.responseData = dataList
            .map(
              (e) => PaymentModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      } else {
        apiResponse.resultStatus = ResultStatus.failure;
        apiResponse.message = response.data["message"];
      }
      return apiResponse;
    } catch (e) {
      debugPrint(e.toString());
      apiResponse.resultStatus = ResultStatus.failure;
      apiResponse.message = "Error fetching response";
      return apiResponse;
    }
  }

  Future<ApiResponse> handleDeposits(double amount, String userId) async {
    final ApiResponse apiResponse = ApiResponse();
    try {
      final Response response = await dio.post(
        "/payment/deposit",
        data: {
          "amount": amount,
          "userId": userId,
        },
      );
      if (response.statusCode == 200) {
        apiResponse.resultStatus = ResultStatus.success;
        apiResponse.message = response.data["message"];
        apiResponse.responseData = response.data["data"];
      } else {
        apiResponse.resultStatus = ResultStatus.failure;
        apiResponse.message = response.data["message"];
      }
      return apiResponse;
    } catch (e) {
      debugPrint(e.toString());
      apiResponse.resultStatus = ResultStatus.failure;
      apiResponse.message = "Error fetching response";
      return apiResponse;
    }
  }

  Future<ApiResponse> handleWithdraw(double amount, String userId) async {
    final ApiResponse apiResponse = ApiResponse();
    try {
      final Response response = await dio.post(
        "/payment/withdraw",
        data: {
          "amount": amount,
          "userId": userId,
        },
      );
      if (response.statusCode == 200) {
        apiResponse.resultStatus = ResultStatus.success;
        apiResponse.message = response.data["message"];
        apiResponse.responseData = response.data["data"];
      } else {
        apiResponse.resultStatus = ResultStatus.failure;
        apiResponse.message = response.data["message"];
      }
      return apiResponse;
    } catch (e) {
      debugPrint(e.toString());
      apiResponse.resultStatus = ResultStatus.failure;
      apiResponse.message = "Error fetching response";
      return apiResponse;
    }
  }

  Future<ApiResponse> getGoldPrice() async {
    final ApiResponse apiResponse = ApiResponse();
    try {
      final Response response = await dio.get("/payment/gold-price");
      if (response.statusCode == 200) {
        apiResponse.resultStatus = ResultStatus.success;
        apiResponse.message = response.data["message"];
        apiResponse.responseData = response.data["goldPrice"];
      } else {
        apiResponse.resultStatus = ResultStatus.failure;
        apiResponse.message = response.data["message"];
      }
      return apiResponse;
    } catch (e) {
      debugPrint(e.toString());
      apiResponse.resultStatus = ResultStatus.failure;
      apiResponse.message = "Error fetching response";
      return apiResponse;
    }
  }

  Future<ApiResponse> handleBuyGold(double amount, String userId) async {
    final ApiResponse apiResponse = ApiResponse();
    try {
      final response = await dio.post(
        "/payment/buy-gold",
        data: {
          "amount": amount,
          "userId": userId,
        },
      );
      if (response.statusCode == 200) {
        apiResponse.resultStatus = ResultStatus.success;
        apiResponse.message = response.data["message"];
        apiResponse.responseData = response.data["data"];
      } else {
        apiResponse.resultStatus = ResultStatus.failure;
        apiResponse.message = response.data["message"];
      }
      return apiResponse;
    } catch (e) {
      debugPrint(e.toString());
      apiResponse.resultStatus = ResultStatus.failure;
      apiResponse.message = "Error fetching response";
      return apiResponse;
    }
  }

  Future<ApiResponse> handleSellGold(double amount, String userId) async {
    final ApiResponse apiResponse = ApiResponse();
    try {
      final response = await dio.post(
        "/payment/sell-gold",
        data: {
          "amount": amount,
          "userId": userId,
        },
      );
      if (response.statusCode == 200) {
        apiResponse.resultStatus = ResultStatus.success;
        apiResponse.message = response.data["message"];
        apiResponse.responseData = response.data["data"];
      } else {
        apiResponse.resultStatus = ResultStatus.failure;
        apiResponse.message = response.data["message"];
      }
      return apiResponse;
    } catch (e) {
      debugPrint(e.toString());
      apiResponse.resultStatus = ResultStatus.failure;
      apiResponse.message = "Error fetching response";
      return apiResponse;
    }
  }

  //end
}
