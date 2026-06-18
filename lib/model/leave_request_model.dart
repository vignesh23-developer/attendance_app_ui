class LeaveRequestModel {
  final String name;
  final String role;
  final String leaveType;
  final String fromDate;
  final String toDate;
  final int days;
  final String reason;
  final String status;

  LeaveRequestModel({
    required this.name,
    required this.role,
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.days,
    required this.reason,
    required this.status
  });
}