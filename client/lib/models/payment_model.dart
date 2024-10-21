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
      type: json['type'],
      amount: json['amount'].toDouble(),
      goldQuantity: json['goldQuantity']?.toDouble(),
      goldPrice: json['goldPrice']?.toDouble(),
      status: json['status'],
      razorpayPaymentId: json['razorpayPaymentId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}