class UserModel {
  String userId = "";
  String name = "";
  String email = "";

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['_id'] ?? "",
      name: json['name'] ?? "",
      email: json['email'] ?? "",
    );
  }
}
