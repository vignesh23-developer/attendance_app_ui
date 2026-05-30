import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../controller/leave_controller.dart';
import '../../data/const/color_theme.dart';

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

// ══════════════════════════════════════════════
// New Request — Email Composer UI
// ══════════════════════════════════════════════
class _NewRequestTab extends StatelessWidget {
  const _NewRequestTab({required this.ctrl});
  final LeaveController ctrl;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: ctrl.formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          children: [
            // Email card
            CommonCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  // To field
                  _EmailField(
                    icon: Icons.person_outline,
                    label: 'To',
                    controller: ctrl.toController,
                    readOnly: true,
                  ),
                  _Divider(),

                  // Subject
                  _EmailField(
                    icon: Icons.subject_rounded,
                    label: 'Subject',
                    controller: ctrl.subjectController,
                    hint: 'e.g. Sick Leave Request – June 2024',
                    validator: (v) =>
                    v!.isEmpty ? 'Subject is required' : null,
                  ),
                  _Divider(),

                  // Leave type
                  _LeaveTypeField(ctrl: ctrl),
                  _Divider(),

                  // Date range
                  _DateRangeField(ctrl: ctrl),
                  _Divider(),

                  // Reason
                  Padding(
                    padding: EdgeInsets.all(16.sp),
                    child: CommonTextFormField(
                      hintText: 'Describe the reason for your leave…',
                      controller: ctrl.reasonController,
                      maxLines: 5,
                      validator: (v) =>
                      v!.isEmpty ? 'Reason is required' : null,
                    ),
                  ),

                  // Attachment
                  // _AttachmentRow(ctrl: ctrl),
                ],
              ),
            ),

            SizedBox(height: 20.sp),

            // Submit button
            Obx(() => CommonButton(

              label: 'Send Leave Request',
              isLoading: ctrl.isSubmitting.value,
              onPressed: () => ctrl.submitLeave(),
              icon: const Icon(
                Icons.send_rounded,
                color: AppColors.white,
                size: 18,
              ),
            )),

            SizedBox(height: 8.sp),
            CommonButton(
              label: 'Clear Form',
              outlined: true,
              onPressed: () {
                ctrl.formKey.currentState?.reset();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({
    required this.icon,
    required this.label,
    required this.controller,
    this.hint,
    this.readOnly = false,
    this.validator,
  });

  final IconData icon;
  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool readOnly;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          SizedBox(width: 12.sp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text:
                  label,
                  fontSize: 12,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 4.sp),
                TextFormField(
                  controller: controller,
                  readOnly: readOnly,
                  validator: validator,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
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
                CommonText(text: 'Leave Type',
                    fontSize: 12, color: AppColors.grey,
                    fontWeight: FontWeight.w500),
                SizedBox(height: 4.sp),
                Obx(() => DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: ctrl.leaveType.value,
                    isDense: true,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.grey,
                    ),
                    items: ctrl.leaveTypes
                        .map((t) => DropdownMenuItem(
                      value: t,
                      child: CommonText(text: t, fontSize: 15),
                    ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) ctrl.leaveType.value = v;
                    },
                  ),
                )),
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
                CommonText(text: 'Date Range',
                    fontSize: 12, color: AppColors.grey,
                    fontWeight: FontWeight.w500),
                SizedBox(height: 8.sp),
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => _DateChip(
                        label: ctrl.fromDateLabel,
                        onTap: () => ctrl.pickFromDate(context),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CommonText(text: '→', fontSize: 16, color: AppColors.grey),
                    ),
                    Expanded(
                      child: Obx(() => _DateChip(
                        label: ctrl.toDateLabel,
                        onTap: () => ctrl.pickToDate(context),
                      )),
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
          text:
          label,
          fontSize: 12,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// class _AttachmentRow extends StatelessWidget {
//   const _AttachmentRow({required this.ctrl});
//   final LeaveController ctrl;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(16.sp),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CommonText(
//             text:
//             'Attachment (optional)',
//             fontSize: 12,
//             color: AppColors.grey,
//             fontWeight: FontWeight.w500,
//           ),
//           SizedBox(height: 8.sp),
//           Obx(() {
//             if (ctrl.attachmentPath.value.isNotEmpty) {
//               return Row(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.file(
//                       File(ctrl.attachmentPath.value),
//                       width: 60,
//                       height: 60,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   SizedBox(width: 10.sp),
//                   Expanded(
//                     child: CommonText(
//                       text:
//                       'File selected',
//                       fontSize: 13,
//                       color: AppColors.success,
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close, color: AppColors.danger),
//                     onPressed: () => ctrl.attachmentPath.value = '',
//                   ),
//                 ],
//               );
//             }
//             return GestureDetector(
//               onTap: ctrl.pickAttachment,
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppColors.background,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: AppColors.border,
//                     style: BorderStyle.solid,
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(
//                       Icons.attach_file_rounded,
//                       color: AppColors.grey,
//                       size: 20,
//                     ),
//                     const SizedBox(width: 8),
//                     CommonText(
//                       text:
//                       'Tap to attach a file',
//                       fontSize: 14,
//                       color: AppColors.grey,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, color: AppColors.border, indent: 16, endIndent: 16);
}

// ══════════════════════════════════════════════
// My Requests Tab
// ══════════════════════════════════════════════
class _MyRequestsTab extends StatelessWidget {
  const _MyRequestsTab({required this.ctrl});
  final LeaveController ctrl;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.myLeaves.isEmpty) {
        return const Center(
          child: CommonText(
            text:
            'No leave requests yet',
            fontSize: 15,
            color: AppColors.grey,
          ),
        );
      }
      return ListView.builder(
        padding: EdgeInsets.all(16.sp),
        itemCount: ctrl.myLeaves.length,
        itemBuilder: (_, i) {
          final leave = ctrl.myLeaves[i];
          return _LeaveCard(leave: leave);
        },
      );
    });
  }
}

class _LeaveCard extends StatelessWidget {
  const _LeaveCard({required this.leave});
  final dynamic leave;

  Color get _statusColor {
    switch (leave.status) {
      case 'approved':
        return AppColors.success;
      case 'rejected':
        return AppColors.danger;
      default:
        return AppColors.warning;
    }
  }

  Color get _statusBg {
    switch (leave.status) {
      case 'approved':
        return AppColors.presentBg;
      case 'rejected':
        return AppColors.absentBg;
      default:
        return AppColors.halfBg;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        text:
                        leave.type,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 18.sp, vertical: 8.sp),
                      decoration: BoxDecoration(
                        color: _statusBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CommonText(
                        text:
                        leave.status.toString().capitalizeFirst!,
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
                        '${_fmt(leave.from)} – ${_fmt(leave.to)} • ${leave.days} day(s)',
                        fontSize: 13,
                        color: AppColors.textSecond,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){},
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 18.sp, vertical: 8.sp),
                        decoration: BoxDecoration(
                          color: AppColors.danger,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CommonText(
                          text:
                          "Cancel",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
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

  String _fmt(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${d.day} ${months[d.month - 1]}';
  }
}
