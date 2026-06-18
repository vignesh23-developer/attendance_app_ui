import 'attendance_model.dart';

class EmployeeHistoryModel {
  final String date;
  final String? checkIn;
  final String? checkOut;
  final String? totalHours;
  final String status;

  EmployeeHistoryModel({
    required this.date,
    this.checkIn,
    this.checkOut,
    this.totalHours,
    required this.status,
  });

  factory EmployeeHistoryModel.fromJson(
      Map<String, dynamic> json) {
    return EmployeeHistoryModel(
      date: json["attendance_date"] ?? "",
      checkIn: json["check_in"],
      checkOut: json["check_out"],
      totalHours: json["total_hours"],
      status: json["status"] ?? "",
    );
  }
}