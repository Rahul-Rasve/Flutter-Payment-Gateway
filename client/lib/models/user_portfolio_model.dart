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
      amount: json['amount'],
      goldHoldings: GoldHoldings.fromJson(json['goldHoldings']),
      totalValue: json['total'],
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
      quantity: json['quantity'],
      buyPrice: json['buyPrice'],
      globalPrice: json['globalPrice'],
      currentValue: json['currentValue'],
    );
  }
}
