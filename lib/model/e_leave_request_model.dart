class LeaveRequestModel {
  final int leaveRequestId;
  final String leaveType;
  final String status;
  final DateTime fromDate;
  final DateTime toDate;
  final String reason;

  LeaveRequestModel({
    required this.leaveRequestId,
    required this.leaveType,
    required this.status,
    required this.fromDate,
    required this.toDate,
    required this.reason,
  });

  int get days =>
      toDate.difference(fromDate).inDays + 1;

  factory LeaveRequestModel.fromJson(
      Map<String, dynamic> json) {
    return LeaveRequestModel(
      leaveRequestId: json["leave_request_id"],
      leaveType: json["leave_type"],
      status: json["status"],
      fromDate: DateTime.parse(json["from_date"]),
      toDate: DateTime.parse(json["to_date"]),
      reason: json["reason"],
    );
  }
}

class LeaveListResponse {
  final bool success;
  final int count;
  final List<LeaveRequestModel> data;

  LeaveListResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory LeaveListResponse.fromJson(Map<String, dynamic> json) {
    return LeaveListResponse(
      success: json["success"] ?? false,
      count: json["count"] ?? 0,
      data: (json["data"] as List)
          .map((e) => LeaveRequestModel.fromJson(e))
          .toList(),
    );
  }
}