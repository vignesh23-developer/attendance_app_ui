import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../data/const/color_theme.dart';

class AddEmployeeScreen extends StatelessWidget {
  const AddEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final TextEditingController nameController =
    TextEditingController();

    final TextEditingController roleController =
    TextEditingController();

    final TextEditingController emailController =
    TextEditingController();

    final TextEditingController passwordController =
    TextEditingController();

    final TextEditingController phoneController =
    TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: CommonAppBar(
        title: "Add Employee",
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

                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: AppColors.white,
                      size: 50.sp,
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 38,
                      height: 38,
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
                ],
              ),
            ),

            SizedBox(height: 10.sp),

            CommonText(
              text: "Add Profile Image",
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),

            SizedBox(height: 24.sp),

            /// FORM CARD
            CommonCard(
              child: Column(
                children: [

                  _FieldTitle(title: "Employee Name"),

                  SizedBox(height: 8.sp),

                  CommonTextFormField(
                    controller: nameController,
                    hintText: "Enter employee name",
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                  ),

                  SizedBox(height: 18.sp),

                  _FieldTitle(title: "Role"),

                  SizedBox(height: 8.sp),

                  CommonTextFormField(
                    controller: roleController,
                    hintText: "Enter employee role",
                    prefixIcon: Icon(
                      Icons.work_outline_rounded,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                  ),

                  SizedBox(height: 18.sp),

                  _FieldTitle(title: "Email"),

                  SizedBox(height: 8.sp),

                  CommonTextFormField(
                    controller: emailController,
                    hintText: "Enter employee email",
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                  ),

                  SizedBox(height: 18.sp),

                  _FieldTitle(title: "Password"),

                  SizedBox(height: 8.sp),

                  CommonTextFormField(
                    controller: passwordController,
                    hintText: "Enter password",
                    obscureText: true,
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                  ),

                  SizedBox(height: 18.sp),

                  _FieldTitle(title: "Contact Number"),

                  SizedBox(height: 8.sp),

                  CommonTextFormField(
                    controller: phoneController,
                    hintText: "Enter contact number",
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icon(
                      Icons.phone_outlined,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                  ),

                  SizedBox(height: 28.sp),

                  CommonButton(
                    label: "Save Employee",
                    icon: const Icon(
                      Icons.check_circle_outline_rounded,
                      color: AppColors.white,
                    ),
                    onPressed: () {},
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
  const _FieldTitle({
    required this.title,
  });

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