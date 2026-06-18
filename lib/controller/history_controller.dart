import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../data/const/api.dart';
import '../data/local_storage/stroage_services.dart';
import '../model/attendance_model.dart';

class AttendanceController extends GetxController {


  final RxList<AttendanceRecord> records =
      <AttendanceRecord>[].obs;

  final Rx<DateTime> selectedMonth =
      DateTime.now().obs;

  final Rx<DateTime?> selectedDay =
  Rx<DateTime?>(null);

  final RxString searchQuery = ''.obs;

  final Rx<AttendanceStatus?> selectedFilter =
  Rx<AttendanceStatus?>(null);

  final api = ApiService();

  final RxBool isLoading = false.obs;

  // Summary Counts
  int get presentCount =>
      records
          .where(
            (r) =>
        r.status ==
            AttendanceStatus.present,
      )
          .length;

  int get permissionCount =>
      records
          .where(
            (r) =>
        r.status ==
            AttendanceStatus.permission,
      )
          .length;

  int get leaveCount =>
      records
          .where(
            (r) =>
        r.status ==
            AttendanceStatus.leave,
      )
          .length;

  int get halfDayCount =>
      records
          .where(
            (r) =>
        r.status ==
            AttendanceStatus.halfDay,
      )
          .length;

  List<AttendanceRecord> get filtered {
    List<AttendanceRecord> result =
    records.toList();

    // Status Filter
    if (selectedFilter.value != null) {
      result = result
          .where(
            (e) =>
        e.status ==
            selectedFilter.value,
      )
          .toList();
    }

    // Calendar Day Filter
    if (selectedDay.value != null) {
      result = result.where((r) {
        return r.date.year ==
            selectedDay.value!.year &&
            r.date.month ==
                selectedDay.value!.month &&
            r.date.day ==
                selectedDay.value!.day;
      }).toList();
    }

    // Search Filter
    final q =
    searchQuery.value.toLowerCase();

    if (q.isNotEmpty) {
      result = result.where((r) {
        final label =
        r.statusLabel.toLowerCase();

        final date = DateFormat(
          'dd MMM',
        ).format(r.date).toLowerCase();

        return label.contains(q) ||
            date.contains(q);
      }).toList();
    }

    return result;
  }

  @override
  void onInit() {
    super.onInit();
    getAttendanceHistory();
  }
  Future<void> refreshAttendance() async {
    await getAttendanceHistory();
  }
  Future<void> getAttendanceHistory() async {
    try {
      isLoading.value = true;

      final employeeId = await StorageService.getLoginId();

      final response = await api.postRequest(
        Api.history,
        {
          "employee_id": employeeId,
        },
      );

      if (response.data["success"] == true) {
        final data = response.data["data"];

        print("Response: ${response.data}");


        records.clear();

        if (data != null) {
          final checkInDate = DateTime.parse(
            data["checkin_date"],
          );

          final apiStatus = (data["status"] ?? "")
              .toString()
              .trim()
              .toUpperCase();

          AttendanceStatus status;

          switch (apiStatus) {
            case "PRESENT":
            case "CHECKED_OUT":
            case "CHECKED_IN":
              status = AttendanceStatus.present;
              break;

            case "LEAVE":
              status = AttendanceStatus.leave;
              break;

            case "HALF DAY":
            case "HALF_DAY":
              status = AttendanceStatus.halfDay;
              break;

            case "PERMISSION":
              status = AttendanceStatus.permission;
              break;

            default:
              print("Unknown Status => $apiStatus");
              status = AttendanceStatus.leave;
          }
          print("API STATUS => $apiStatus");
          print("MAPPED STATUS => $status");
          DateTime? checkIn;
          DateTime? checkOut;

          if (data["checkin_time"] != null) {
            final time =
            data["checkin_time"].toString().split(":");

            checkIn = DateTime(
              checkInDate.year,
              checkInDate.month,
              checkInDate.day,
              int.parse(time[0]),
              int.parse(time[1]),
            );
          }

          if (data["checkout_time"] != null) {
            final checkoutDate =
            data["checkout_date"] != null
                ? DateTime.parse(
              data["checkout_date"],
            )
                : checkInDate;

            final time =
            data["checkout_time"].toString().split(":");

            checkOut = DateTime(
              checkoutDate.year,
              checkoutDate.month,
              checkoutDate.day,
              int.parse(time[0]),
              int.parse(time[1]),
            );
          }

          String? totalHours;

          if (checkIn != null && checkOut != null) {
            final diff = checkOut.difference(checkIn);

            totalHours =
            "${diff.inHours.toString().padLeft(2, '0')}:${(diff.inMinutes % 60).toString().padLeft(2, '0')}";
          }

          records.add(
            AttendanceRecord(
              date: checkInDate,
              status: status,
              checkIn: checkIn,
              checkOut: checkOut,
              totalHours: totalHours,
            ),
          );
        }

        records.sort(
              (a, b) => b.date.compareTo(a.date),
        );
      }
    } catch (e) {
      print("History API Error: $e");
    } finally {
      isLoading.value = false;
    }
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
      DateTime day,
      ) {
    try {
      return records
          .firstWhere(
            (r) =>
        r.date.year ==
            day.year &&
            r.date.month ==
                day.month &&
            r.date.day ==
                day.day,
      )
          .status;
    } catch (_) {
      return null;
    }
  }
}
