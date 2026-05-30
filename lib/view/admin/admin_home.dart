import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../data/const/color_theme.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {

  final int totalEmployees = 30;
  final int presentEmployees = 24;
  final int absentEmployees = 2;
  final int permissionEmployees = 1;
  final int leaveEmployees = 3;
  final int halfDayEmployees = 1;
  final int lateEmployees = 4;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 16.sp),

          child: Column(
            children: [

              /// =====================================================
              /// HEADER
              /// =====================================================

              Container(
                width: double.infinity,

                padding: EdgeInsets.fromLTRB(
                  16.sp,
                  16.sp,
                  16.sp,
                  20.sp,
                ),

                decoration: const BoxDecoration(
                  color: AppColors.primary,

                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(26),
                    bottomRight: Radius.circular(26),
                  ),
                ),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    CommonText(
                      text: "Admin Dashboard",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),

                    SizedBox(height: 3.sp),

                    CommonText(
                      text: "Attendance Overview",
                      fontSize: 14.sp,
                      color:
                      AppColors.white.withOpacity(0.85),
                    ),

                    SizedBox(height: 18.sp),

                    /// TOTAL EMPLOYEE CARD

                    Container(
                      width: double.infinity,

                      padding: EdgeInsets.all(14.sp),

                      decoration: BoxDecoration(
                        color:
                        AppColors.white.withOpacity(0.10),

                        borderRadius:
                        BorderRadius.circular(22),
                      ),

                      child: Row(
                        children: [

                          Container(
                            width: 14.w,
                            height: 14.w,

                            decoration: BoxDecoration(
                              color: AppColors.white
                                  .withOpacity(0.14),

                              borderRadius:
                              BorderRadius.circular(16),
                            ),

                            child: Icon(
                              Icons.groups_rounded,
                              color: AppColors.white,
                              size: 20.sp,
                            ),
                          ),

                          SizedBox(width: 12.sp),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [

                                CommonText(
                                  text:
                                  totalEmployees.toString(),
                                  fontSize: 21.sp,
                                  fontWeight:
                                  FontWeight.w700,
                                  color:
                                  AppColors.white,
                                ),

                                SizedBox(height: 2.sp),

                                CommonText(
                                  text:
                                  "Total Employees",
                                  fontSize: 14.sp,
                                  color: AppColors.white
                                      .withOpacity(0.85),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.sp,
                              vertical: 6.sp,
                            ),

                            decoration: BoxDecoration(
                              color: AppColors.success,

                              borderRadius:
                              BorderRadius.circular(12),
                            ),

                            child: CommonText(
                              text: "Live",
                              fontSize: 13.sp,
                              fontWeight:
                              FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 18.sp),

              /// =====================================================
              /// SUMMARY TITLE
              /// =====================================================

              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 16.sp),

                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

                  children: [

                    CommonText(
                      text: "Today's Summary",
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),

                    CommonText(
                      text: "Updated Now",
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 14.sp),

              /// =====================================================
              /// SUMMARY GRID
              /// =====================================================

              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 16.sp),

                child: GridView.count(
                  shrinkWrap: true,

                  physics:
                  const NeverScrollableScrollPhysics(),

                  crossAxisCount: 2,
                  crossAxisSpacing: 12.sp,
                  mainAxisSpacing: 12.sp,
                  childAspectRatio: 1.25,

                  children: [

                    _SummaryCard(
                      title: "Present",
                      value:
                      presentEmployees.toString(),
                      icon:
                      Icons.check_circle_rounded,
                      color:
                      AppColors.presentFg,
                      bgColor:
                      AppColors.presentBg,
                    ),

                    _SummaryCard(
                      title: "Absent",
                      value:
                      absentEmployees.toString(),
                      icon:
                      Icons.cancel_rounded,
                      color:
                      AppColors.absentFg,
                      bgColor:
                      AppColors.absentBg,
                    ),

                    _SummaryCard(
                      title: "Permission",
                      value:
                      permissionEmployees.toString(),
                      icon:
                      Icons.timelapse_rounded,
                      color:
                      AppColors.halfFg,
                      bgColor:
                      AppColors.halfBg,
                    ),

                    _SummaryCard(
                      title: "Leave",
                      value:
                      leaveEmployees.toString(),
                      icon:
                      Icons.event_busy_rounded,
                      color:
                      AppColors.leaveFg,
                      bgColor:
                      AppColors.leaveBg,
                    ),

                    _SummaryCard(
                      title: "Half Day",
                      value:
                      halfDayEmployees.toString(),
                      icon:
                      Icons.access_time_filled_rounded,
                      color:
                      AppColors.info,
                      bgColor:
                      AppColors.info.withOpacity(0.12),
                    ),

                    _SummaryCard(
                      title: "Late",
                      value:
                      lateEmployees.toString(),
                      icon:
                      Icons.pending_actions_rounded,
                      color:
                      AppColors.danger,
                      bgColor:
                      AppColors.danger.withOpacity(0.12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(12.sp),

      decoration: BoxDecoration(
        color: AppColors.white,

        borderRadius:
        BorderRadius.circular(20),

        border: Border.all(
          color: AppColors.border,
        ),

        boxShadow: [
          BoxShadow(
            color:
            AppColors.black.withOpacity(0.03),

            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        children: [

          /// TOP SECTION
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Container(
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  color: bgColor,

                  borderRadius:
                  BorderRadius.circular(14),
                ),

                child: Icon(
                  icon,
                  color: color,
                  size: 18.sp,
                ),
              ),

              Container(
                width: 9,
                height: 9,

                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),

          /// PUSH CONTENT TO BOTTOM
          const Spacer(),

          /// VALUE & TITLE
          Align(
            alignment: Alignment.bottomRight,

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.end,

              children: [

                CommonText(
                  text: value,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),

                SizedBox(height: 2.sp),

                CommonText(
                  text: title,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.greyDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}