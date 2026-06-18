class AdminLoginModel {
  bool? success;
  String? message;
  AdminData? data;

  AdminLoginModel({
    this.success,
    this.message,
    this.data,
  });

  factory AdminLoginModel.fromJson(Map<String, dynamic> json) {
    return AdminLoginModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] != null
          ? AdminData.fromJson(json["data"])
          : null,
    );
  }
}

class AdminData {
  String? email;
  String? name;
  String? role;
  String? image;
  String? token;

  AdminData({
    this.email,
    this.name,
    this.role,
    this.image,
    this.token,
  });

  factory AdminData.fromJson(Map<String, dynamic> json) {
    return AdminData(
      email: json["email"],
      name: json["name"],
      role: json["role"],
      image: json["image"],
      token: json["token"],
    );
  }
}