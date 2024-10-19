class UserModel {
  String name = "";
  String email = "";
  String portfolio = "";

  UserModel({required this.name, required this.email, required this.portfolio});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    email = json['email'] ?? "";
    portfolio = json['portfolio'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['portfolio'] = portfolio;
    return data;
  }
}