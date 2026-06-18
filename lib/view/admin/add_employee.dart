import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sizer/sizer.dart';
import '../../controller/add_employee_controller.dart';
import '../../controller/employee_list_controller.dart';
import '../../data/const/color_theme.dart';
import '../../model/employee_model.dart';

class AddEmployeeScreen extends StatefulWidget {
  final bool isEdit;
  final EmployeeModel? employee;

  const AddEmployeeScreen({super.key, this.isEdit = false, this.employee});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.isEdit && widget.employee != null) {
      controller.nameController.text = widget.employee!.name;

      controller.roleController.text = widget.employee!.role;

      controller.phoneController.text = widget.employee!.phone;
    }
  }

  final AddEmployeeController controller = Get.put(AddEmployeeController());
  final EmployeeController employeeController = Get.put(EmployeeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: CommonAppBar(
        title: widget.isEdit ? "Edit Employee" : "Add Employee",
        backgroundColor: AppColors.primary,
        titleColor: AppColors.white,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          children: [
            /// PROFILE IMAGE
            Center(
              child: Stack(
                children: [
                  Obx(
                    () => Center(
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: controller.pickImage,
                            child: Container(
                              width: 30.w,
                              height: 12.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppColors.primaryGradient,
                              ),
                              child: controller.profileImage.value != null
                                  ? ClipOval(
                                      child: Image.file(
                                        controller.profileImage.value!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(
                                      Icons.person_rounded,
                                      color: AppColors.white,
                                      size: 30.sp,
                                    ),
                            ),
                          ),

                          Positioned(
                            top: 0,
                            bottom: -70,
                            right: 0,
                            child: GestureDetector(
                              onTap: controller.pickImage,
                              child: Container(
                                width: 10.w,
                                height: 10.h,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  color: AppColors.primary,
                                  size: 18.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            CommonText(
              text: "Add Profile Image",
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
            SizedBox(height: 3.h),
            CommonCard(
              child: Column(
                children: [
                  _FieldTitle(title: "Employee Name"),

                  SizedBox(height: 5.sp),

                  CommonTextFormField(
                    controller: controller.nameController,
                    hintText: "Enter employee name",
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                  ),

                  SizedBox(height: 10.sp),

                  _FieldTitle(title: "Role"),

                  SizedBox(height: 5.sp),

                  CommonTextFormField(
                    controller: controller.roleController,
                    hintText: "Enter employee role",
                    prefixIcon: Icon(
                      Icons.work_outline_rounded,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                  ),

                  SizedBox(height: 10.sp),

                  _FieldTitle(title: "Email"),

                  SizedBox(height: 5.sp),

                  CommonTextFormField(
                    controller: controller.emailController,
                    hintText: "Enter employee email",
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                  ),

                  SizedBox(height: 10.sp),

                  _FieldTitle(title: "Password"),

                  SizedBox(height: 5.sp),

                  CommonTextFormField(
                    controller: controller.passwordController,
                    hintText: "Enter password",
                    obscureText: true,
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                  ),

                  SizedBox(height: 10.sp),

                  _FieldTitle(title: "Contact Number"),

                  SizedBox(height: 5.sp),

                  CommonTextFormField(
                    controller: controller.phoneController,
                    hintText: "Enter contact number",
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icon(
                      Icons.phone_outlined,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                  ),

                  SizedBox(height: 20.sp),

                  Obx(
                    () => CommonButton(
                      label: controller.isLoading.value
                          ? "Please Wait..."
                          : widget.isEdit
                          ? "Update Employee"
                          : "Save Employee",
                      icon: const Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppColors.white,
                      ),

                      onPressed: controller.isLoading.value
                          ? null
                          : () async {
                              if (widget.isEdit) {
                                await employeeController.updateEmployee(
                                  employeeId: widget.employee!.employeeId,
                                  name: controller.nameController.text.trim(),
                                  role: controller.roleController.text.trim(),
                                  number: controller.phoneController.text.trim(),
                                );
                              } else {
                                await controller.registerEmployee();
                              }
                            },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldTitle extends StatelessWidget {
  const _FieldTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: CommonText(
        text: title,
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}
