import 'package:attandance_app/data/const/color_theme.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'admin/admin_home.dart';
import 'admin/employee_list.dart';
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
      AdminHome(),
      EmployeeListScreen(),
      const DashboardPage(title: "Reports"),
      AttendanceProfileScreen(),
    ];

    employeePages = [
      HomeScreen(),
      AttendanceHistoryScreen(),
      LeaveRequestScreen(),
      ProfileScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {

    final pages = widget.isAdmin
        ? adminPages
        : employeePages;

    return Scaffold(

      backgroundColor: AppColors.background,

      body: pages[currentIndex],

      bottomNavigationBar: CurvedNavigationBar(

        index: currentIndex,

        height: 8.h,

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
                ? Icons.bar_chart
                : Icons.receipt_long_sharp,
            color: AppColors.white,
            size: 22.sp,
          ),

          Icon(
            Icons.person,
            color: AppColors.white,
            size: 22.sp,
          ),
        ],

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

/// ======================================
/// COMMON PAGE UI
/// ======================================

class DashboardPage extends StatelessWidget {

  final String title;

  const DashboardPage({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Container(
          margin: EdgeInsets.all(5.w),
          padding: EdgeInsets.all(6.w),

          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(25),

            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: CommonText(
            text: title,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}