class EmployeeModel {
  String name;
  String email;
  String password;
  String role;
  String number;
  String image;

  EmployeeModel({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.number,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "role": role,
      "number": number,
      "image": image,
    };
  }
}