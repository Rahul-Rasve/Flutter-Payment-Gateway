class UserModel {
  String userId = "";
  String name = "";
  String email = "";
  String portfolio = "";

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.portfolio,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['_id'] ?? "";
    name = json['name'] ?? "";
    email = json['email'] ?? "";
    portfolio = json['portfolio'] ?? "0";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['portfolio'] = portfolio;
    return data;
  }
}
