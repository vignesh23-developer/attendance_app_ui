// lib/models/attendance_model.dart

import 'package:flutter/material.dart';

enum AttendanceStatus { present, absent, halfDay, leave, holiday }

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
        return 'Present';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.halfDay:
        return 'Half Day';
      case AttendanceStatus.leave:
        return 'Leave';
      case AttendanceStatus.holiday:
        return 'Holiday';
    }
  }

  Color get statusColor {
    switch (status) {
      case AttendanceStatus.present:
        return const Color(0xFF16A34A);
      case AttendanceStatus.absent:
        return const Color(0xFFDC2626);
      case AttendanceStatus.halfDay:
        return const Color(0xFFF59E0B);
      case AttendanceStatus.leave:
        return const Color(0xFF7C3AED);
      case AttendanceStatus.holiday:
        return const Color(0xFF3B82F6);
    }
  }

  Color get statusBgColor {
    switch (status) {
      case AttendanceStatus.present:
        return const Color(0xFFDCFCE7);
      case AttendanceStatus.absent:
        return const Color(0xFFFEE2E2);
      case AttendanceStatus.halfDay:
        return const Color(0xFFFEF9C3);
      case AttendanceStatus.leave:
        return const Color(0xFFEDE9FE);
      case AttendanceStatus.holiday:
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
