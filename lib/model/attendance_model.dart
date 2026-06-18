import 'package:flutter/material.dart';

import '../data/const/color_theme.dart';

enum AttendanceStatus {
  present,
  leave,
  halfDay,
  permission,
}

class AttendanceRecord {
  AttendanceRecord({
    required this.date,
    required this.status,
    this.checkIn,
    this.checkOut,
    this.totalHours,
    this.checkInImage,
  });

  final DateTime date;
  final AttendanceStatus status;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String? totalHours;
  final String? checkInImage;

  String get statusLabel {
    switch (status) {
      case AttendanceStatus.present:
        return "Present";

      case AttendanceStatus.leave:
        return "Leave";

      case AttendanceStatus.halfDay:
        return "Half Day";

      case AttendanceStatus.permission:
        return "Permission";
    }
  }

  Color get statusColor {
    switch (status) {
      case AttendanceStatus.present:
        return AppColors.presentFg;

      case AttendanceStatus.leave:
        return AppColors.danger;

      case AttendanceStatus.halfDay:
        return AppColors.halfFg;
      case AttendanceStatus.permission:
        return Colors.blue;
    }
  }

  Color get statusBgColor {
    switch (status) {
      case AttendanceStatus.present:
        return const Color(0xFFDCFCE7);
      case AttendanceStatus.halfDay:
        return const Color(0xFFFEF9C3);
      case AttendanceStatus.leave:
        return AppColors.absentBg;
      case AttendanceStatus.permission:
        return const Color(0xFFDBEAFE);
    }
  }
}

class LeaveRequest {
  LeaveRequest({
    required this.id,
    required this.type,
    required this.from,
    required this.to,
    required this.reason,
    required this.status,
    this.attachmentPath,
    this.subject,
  });

  final String id;
  final String type;
  final DateTime from;
  final DateTime to;
  final String reason;
  final String status; // pending | approved | rejected
  final String? attachmentPath;
  final String? subject;

  int get days => to.difference(from).inDays + 1;
}
