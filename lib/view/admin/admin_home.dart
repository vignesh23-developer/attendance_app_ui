import 'package:attandance_app/view/admin/add_employee.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sizer/sizer.dart';
import '../../controller/dashboard_controller.dart';
import '../../data/const/color_theme.dart';

class AdminHome extends StatefulWidget {
  final Function(int)? onTabChange;
  const AdminHome({super.key, this.onTabChange});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final DashboardController dashboardController = Get.put(
    DashboardController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),

      body: Obx(() {
        if (dashboardController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(18.sp, 7.h, 18.sp, 23.sp),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
              child: Column(
                children: [
                  /// TOP BAR
                  Row(
                    children: [
                      Container(
                        width: 13.w,
                        height: 6.h,
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.white70,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Image.asset(
                          "assets/white-logo.png",
                          fit: BoxFit.contain,
                        ),
                      ),

                      SizedBox(width: 15.sp),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: "Texa Innovates",
                              color: AppColors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),

                            CommonText(
                              text: "Attendance Management",
                              color: AppColors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.normal,
                            ),
                          ],
                        ),
                      ),

                      // Container(
                      //   padding: EdgeInsets.all(10.sp),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white24,
                      //     borderRadius: BorderRadius.circular(15),
                      //   ),
                      //   child: Icon(
                      //     Icons.notifications_none,
                      //     color: Colors.white,
                      //     size: 20.sp,
                      //   ),
                      // ),
                    ],
                  ),

                  SizedBox(height: 20.sp),

                  /// ADMIN CARD
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.12),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20.w,
                          height: 7.h,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            Icons.groups_rounded,
                            color: Colors.white,
                            size: 28.sp,
                          ),
                        ),

                        SizedBox(width: 14.sp),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText(
                                text:
                                    "${dashboardController.dashboard.value?.totalEmployees ?? 0}",
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),

                              CommonText(
                                text: "Registered Employees",
                                color: AppColors.white,
                                fontSize: 13.sp,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 18.sp),

            /// TODAY STATUS CARD
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: AppColors.primary),

                        SizedBox(width: 8.sp),

                        CommonText(
                          text: "Today's Workforce Status",
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                        ),
                      ],
                    ),

                    SizedBox(height: 15.sp),

                    Row(
                      children: [
                        Expanded(
                          child: _InfoTile(
                            title: "Present",
                            value:
                                "${dashboardController.dashboard.value?.presentCount ?? 0}",
                            color: Colors.green,
                          ),
                        ),

                        SizedBox(width: 10.sp),

                        Expanded(
                          child: _InfoTile(
                            title: "Absent",
                            value:
                                "${dashboardController.dashboard.value?.leaveCount ?? 0}",
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.sp),

                    Row(
                      children: [
                        Expanded(
                          child: _InfoTile(
                            title: "Permission",
                            value:
                                "${dashboardController.dashboard.value?.permissionCount ?? 0}",
                            color: Colors.orange,
                          ),
                        ),

                        SizedBox(width: 10.sp),

                        Expanded(
                          child: _InfoTile(
                            title: "Half Day",
                            value:
                                "${dashboardController.dashboard.value?.halfDayCount ?? 0}",
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 15.sp),
            Row(
              children: [
                SizedBox(width: 17.sp),
                CommonText(
                  text: "Quick Access",
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ],
            ),
            SizedBox(height: 15.sp),

            /// QUICK ACTIONS
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.person_add_alt_1,
                      title: "Add Employee",
                      onTab: () {
                        Get.to(() => AddEmployeeScreen());
                      },
                    ),
                  ),

                  SizedBox(width: 12.sp),

                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.assignment,
                      title: "Attendance",
                      onTab: () {
                        widget.onTabChange?.call(1);
                      },
                    ),
                  ),

                  SizedBox(width: 12.sp),

                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.bar_chart,
                      title: "Reports",
                      onTab: () {
                        widget.onTabChange?.call(2);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // SizedBox(height: 22.sp),
            //
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 16.sp,
            //   ),
            //   child: Row(
            //     mainAxisAlignment:
            //     MainAxisAlignment.spaceBetween,
            //     children: [
            //
            //       CommonText(
            //         text: "Employee Summary",
            //         fontWeight: FontWeight.bold,
            //         fontSize: 15.sp,
            //       ),
            //
            //       CommonText(
            //         text: "Live Updates",
            //         color: AppColors.primary,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ],
            //   ),
            // ),
            //
            // SizedBox(height: 14.sp),
            //
            // /// GRID
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 16.sp,
            //   ),
            //   child: GridView.count(
            //     shrinkWrap: true,
            //     physics:
            //     const NeverScrollableScrollPhysics(),
            //     crossAxisCount: 2,
            //     crossAxisSpacing: 12.sp,
            //     mainAxisSpacing: 12.sp,
            //     childAspectRatio: 1.05,
            //     children: [
            //
            //       _SummaryCard(
            //         title: "Present",
            //         value: "$presentEmployees",
            //         icon: Icons.check_circle,
            //         color: Colors.green,
            //         bgColor:
            //         Colors.green.withOpacity(.1),
            //       ),
            //
            //       _SummaryCard(
            //         title: "Absent",
            //         value: "$absentEmployees",
            //         icon: Icons.cancel,
            //         color: Colors.red,
            //         bgColor:
            //         Colors.red.withOpacity(.1),
            //       ),
            //
            //       _SummaryCard(
            //         title: "Permission",
            //         value: "$permissionEmployees",
            //         icon: Icons.timelapse,
            //         color: Colors.orange,
            //         bgColor:
            //         Colors.orange.withOpacity(.1),
            //       ),
            //
            //       _SummaryCard(
            //         title: "Leave",
            //         value: "$leaveEmployees",
            //         icon: Icons.event_busy,
            //         color: Colors.blue,
            //         bgColor:
            //         Colors.blue.withOpacity(.1),
            //       ),
            //
            //       _SummaryCard(
            //         title: "Half Day",
            //         value: "$halfDayEmployees",
            //         icon: Icons.access_time,
            //         color: Colors.purple,
            //         bgColor:
            //         Colors.purple.withOpacity(.1),
            //       ),
            //
            //       _SummaryCard(
            //         title: "Late",
            //         value: "$lateEmployees",
            //         icon: Icons.pending_actions,
            //         color: Colors.deepOrange,
            //         bgColor:
            //         Colors.deepOrange.withOpacity(.1),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        );
      }),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _InfoTile({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4.sp),
          Text(title),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTab;

  const _QuickActionCard({required this.icon, required this.title, this.onTab});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 24.sp),
            SizedBox(height: 8.sp),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
