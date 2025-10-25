class UserModel {
  final int id;
  final String name;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // ✅ Nếu dữ liệu có key "user" (như từ backend)
    final data = json['user'] ?? json;

    return UserModel(
      id: data['id'] ?? 0,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
    );
  }
}
