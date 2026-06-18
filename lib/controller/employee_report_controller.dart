import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../data/const/api.dart';
import '../model/attendance_model.dart';

class EmployeeReportController extends GetxController {
  final ApiService apiService = ApiService();

  RxBool isLoading = false.obs;

  final RxList<AttendanceRecord> records =
      <AttendanceRecord>[].obs;

  final Rx<DateTime> selectedMonth =
      DateTime.now().obs;

  final Rx<DateTime?> selectedDay =
  Rx<DateTime?>(null);

  final RxString searchQuery = ''.obs;

  final Rx<AttendanceStatus?> selectedFilter =
  Rx<AttendanceStatus?>(null);

  // ===========================
  // API
  // ===========================

  Future<void> getEmployeeHistory(int employeeId) async {
    try {
      isLoading.value = true;

      final response = await apiService.postRequest(
        Api.employeeHistory,
        {
          "employee_id": employeeId,
        },
      );

      if (response.statusCode == 200 &&
          response.data["success"] == true) {

        final List data = response.data["data"] ?? [];

        print("EmployeeID : $employeeId");
        print("API Count : ${data.length}");

        records.assignAll(
          data.map((e) {
            return AttendanceRecord(
              date: DateTime.parse(
                e["from_date"],
              ),

              status: _getStatus(
                e["status"],
              ),

              checkIn: null,
              checkOut: null,
              totalHours: null,
            );
          }).toList(),
        );

        print(
          "Records Loaded : ${records.length}",
        );
      }
    } catch (e) {
      print("ERROR : $e");
    } finally {
      isLoading.value = false;
    }
  }

  AttendanceStatus _getStatus(
      String? status) {

    switch ((status ?? "").toLowerCase()) {
      case "present":
        return AttendanceStatus.present;

      case "leave":
      case "approved":
        return AttendanceStatus.leave;

      case "permission":
        return AttendanceStatus.permission;

      case "half day":
      case "half_day":
        return AttendanceStatus.halfDay;

      default:
        return AttendanceStatus.present;
    }
  }

  // ===========================
  // COUNTS
  // ===========================

  int get presentCount =>
      records
          .where((e) =>
      e.status ==
          AttendanceStatus.present)
          .length;

  int get permissionCount =>
      records
          .where((e) =>
      e.status ==
          AttendanceStatus.permission)
          .length;

  int get leaveCount =>
      records
          .where((e) =>
      e.status ==
          AttendanceStatus.leave)
          .length;

  int get halfDayCount =>
      records
          .where((e) =>
      e.status ==
          AttendanceStatus.halfDay)
          .length;

  // ===========================
  // FILTER
  // ===========================

  List<AttendanceRecord> get filtered {
    List<AttendanceRecord> result =
    records.toList();

    /// Month Filter

    result = result.where((e) {
      return e.date.month ==
          selectedMonth.value.month &&
          e.date.year ==
              selectedMonth.value.year;
    }).toList();

    /// Day Filter

    if (selectedDay.value != null) {
      result = result.where((e) {
        return e.date.year ==
            selectedDay.value!.year &&
            e.date.month ==
                selectedDay.value!.month &&
            e.date.day ==
                selectedDay.value!.day;
      }).toList();
    }

    /// Status Filter

    if (selectedFilter.value != null) {
      result = result.where((e) {
        return e.status ==
            selectedFilter.value;
      }).toList();
    }

    /// Search Filter

    if (searchQuery.value.isNotEmpty) {
      final query =
      searchQuery.value.toLowerCase();

      result = result.where((e) {
        final date =
        DateFormat(
          'dd MMM yyyy',
        ).format(e.date).toLowerCase();

        return date.contains(query) ||
            e.statusLabel
                .toLowerCase()
                .contains(query);
      }).toList();
    }

    result.sort(
          (a, b) =>
          b.date.compareTo(a.date),
    );

    return result;
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

  AttendanceStatus? statusForDay(
      DateTime day) {
    try {
      return records.firstWhere(
            (r) =>
        r.date.year == day.year &&
            r.date.month == day.month &&
            r.date.day == day.day,
      ).status;
    } catch (_) {
      return null;
    }
  }
}

