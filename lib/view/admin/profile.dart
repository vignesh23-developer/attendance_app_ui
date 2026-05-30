import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../data/const/color_theme.dart';

class AttendanceProfileScreen extends StatelessWidget {
  const AttendanceProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: CommonAppBar(
        title: "Admin Panel",
        showBack: false,
        backgroundColor: AppColors.primary,
        titleColor: AppColors.white,
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.only(right: 14.sp),
        //     child: Icon(
        //       Icons.notifications_none_rounded,
        //       color: AppColors.white,
        //       size: 22.sp,
        //     ),
        //   ),
        // ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(height: 18.sp),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: const _TodayAttendanceCard(),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.sp,
                vertical: 16.sp,
              ),
              child: Row(
                children: const [
                  Expanded(
                    child: _StatCard(
                      title: "Present",
                      value: "24",
                      icon: Icons.check_circle_rounded,
                      bgColor: AppColors.presentBg,
                      iconColor: AppColors.presentFg,
                    ),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: _StatCard(
                      title: "Absent",
                      value: "02",
                      icon: Icons.cancel_rounded,
                      bgColor: AppColors.absentBg,
                      iconColor: AppColors.absentFg,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: Row(
                children: const [
                  Expanded(
                    child: _StatCard(
                      title: "Half Day",
                      value: "01",
                      icon: Icons.timelapse_rounded,
                      bgColor: AppColors.halfBg,
                      iconColor: AppColors.halfFg,
                    ),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: _StatCard(
                      title: "Leaves",
                      value: "03",
                      icon: Icons.beach_access_rounded,
                      bgColor: AppColors.leaveBg,
                      iconColor: AppColors.leaveFg,
                    ),
                  ),
                ],
              ),
            ),


            const _SectionTitle(
              title: "Attendance Summary",
              action: "View All",
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: const _AttendanceSummaryCard(),
            ),

            const _SectionTitle(
              title: "Recent Activity",
              action: "See More",
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: Column(
                children: const [
                  _ActivityTile(
                    title: "Checked In",
                    subtitle: "Today - 09:02 AM",
                    icon: Icons.login_rounded,
                    iconColor: AppColors.success,
                  ),

                  SizedBox(height: 12),

                  _ActivityTile(
                    title: "Checked Out",
                    subtitle: "Yesterday - 06:14 PM",
                    icon: Icons.logout_rounded,
                    iconColor: AppColors.danger,
                  ),

                  SizedBox(height: 12),

                  _ActivityTile(
                    title: "Half Day Applied",
                    subtitle: "20 May 2026",
                    icon: Icons.pending_actions_rounded,
                    iconColor: AppColors.warning,
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.sp),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.sp),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(
            top: BorderSide(color: AppColors.border),
          ),
        ),
        child: CommonButton(
          label: "Check Out",
          icon: const Icon(
            Icons.logout_rounded,
            color: AppColors.white,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}

class _TodayAttendanceCard extends StatefulWidget {
  const _TodayAttendanceCard();

  @override
  State<_TodayAttendanceCard> createState() => _TodayAttendanceCardState();
}

class _TodayAttendanceCardState extends State<_TodayAttendanceCard> {
  @override
  Widget build(BuildContext context) {
    return CommonCard(
      child: Row(
        children: [

          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.presentBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.verified_rounded,
              color: AppColors.presentFg,
            ),
          ),

          SizedBox(width: 14.sp),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [

                CommonText(
                  text: "Today's Status",
                  fontSize: 12,
                  color: AppColors.grey,
                ),

                SizedBox(height: 4),

                CommonText(
                  text: "Present",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.presentFg,
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.sp,
              vertical: 7.sp,
            ),
            decoration: BoxDecoration(
              color: AppColors.presentBg,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const CommonText(
              text: "On Time",
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.presentFg,
            ),
          ),
        ],
      ),
    );
  }
}


class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),

          SizedBox(height: 14.sp),

          CommonText(
            text: value,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),

          SizedBox(height: 2.sp),

          CommonText(
            text: title,
            fontSize: 12,
            color: AppColors.greyDark,
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.action,
  });

  final String title;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.sp, 18.sp, 18.sp, 10.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          CommonText(
            text: title,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),

          GestureDetector(
            onTap: () {},
            child: CommonText(
              text: action,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceSummaryCard extends StatelessWidget {
  const _AttendanceSummaryCard();

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      child: Column(
        children: const [

          _SummaryRow(
            label: "Total Working Days",
            value: "30 Days",
          ),

          Divider(color: AppColors.border),

          _SummaryRow(
            label: "Average Login Time",
            value: "09:05 AM",
          ),

          Divider(color: AppColors.border),

          _SummaryRow(
            label: "Average Working Hours",
            value: "08h 12m",
          ),

          Divider(color: AppColors.border),

          _SummaryRow(
            label: "Late Entries",
            value: "02",
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          CommonText(
            text: label,
            fontSize: 13,
            color: AppColors.textSecond,
          ),

          CommonText(
            text: value,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      child: Row(
        children: [

          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),

          SizedBox(width: 14.sp),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                CommonText(
                  text: title,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),

                SizedBox(height: 3.sp),

                CommonText(
                  text: subtitle,
                  fontSize: 11,
                  color: AppColors.greyDark,
                ),
              ],
            ),
          ),

          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14.sp,
            color: AppColors.grey,
          ),
        ],
      ),
    );
  }
}