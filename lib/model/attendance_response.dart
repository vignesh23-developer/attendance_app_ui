class AttendanceResponse {
  final bool success;
  final String message;
  final int? attendanceId;
  final String? imageUrl;

  AttendanceResponse({
    required this.success,
    required this.message,
    this.attendanceId,
    this.imageUrl,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      attendanceId: json["attendance_id"],
      imageUrl: json["checkin_image"] ?? json["checkout_image"],
    );
  }
}