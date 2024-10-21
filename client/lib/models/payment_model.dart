class PaymentModel {
  final String id;
  final String type;
  final double amount;
  final double goldQuantity;
  final double goldPrice;
  final String status;
  final String razorpayPaymentId;
  final DateTime createdAt;

  PaymentModel({
    this.id = "",
    this.type = "",
    this.amount = 0.0,
    this.goldQuantity = 0.0,
    this.goldPrice = 0.0,
    this.status = "",
    this.razorpayPaymentId = "",
    required this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['_id'],
      type: json['paymentType'],
      amount: double.parse(json['amount']?.toString() ?? '0'),
      goldQuantity: double.parse(json['goldQuantity']?.toString() ?? '0'),
      goldPrice: double.parse(json['goldPrice']?.toString() ?? '0'),
      status: json['status'] ?? "PENDING",
      razorpayPaymentId: json['razorpayPaymentId'] ?? "NA",
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
