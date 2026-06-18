import 'package:attandance_app/controller/employee_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../controller/history_controller.dart';
import '../../data/const/color_theme.dart';
import '../../model/attendance_model.dart';

class EmployeeReportScreen extends StatefulWidget {
  final int employeeId;

  const EmployeeReportScreen({super.key, required this.employeeId});

  @override
  State<EmployeeReportScreen> createState() => _EmployeeReportScreenState();
}

class _EmployeeReportScreenState extends State<EmployeeReportScreen> {
  final EmployeeReportController ctrl = Get.find<EmployeeReportController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctrl.getEmployeeHistory(widget.employeeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppBar(title: 'Attendance History', showBack: false),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _CalendarCard(ctrl: ctrl)),

          SliverToBoxAdapter(child: _SummaryRow(ctrl: ctrl)),

          Obx(() {
            print("Records Count = ${ctrl.records.length}");
            print("Filtered Count = ${ctrl.filtered.length}");

            if (ctrl.isLoading.value) {
              return const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final list = ctrl.filtered;

            if (list.isEmpty) {
              return const SliverToBoxAdapter(
                child: Center(child: Text("No Attendance Found")),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) =>
                    _AttendanceCard(record: list[index], isFirst: index == 0),
                childCount: list.length,
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// Summary Row
// ══════════════════════════════════════════════
class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.ctrl});
  final EmployeeReportController ctrl;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.fromLTRB(16.sp, 12.sp, 16.sp, 12.sp),
        child: Row(
          children: [
            _SummaryChip(
              label: 'Present',
              count: ctrl.presentCount,
              color: AppColors.presentFg,
              bg: AppColors.presentBg,
              isSelected: ctrl.selectedFilter.value == AttendanceStatus.present,
              onTap: () {
                ctrl.selectedFilter.value =
                    ctrl.selectedFilter.value == AttendanceStatus.present
                    ? null
                    : AttendanceStatus.present;
              },
            ),

            SizedBox(width: 8.sp),

            _SummaryChip(
              label: 'leave',
              count: ctrl.leaveCount,
              color: AppColors.absentFg,
              bg: AppColors.absentBg,
              isSelected:
                  ctrl.selectedFilter.value == AttendanceStatus.leave,
              onTap: () {
                ctrl.selectedFilter.value =
                    ctrl.selectedFilter.value == AttendanceStatus.leave
                    ? null
                    : AttendanceStatus.leave;
              },
            ),

            SizedBox(width: 8.sp),

            _SummaryChip(
              label: 'Permission',
              count: ctrl.permissionCount,
              color: AppColors.leaveFg,
              bg: AppColors.leaveBg,
              isSelected: ctrl.selectedFilter.value == AttendanceStatus.permission,
              onTap: () {
                ctrl.selectedFilter.value =
                    ctrl.selectedFilter.value == AttendanceStatus.permission
                    ? null
                    : AttendanceStatus.permission;
              },
            ),

            SizedBox(width: 8.sp),

            _SummaryChip(
              label: 'Half Day',
              count: ctrl.halfDayCount,
              color: AppColors.halfFg,
              bg: AppColors.halfBg,
              isSelected: ctrl.selectedFilter.value == AttendanceStatus.halfDay,
              onTap: () {
                ctrl.selectedFilter.value =
                    ctrl.selectedFilter.value == AttendanceStatus.halfDay
                    ? null
                    : AttendanceStatus.halfDay;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    super.key,
    required this.label,
    required this.count,
    required this.color,
    required this.bg,
    required this.onTap,
    required this.isSelected,
  });

  final String label;
  final int count;
  final Color color;
  final Color bg;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(color: color, width: 2) : null,
          ),
          child: Column(
            children: [
              CommonText(
                text: '$count',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
              const SizedBox(height: 2),
              CommonText(text: label, fontSize: 11, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// Calendar Card
// ══════════════════════════════════════════════
class _CalendarCard extends StatelessWidget {
  const _CalendarCard({required this.ctrl});
  final EmployeeReportController ctrl;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final month = ctrl.selectedMonth.value;
      final firstDay = DateTime(month.year, month.month, 1);
      final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
      final startWeekday = firstDay.weekday % 7; // 0=Sun

      return CommonCard(
        margin: EdgeInsets.all(16.sp),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                  text: DateFormat('MMMM yyyy').format(month),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                Row(
                  children: [
                    _CalArrow(
                      icon: Icons.chevron_left,
                      onTap: ctrl.goToPrevMonth,
                    ),
                    const SizedBox(width: 4),
                    _CalArrow(
                      icon: Icons.chevron_right,
                      onTap: ctrl.goToNextMonth,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.sp),

            // Day labels
            Row(
              children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                  .map(
                    (d) => Expanded(
                      child: CommonText(
                        text: d,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 8.sp),

            // Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemCount: startWeekday + daysInMonth,
              itemBuilder: (_, i) {
                if (i < startWeekday) return const SizedBox();
                final day = i - startWeekday + 1;
                final date = DateTime(month.year, month.month, day);
                final status = ctrl.statusForDay(date);
                final isToday = _isToday(date);

                return _CalDay(
                  day: day,
                  status: status,
                  isToday: isToday,
                  onTap: () {
                    if (ctrl.selectedDay.value != null &&
                        ctrl.selectedDay.value!.year == date.year &&
                        ctrl.selectedDay.value!.month == date.month &&
                        ctrl.selectedDay.value!.day == date.day) {
                      ctrl.selectedDay.value = null;
                    } else {
                      ctrl.selectedDay.value = date;
                    }
                  },
                );
              },
            ),
          ],
        ),
      );
    });
  }

  bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }
}

class _CalArrow extends StatelessWidget {
  const _CalArrow({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: AppColors.textPrimary),
      ),
    );
  }
}

class _CalDay extends StatelessWidget {
  const _CalDay({
    required this.day,
    required this.status,
    required this.isToday,
    required this.onTap,
  });
  final int day;
  final AttendanceStatus? status;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color? dotColor;
    if (status != null) {
      final dummy = AttendanceRecord(date: DateTime.now(), status: status!);
      dotColor = dummy.statusColor;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isToday ? AppColors.primary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CommonText(
              text: '$day',
              fontSize: 13,
              fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
              color: isToday ? AppColors.white : AppColors.textPrimary,
            ),
            if (dotColor != null && !isToday)
              Positioned(
                bottom: 4,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// Search Bar
// ══════════════════════════════════════════════
class _SearchBar extends StatefulWidget {
  const _SearchBar({required this.ctrl});
  final AttendanceController ctrl;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _searchControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 4.sp),
      child: CommonTextFormField(
        hintText: 'Search by status or date…',
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.grey),
        onChanged: (v) => widget.ctrl.searchQuery.value = v,
        controller: _searchControler,
      ),
    );
  }
}

// ══════════════════════════════════════════════
// Attendance Card
// ══════════════════════════════════════════════
class _AttendanceCard extends StatelessWidget {
  const _AttendanceCard({required this.record, required this.isFirst});
  final AttendanceRecord record;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      margin: EdgeInsets.only(bottom: 10.sp),
      child: Row(
        children: [
          // Date block
          Container(
            width: 52,
            height: 60,
            decoration: BoxDecoration(
              color: record.statusBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonText(
                  text: DateFormat('dd').format(record.date),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: record.statusColor,
                ),
                CommonText(
                  text: DateFormat('EEE').format(record.date).toUpperCase(),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: record.statusColor,
                ),
              ],
            ),
          ),
          SizedBox(width: 14.sp),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CommonText(
                        text: DateFormat('dd MMMM yyyy').format(record.date),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    _StatusBadge(record: record),
                  ],
                ),
                SizedBox(height: 6.sp),
                if (record.checkIn != null)
                  Row(
                    children: [
                      _TimeInfo(
                        icon: Icons.login_rounded,
                        label: 'In',
                        time: DateFormat('hh:mm a').format(record.checkIn!),
                        color: AppColors.success,
                      ),
                      SizedBox(width: 16.sp),
                      _TimeInfo(
                        icon: Icons.logout_rounded,
                        label: 'Out',
                        time: record.checkOut != null
                            ? DateFormat('hh:mm a').format(record.checkOut!)
                            : '--:--',
                        color: AppColors.danger,
                      ),
                      SizedBox(width: 16.sp),
                      _TimeInfo(
                        icon: Icons.access_time_rounded,
                        label: 'Hours',
                        time: record.totalHours ?? '--:--',
                        color: AppColors.primary,
                      ),
                    ],
                  )
                else
                  CommonText(
                    text: 'No attendance recorded',
                    fontSize: 13,
                    color: AppColors.grey,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeInfo extends StatelessWidget {
  const _TimeInfo({
    required this.icon,
    required this.label,
    required this.time,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String time;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 3),
            CommonText(text: label, fontSize: 11, color: AppColors.grey),
          ],
        ),
        const SizedBox(height: 2),
        CommonText(
          text: time,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.record});
  final AttendanceRecord record;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: record.statusBgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CommonText(
        text: record.statusLabel,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: record.statusColor,
      ),
    );
  }
}
