class AttendanceHistoryModel {
  final int attendanceId;
  final DateTime checkinDate;
  final String? checkinTime;
  final DateTime? checkoutDate;
  final String? checkoutTime;
  final String status;

  AttendanceHistoryModel({
    required this.attendanceId,
    required this.checkinDate,
    this.checkinTime,
    this.checkoutDate,
    this.checkoutTime,
    required this.status,
  });

  factory AttendanceHistoryModel.fromJson(
      Map<String, dynamic> json) {
    return AttendanceHistoryModel(
      attendanceId: json["attendance_id"],
      checkinDate: DateTime.parse(json["checkin_date"]),
      checkinTime: json["checkin_time"],
      checkoutDate: json["checkout_date"] != null
          ? DateTime.parse(json["checkout_date"])
          : null,
      checkoutTime: json["checkout_time"],
      status: json["status"] ?? "",
    );
  }
}

class AttendanceHistoryResponse {
  final bool success;
  final List<AttendanceHistoryModel> data;

  AttendanceHistoryResponse({
    required this.success,
    required this.data,
  });

  factory AttendanceHistoryResponse.fromJson(
      Map<String, dynamic> json) {
    return AttendanceHistoryResponse(
      success: json["success"] ?? false,
      data: (json["data"] as List)
          .map((e) => AttendanceHistoryModel.fromJson(e))
          .toList(),
    );
  }
}