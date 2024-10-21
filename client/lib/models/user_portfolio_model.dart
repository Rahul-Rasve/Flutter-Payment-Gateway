class UserPortfolio {
  final double amount;
  final GoldHoldings goldHoldings;
  final double totalValue;

  UserPortfolio({
    this.amount = 0.0,
    required this.goldHoldings,
    this.totalValue = 0.0,
  });

  factory UserPortfolio.fromJson(Map<String, dynamic> json) {
    return UserPortfolio(
      amount: double.parse(json['amount']?.toString() ?? '0'),
      goldHoldings: GoldHoldings.fromJson(json['goldHoldings']),
      totalValue: double.parse(json['total']?.toString() ?? '0'),
    );
  }
}

class GoldHoldings {
  final double quantity;
  final double buyPrice;
  final double globalPrice;
  final double currentValue;

  GoldHoldings({
    this.quantity = 0.0,
    this.buyPrice = 0.0,
    this.globalPrice = 0.0,
    this.currentValue = 0.0,
  });

  factory GoldHoldings.fromJson(Map<String, dynamic> json) {
    return GoldHoldings(
      quantity: double.parse(json['quantity']?.toString() ?? '0'),
      buyPrice: double.parse(json['buyPrice']?.toString() ?? '0'),
      globalPrice: double.parse(json['globalPrice']?.toString() ?? '0'),
      currentValue: double.parse(json['currentValue']?.toString() ?? '0'),
    );
  }
}
