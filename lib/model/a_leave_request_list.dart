class LeaveRequestApiModel {
  final int leaveRequestId;
  final String employeeId;
  final String employeeName;
  final String leaveType;
  final String fromDate;
  final String toDate;
  final String reason;
  final String status;

  LeaveRequestApiModel({
    required this.leaveRequestId,
    required this.employeeId,
    required this.employeeName,
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.status,
  });

  factory LeaveRequestApiModel.fromJson(
      Map<String, dynamic> json) {
    return LeaveRequestApiModel(
      leaveRequestId: json["leave_request_id"] ?? 0,
      employeeId: json["employee_id"].toString(),
      employeeName: json["employee_name"] ?? "",
      leaveType: json["leave_type"] ?? "",
      fromDate: json["from_date"] ?? "",
      toDate: json["to_date"] ?? "",
      reason: json["reason"] ?? "",
      status: json["status"] ?? "",
    );
  }
}