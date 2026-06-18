import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../controller/leave_request_controller.dart';
import '../../data/const/color_theme.dart';
import '../../model/a_leave_request_list.dart';
import '../../model/leave_request_model.dart';
import 'leave_request_details.dart';

class LeaveRequestReceivedScreen extends StatefulWidget {
  const LeaveRequestReceivedScreen({super.key});

  @override
  State<LeaveRequestReceivedScreen> createState() =>
      _LeaveRequestReceivedScreenState();
}

class _LeaveRequestReceivedScreenState
    extends State<LeaveRequestReceivedScreen> {
  final LeaveRequestController controller = Get.put(LeaveRequestController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: CommonAppBar(
        title: "Leave Reports",
        backgroundColor: AppColors.primary,
        titleColor: AppColors.white,
        showBack: false,
      ),

      body: Column(
        children: [
          SizedBox(height: 2.h),

          /// LIST
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemCount: controller.leaveList.length,
                padding: EdgeInsets.symmetric(horizontal: 16.sp),
                itemBuilder: (context, index) {
                  final leave = controller.leaveList[index];

                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.sp),
                    child: LeaveRequestCardApi(leave: leave),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class LeaveRequestCardApi extends StatelessWidget {
  final LeaveRequestApiModel leave;

  const LeaveRequestCardApi({super.key, required this.leave});

  String formatDate(String date) {
    try {
      return DateFormat("dd MMM yyyy").format(DateTime.parse(date));
    } catch (e) {
      return date;
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "approved":
        return AppColors.success;

      case "rejected":
        return AppColors.danger;

      case "pending":
        return AppColors.warning;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Get.to(() => LeaveRequestDetailScreen(leave: leave));
      },
      child: Container(
        padding: EdgeInsets.all(14.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 21.sp,
              backgroundColor: AppColors.primary.withOpacity(.1),
              child: Text(
                leave.employeeName.isEmpty
                    ? "?"
                    : leave.employeeName[0].toUpperCase(),
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),

            SizedBox(width: 12.sp),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CommonText(
                          text: leave.employeeName,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.sp,
                          vertical: 5.sp,
                        ),
                        decoration: BoxDecoration(
                          color: getStatusColor(leave.status).withOpacity(.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: CommonText(
                          text: leave.status,
                          fontSize: 11.sp,
                          color: getStatusColor(leave.status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6.sp),

                  CommonText(
                    text: leave.leaveType,
                    color: AppColors.primary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),

                  SizedBox(height: 6.sp),

                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 15.sp,
                        color: AppColors.greyDark,
                      ),

                      SizedBox(width: 5.sp),

                      Expanded(
                        child: CommonText(
                          text:
                              "${formatDate(leave.fromDate)}  -  ${formatDate(leave.toDate)}",
                          fontSize: 12.sp,
                          color: AppColors.greyDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
