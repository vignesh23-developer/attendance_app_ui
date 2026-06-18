import 'package:attandance_app/controller/history_controller.dart';
import 'package:attandance_app/controller/home_controller.dart';
import 'package:attandance_app/controller/leave_controller.dart';
import 'package:attandance_app/data/const/color_theme.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'admin/admin_home.dart';
import 'admin/employee_list.dart';
import 'admin/leave_recived.dart';
import 'admin/profile.dart';

import 'employee/history.dart';
import 'employee/home_page.dart';
import 'employee/leave_request.dart';
import 'employee/profile.dart';

class BottomNavScreen extends StatefulWidget {
  final bool isAdmin;

  const BottomNavScreen({
    super.key,
    required this.isAdmin,
  });

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int currentIndex = 0;

  late final List<Widget> adminPages;
  late final List<Widget> employeePages;

  @override
  void initState() {
    super.initState();

    adminPages = [
      AdminHome(
        onTabChange: (index) {
          _changeTab(index);
        },
      ),
      const EmployeeListScreen(),
      const LeaveRequestReceivedScreen(),
      const AdminProfileScreen(),
    ];

    employeePages = [
      const HomeScreen(),
      const AttendanceHistoryScreen(),
      const LeaveRequestScreen(),
      const ProfileScreen(),
    ];
  }

  Future<void> _changeTab(int index) async {
    setState(() {
      currentIndex = index;
    });

    if (widget.isAdmin) return;

    try {
      switch (index) {
        case 0:
          if (Get.isRegistered<HomeController>()) {
            await Get.find<HomeController>();
          }
          break;

        case 1:
          if (Get.isRegistered<AttendanceController>()) {
            await Get.find<AttendanceController>()
                .getAttendanceHistory();
          }
          break;

        case 2:
          if (Get.isRegistered<LeaveController>()) {
            await Get.find<LeaveController>()
                .getLeaveRequests();
          }
          break;
        case 3:
          break;
      }
    } catch (e) {
      debugPrint("Tab Refresh Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = widget.isAdmin
        ? adminPages
        : employeePages;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),

      bottomNavigationBar: SafeArea(
        child: CurvedNavigationBar(
          index: currentIndex,
          height: 6.5.h,
          backgroundColor: Colors.transparent,
          color: AppColors.primary,
          buttonBackgroundColor: AppColors.secondary,
          animationDuration: const Duration(
            milliseconds: 300,
          ),

          items: [
            Icon(
              Icons.home,
              color: AppColors.white,
              size: 22.sp,
            ),

            Icon(
              widget.isAdmin
                  ? Icons.people
                  : Icons.history,
              color: AppColors.white,
              size: 22.sp,
            ),

            Icon(
              widget.isAdmin
                  ? Icons.assignment
                  : Icons.receipt_long,
              color: AppColors.white,
              size: 22.sp,
            ),

            Icon(
              Icons.person,
              color: AppColors.white,
              size: 22.sp,
            ),
          ],

          onTap: _changeTab,
        ),
      ),
    );
  }
}