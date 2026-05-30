import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/attendance_model.dart';

class AttendanceController extends GetxController {
  final RxList<AttendanceRecord> records      = <AttendanceRecord>[].obs;
  final Rx<DateTime> selectedMonth            = DateTime.now().obs;
  final Rx<DateTime?> selectedDay             = Rx<DateTime?>(null);
  final RxString searchQuery                  = ''.obs;

  // Summary counts
  int get presentCount  => records.where((r) => r.status == AttendanceStatus.present).length;
  int get absentCount   => records.where((r) => r.status == AttendanceStatus.absent).length;
  int get leaveCount    => records.where((r) => r.status == AttendanceStatus.leave).length;
  int get halfDayCount  => records.where((r) => r.status == AttendanceStatus.halfDay).length;

  List<AttendanceRecord> get filtered {
    final q = searchQuery.value.toLowerCase();
    return records.where((r) {
      final label = r.statusLabel.toLowerCase();
      final date  = DateFormat('dd MMM').format(r.date).toLowerCase();
      return label.contains(q) || date.contains(q);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
  }

  void _loadDummyData() {
    final now = DateTime.now();
    final statuses = [
      AttendanceStatus.present,
      AttendanceStatus.present,
      AttendanceStatus.present,
      AttendanceStatus.absent,
      AttendanceStatus.present,
      AttendanceStatus.halfDay,
      AttendanceStatus.present,
      AttendanceStatus.leave,
      AttendanceStatus.present,
      AttendanceStatus.present,
    ];

    records.value = List.generate(20, (i) {
      final date = now.subtract(Duration(days: i));
      final st = statuses[i % statuses.length];
      return AttendanceRecord(
        date: date,
        status: st,
        checkIn: st != AttendanceStatus.absent
            ? DateTime(date.year, date.month, date.day, 9, 8)
            : null,
        checkOut: st != AttendanceStatus.absent
            ? DateTime(date.year, date.month, date.day, 18, 5)
            : null,
        totalHours: st != AttendanceStatus.absent ? '08:57' : null,
      );
    });
  }

  void goToPrevMonth() {
    selectedMonth.value = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month - 1,
    );
  }

  void goToNextMonth() {
    final next = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month + 1,
    );
    if (!next.isAfter(DateTime.now())) {
      selectedMonth.value = next;
    }
  }

  AttendanceStatus? statusForDay(DateTime day) {
    try {
      return records.firstWhere((r) =>
      r.date.year == day.year &&
          r.date.month == day.month &&
          r.date.day == day.day).status;
    } catch (_) {
      return null;
    }
  }
}
