import 'package:client/models/user_portfolio_model.dart';

class UserModel {
  String userId = "";
  String name = "";
  String email = "";
  UserPortfolio portfolio = UserPortfolio(
    amount: 0.0,
    totalValue: 0.0,
    goldHoldings: GoldHoldings(),
  );

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.portfolio,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['_id'] ?? "",
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      portfolio: json['portfolio'] ?? "0",
    );
  }
}
