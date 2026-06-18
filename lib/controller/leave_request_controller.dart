import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:dio/dio.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';

import '../data/const/api.dart';
import '../model/a_leave_request_list.dart';

class LeaveRequestController extends GetxController {
  final ApiService apiService = ApiService();

  RxBool isLoading = false.obs;

  RxList<LeaveRequestApiModel> leaveList = <LeaveRequestApiModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getLeaveRequests();
  }

  Future<void> getLeaveRequests() async {
    try {
      isLoading(true);

      Response response = await apiService.getRequest(Api.leaveRequestList);

      if (response.statusCode == 200 && response.data["success"] == true) {
        leaveList.assignAll(
          (response.data["data"] as List)
              .map((e) => LeaveRequestApiModel.fromJson(e))
              .toList(),
        );
      }
    } catch (e) {
      toastification.show(
        alignment: Alignment.topCenter,
        autoCloseDuration: Duration(seconds: 3),
        title: Text(
          "Error: ${e.toString()}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateStatus({
    required String employeeId,
    required int leaveRequestId,
    required String status,
  }) async {
    try {
      Response response = await apiService.postRequest(Api.updateStatus, {
        "employee_id": employeeId,
        "leave_request_id": leaveRequestId,
        "status": status,
      });

      if (response.statusCode == 200 && response.data["success"] == true) {

        toastification.show(
          alignment: Alignment.topCenter,
          autoCloseDuration: Duration(seconds: 3),
          title: Text(
            "Success ${response.data["message"]}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        );

        getLeaveRequests();
      } else {
        toastification.show(
          alignment: Alignment.topCenter,
          autoCloseDuration: Duration(seconds: 3),
          title: Text(
            "Error ${response.data["message"]}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }
    } catch (e) {
      toastification.show(
        alignment: Alignment.topCenter,
        autoCloseDuration: Duration(seconds: 3),
        title: Text(
          "Error ${e.toString()}",
          style: TextStyle(
            color: Colors.black,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }
}
