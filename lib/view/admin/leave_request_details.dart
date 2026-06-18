import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../controller/leave_request_controller.dart';
import '../../data/const/color_theme.dart';
import '../../model/a_leave_request_list.dart';

class LeaveRequestDetailScreen extends StatefulWidget {
  final LeaveRequestApiModel leave;

  const LeaveRequestDetailScreen({super.key, required this.leave});

  @override
  State<LeaveRequestDetailScreen> createState() =>
      _LeaveRequestDetailScreenState();
}

class _LeaveRequestDetailScreenState extends State<LeaveRequestDetailScreen> {
  final LeaveRequestController controller = Get.find();

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
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),

      appBar: CommonAppBar(
        title: "Leave Details",
        backgroundColor: AppColors.primary,
        titleColor: AppColors.white,
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          height: 7.h,
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    controller.updateStatus(
                      employeeId: widget.leave.employeeId,
                      leaveRequestId: widget.leave.leaveRequestId,
                      status: "Rejected",
                    );
        
                    Get.back();
                  },
                  icon: const Icon(Icons.close),
                  label: const Text("Reject"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    minimumSize: const Size(double.infinity, 55),
                    side: BorderSide(color: AppColors.danger),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
        
              SizedBox(width: 12.sp),
        
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    controller.updateStatus(
                      employeeId: widget.leave.employeeId,
                      leaveRequestId: widget.leave.leaveRequestId,
                      status: "Approved",
                    );
        
                    Get.back();
                  },
                  icon: const Icon(Icons.check),
                  label: const Text("Approve"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          children: [
            /// EMPLOYEE CARD
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.04),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24.sp,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      widget.leave.employeeName[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),

                  SizedBox(width: 12.sp),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          text: widget.leave.employeeName,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),

                        SizedBox(height: 4.sp),

                        CommonText(
                          text: "Employee ID : ${widget.leave.employeeId}",
                          color: AppColors.greyDark,
                          fontSize: 13.sp,
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.sp,
                      vertical: 6.sp,
                    ),
                    decoration: BoxDecoration(
                      color: getStatusColor(
                        widget.leave.status,
                      ).withOpacity(.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CommonText(
                      text: widget.leave.status,
                      color: getStatusColor(widget.leave.status),
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.sp),

            /// INFORMATION CARD
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.04),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                children: [
                  buildInfoItem(
                    Icons.calendar_month,
                    "From Date",
                    formatDate(widget.leave.fromDate),
                  ),

                  buildInfoItem(
                    Icons.event_available,
                    "To Date",
                    formatDate(widget.leave.toDate),
                  ),

                  buildInfoItem(
                    Icons.event_note,
                    "Leave Type",
                    widget.leave.leaveType,
                  ),

                  buildInfoItem(
                    Icons.info_outline,
                    "Status",
                    widget.leave.status,
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            /// REASON CARD
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.sp),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.04),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        color: AppColors.primary,
                      ),

                      SizedBox(width: 8.sp),

                      CommonText(
                        text: "Leave Reason",
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),

                  SizedBox(height: 14.sp),

                  Text(
                    widget.leave.reason,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      height: 1.7,
                      fontSize: 15.sp,
                      color: AppColors.greyDark,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 80.sp),
          ],
        ),
      ),
    );
  }

  Widget buildInfoItem(IconData icon, String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 20.sp, color: AppColors.primary),
          ),

          SizedBox(width: 12.sp),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: title,
                  color: AppColors.greyDark,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),

                SizedBox(height: 3.sp),

                CommonText(
                  text: value,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
