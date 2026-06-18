import 'package:attandance_app/model/e_leave_request_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../controller/leave_controller.dart';
import '../../data/const/color_theme.dart';
import '../../data/local_storage/stroage_services.dart';

class LeaveRequestScreen extends StatelessWidget {
  const LeaveRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<LeaveController>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CommonAppBar(
          title: 'Leave Request',
          showBack: false,
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.grey,
            tabs: [
              Tab(text: 'New Request'),
              Tab(text: 'My Requests'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _NewRequestTab(ctrl: ctrl),
            _MyRequestsTab(ctrl: ctrl),
          ],
        ),
      ),
    );
  }
}

class _NewRequestTab extends StatefulWidget {
  const _NewRequestTab({required this.ctrl});
  final LeaveController ctrl;

  @override
  State<_NewRequestTab> createState() => _NewRequestTabState();
}

class _NewRequestTabState extends State<_NewRequestTab> {
  String name = "";

  @override
  void initState() {
    loadUser();
    super.initState();
  }

  Future<void> loadUser() async {
    name = await StorageService.getName() ?? "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.ctrl.formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          children: [
            CommonCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.sp,
                      vertical: 12.sp,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 12.sp),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Employee"),
                              Text(
                                name.toString(),
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _Divider(),

                  _LeaveTypeField(ctrl: widget.ctrl),
                  _Divider(),

                  _DateRangeField(ctrl: widget.ctrl),
                  _Divider(),

                  Padding(
                    padding: EdgeInsets.all(16.sp),
                    child: CommonTextFormField(
                      hintText: 'Describe the reason for your leave…',
                      controller: widget.ctrl.reasonController,
                      maxLines: 5,
                      validator: (v) =>
                          v!.isEmpty ? 'Reason is required' : null,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.sp),
            Obx(
              () => CommonButton(
                label: 'Send Leave Request',
                isLoading: widget.ctrl.isSubmitting.value,
                onPressed: () => widget.ctrl.submitLeave(),
                icon: const Icon(
                  Icons.send_rounded,
                  color: AppColors.white,
                  size: 18,
                ),
              ),
            ),

            SizedBox(height: 8.sp),
            CommonButton(
              label: 'Clear Form',
              outlined: true,
              onPressed: () {
                widget.ctrl.formKey.currentState?.reset();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LeaveTypeField extends StatelessWidget {
  const _LeaveTypeField({required this.ctrl});
  final LeaveController ctrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.category_outlined,
              size: 18,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 12.sp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: 'Leave Type',
                  fontSize: 12,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 4.sp),
                Obx(
                  () => DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: ctrl.leaveType.value,
                      isDense: true,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.grey,
                      ),
                      items: ctrl.leaveTypes
                          .map(
                            (t) => DropdownMenuItem(
                              value: t,
                              child: CommonText(text: t, fontSize: 15),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) ctrl.leaveType.value = v;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateRangeField extends StatelessWidget {
  const _DateRangeField({required this.ctrl});
  final LeaveController ctrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.date_range_outlined,
              size: 18,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 12.sp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: 'Date Range',
                  fontSize: 12,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 8.sp),
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => _DateChip(
                          label: ctrl.fromDateLabel,
                          onTap: () => ctrl.pickFromDate(context),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CommonText(
                        text: '→',
                        fontSize: 16,
                        color: AppColors.grey,
                      ),
                    ),
                    Expanded(
                      child: Obx(
                        () => _DateChip(
                          label: ctrl.toDateLabel,
                          onTap: () => ctrl.pickToDate(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: CommonText(
          text: label,
          fontSize: 12,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Divider(
    height: 1,
    color: AppColors.border,
    indent: 16,
    endIndent: 16,
  );
}

class _MyRequestsTab extends StatelessWidget {
  const _MyRequestsTab({required this.ctrl});

  final LeaveController ctrl;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return RefreshIndicator(
        onRefresh: ctrl.refreshLeaves,

        child: ctrl.isLoading.value
            ? ListView(
                children: const [
                  SizedBox(height: 300),
                  Center(child: CircularProgressIndicator()),
                ],
              )
            : ctrl.myLeaves.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 300),
                  Center(
                    child: CommonText(
                      text: 'No leave requests yet',
                      fontSize: 15,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              )
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.sp),
                itemCount: ctrl.myLeaves.length,
                itemBuilder: (_, i) {
                  final leave = ctrl.myLeaves[i];
                  return _LeaveCard(leave: leave);
                },
              ),
      );
    });
  }
}

class _LeaveCard extends StatelessWidget {
  const _LeaveCard({required this.leave});
  final LeaveRequestModel leave;

  Color get _statusColor {
    switch (leave.status) {
      case 'APPROVED':
        return AppColors.success;
      case 'REJECTED':
        return AppColors.danger;
      default:
        return AppColors.warning;
    }
  }

  Color get _statusBg {
    switch (leave.status) {
      case 'APPROVED':
        return AppColors.success;
      case 'REJECTED':
        return AppColors.danger;
      default:
        return AppColors.halfBg;
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = leave.toDate.difference(leave.fromDate).inDays + 1;
    return CommonCard(
      margin: EdgeInsets.only(bottom: 12.sp),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: _statusColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(width: 14.sp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CommonText(
                        text: leave.leaveType,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.sp,
                        vertical: 8.sp,
                      ),
                      decoration: BoxDecoration(
                        color: _statusBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CommonText(
                        text: leave.status
                            .toUpperCase()
                            .toString()
                            .capitalizeFirst!,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: _statusColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.sp),
                Row(
                  children: [
                    Expanded(
                      child: CommonText(
                        text:
                            '${_fmt(leave.fromDate)} - ${_fmt(leave.toDate)} • $days day(s)',
                        fontSize: 13,
                        color: AppColors.textSecond,
                      ),
                    ),
                    leave.status.toString().toUpperCase() == "PENDING"
                        ? GestureDetector(
                            onTap: () {
                              Get.find<LeaveController>().cancelLeave(
                                leave.leaveRequestId,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 18.sp,
                                vertical: 8.sp,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.danger,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CommonText(
                                text: "Cancel",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day} ${months[d.month - 1]}';
  }
}
