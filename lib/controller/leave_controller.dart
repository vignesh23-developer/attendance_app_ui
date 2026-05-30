import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../model/attendance_model.dart';

class LeaveController extends GetxController {
  final formKey             = GlobalKey<FormState>();
  final toController        = TextEditingController();
  final subjectController   = TextEditingController();
  final reasonController    = TextEditingController();

  final RxString leaveType       = 'Sick Leave'.obs;
  final Rx<DateTime?> fromDate   = Rx(null);
  final Rx<DateTime?> toDate     = Rx(null);
  final RxString attachmentPath  = ''.obs;
  final RxBool isSubmitting      = false.obs;

  final List<String> leaveTypes = [
    'Sick Leave',
    'Casual Leave',
    'Personal Leave',
  ];

  final RxList<LeaveRequest> myLeaves = <LeaveRequest>[].obs;

  @override
  void onInit() {
    super.onInit();
    toController.text = 'hr@Texa.com';
    _loadDummyLeaves();
  }

  void _loadDummyLeaves() {
    myLeaves.value = [
      LeaveRequest(
        id: 'LV001',
        type: 'Sick Leave',
        from: DateTime.now().subtract(const Duration(days: 10)),
        to: DateTime.now().subtract(const Duration(days: 8)),
        reason: 'Fever and cold',
        status: 'approved',
      ),
      LeaveRequest(
        id: 'LV002',
        type: 'Casual Leave',
        from: DateTime.now().add(const Duration(days: 5)),
        to: DateTime.now().add(const Duration(days: 6)),
        reason: 'Personal work',
        status: 'pending',
      ),
    ];
  }

  String get fromDateLabel =>
      fromDate.value != null ? DateFormat('dd MMM yyyy').format(fromDate.value!) : 'Select date';

  String get toDateLabel =>
      toDate.value != null ? DateFormat('dd MMM yyyy').format(toDate.value!) : 'Select date';

  Future<void> pickFromDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: fromDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF730323)),
        ),
        child: child!,
      ),
    );
    if (date != null) {
      fromDate.value = date;
      if (toDate.value != null && toDate.value!.isBefore(date)) {
        toDate.value = date;
      }
    }
  }

  Future<void> pickToDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: toDate.value ?? (fromDate.value ?? DateTime.now()),
      firstDate: fromDate.value ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF730323)),
        ),
        child: child!,
      ),
    );
    if (date != null) toDate.value = date;
  }

  Future<void> pickAttachment() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) attachmentPath.value = file.path;
  }

  Future<void> submitLeave() async {
    if (!formKey.currentState!.validate()) return;
    if (fromDate.value == null || toDate.value == null) {
      Get.snackbar('Missing Info', 'Please select leave dates.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFDC2626),
          colorText: Colors.white);
      return;
    }

    isSubmitting.value = true;
    await Future.delayed(const Duration(seconds: 1));

    myLeaves.add(LeaveRequest(
      id: 'LV${myLeaves.length + 1}',
      type: leaveType.value,
      from: fromDate.value!,
      to: toDate.value!,
      reason: reasonController.text,
      status: 'pending',
      subject: subjectController.text,
    ));

    _resetForm();
    isSubmitting.value = false;

    Get.snackbar(
      '✅ Request Sent',
      'Your leave request has been submitted.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF16A34A),
      colorText: Colors.white,
    );
  }

  void _resetForm() {
    subjectController.clear();
    reasonController.clear();
    fromDate.value = null;
    toDate.value = null;
    attachmentPath.value = '';
    leaveType.value = 'Sick Leave';
  }

  @override
  void onClose() {
    toController.dispose();
    subjectController.dispose();
    reasonController.dispose();
    super.onClose();
  }
}
