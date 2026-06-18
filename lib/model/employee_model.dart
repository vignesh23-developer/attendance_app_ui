class EmployeeModel {
  final int employeeId;
  final String name;
  final String role;
  final String image;
  final String phone;

  EmployeeModel({
    required this.employeeId,
    required this.name,
    required this.role,
    required this.image,
    required this.phone,
  });

  factory EmployeeModel.fromJson(
      Map<String, dynamic> json) {
    return EmployeeModel(
      employeeId: json["employee_id"],
      name: json["name"] ?? "",
      role: json["role"] ?? "",
      image: json["image"] ?? "",
      phone: json["number"] ?? "",
    );
  }
}