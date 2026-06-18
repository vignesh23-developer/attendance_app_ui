import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';

import '../data/const/api.dart';
import '../data/local_storage/stroage_services.dart';
import '../model/attendance_model.dart';
import '../model/e_leave_request_model.dart';

class LeaveController extends GetxController {
  final api = ApiService();

  final formKey = GlobalKey<FormState>();

  final reasonController = TextEditingController();

  final RxString leaveType = "Sick Leave".obs;

  final Rx<DateTime?> fromDate = Rx<DateTime?>(null);
  final Rx<DateTime?> toDate = Rx<DateTime?>(null);

  final RxBool isSubmitting = false.obs;
  final RxBool isLoading = false.obs;

  final RxList<LeaveRequestModel> myLeaves = <LeaveRequestModel>[].obs;

  final List<String> leaveTypes = [
    "Sick Leave",
    "Casual Leave",
    "Personal Leave",
  ];

  @override
  void onInit() {
    super.onInit();
    getLeaveRequests();
  }

  Future<void> refreshLeaves() async {
    await getLeaveRequests();
  }

  String get fromDateLabel => fromDate.value != null
      ? DateFormat('dd MMM yyyy').format(fromDate.value!)
      : 'Select date';

  String get toDateLabel => toDate.value != null
      ? DateFormat('dd MMM yyyy').format(toDate.value!)
      : 'Select date';

  Future<void> pickFromDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: fromDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF730323)),
        ),
        child: child!,
      ),
    );
    if (date != null) {
      fromDate.value = date;
      if (toDate.value != null && toDate.value!.isBefore(date)) {
        toDate.value = date;
      }
    }
  }

  Future<void> pickToDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: toDate.value ?? (fromDate.value ?? DateTime.now()),
      firstDate: fromDate.value ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF730323)),
        ),
        child: child!,
      ),
    );
    if (date != null) toDate.value = date;
  }

  Future<void> submitLeave() async {
    if (!formKey.currentState!.validate()) return;

    if (fromDate.value == null || toDate.value == null) {
      toastification.show(
        autoCloseDuration: Duration(seconds: 3),
        title: Text(
          "Error: Select leave dates",
          style: TextStyle(fontSize: 14.sp, color: Colors.white),
        ),
        alignment: Alignment.topCenter
      );
      return;
    }

    try {
      isSubmitting.value = true;

      final employeeId = await StorageService.getLoginId();

      final employeeName = await StorageService.getName();

      final response = await api.postRequest(Api.leaveRequest, {
        "employee_id": employeeId,
        "employee_name": employeeName,
        "leave_type": leaveType.value,
        "from_date": DateFormat("yyyy-MM-dd").format(fromDate.value!),
        "to_date": DateFormat("yyyy-MM-dd").format(toDate.value!),
        "reason": reasonController.text.trim(),
      });

      if (response.data["success"] == true) {
        Get.snackbar("Success", response.data["message"]);
        toastification.show(
            autoCloseDuration: Duration(seconds: 3),
            title: Text(
              "Error: Select leave dates",
              style: TextStyle(fontSize: 14.sp, color: Colors.white),
            ),
            alignment: Alignment.topCenter
        );

        await getLeaveRequests();

        reasonController.clear();
        fromDate.value = null;
        toDate.value = null;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> getLeaveRequests() async {
    try {
      isLoading.value = true;

      final employeeId = await StorageService.getLoginId();

      final response = await api.postRequest(Api.requestList, {
        "employee_id": employeeId,
      });

      final model = LeaveListResponse.fromJson(response.data);

      myLeaves.value = model.data;
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelLeave(int leaveRequestId) async {
    try {
      final employeeId = await StorageService.getLoginId();

      final response = await api.postRequest(Api.cancelLeave, {
        "employee_id": employeeId,
        "leave_request_id": leaveRequestId,
      });

      if (response.data["success"] == true) {
        Get.snackbar("Success", response.data["message"]);

        await getLeaveRequests();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }
}
