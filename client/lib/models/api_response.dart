enum ResultStatus { success, failure }

class ApiResponse {
  Map<String, dynamic>? headers;
  ResultStatus? resultStatus;
  dynamic responseData;
  String message;

  ApiResponse(
      {this.resultStatus,
      this.responseData,
      this.message = "Unknown",
      this.headers});
}
