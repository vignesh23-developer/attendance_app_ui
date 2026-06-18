import 'package:attandance_app/data/const/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';

import '../../controller/auth_controller.dart';
import '../../routes/app_pages.dart';

class AuthScreen extends StatefulWidget {
  final bool isAdmin;

  const AuthScreen({super.key, required this.isAdmin});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  final AuthController controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),

            child: Column(
              children: [
                SizedBox(height: 1.h),

                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },

                      child: Container(
                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),

                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 18.sp,
                          color: AppColors.black,
                        ),
                      ),
                    ),

                    SizedBox(width: 4.w),

                    CommonText(
                      text: widget.isAdmin ? "Admin Portal" : "Employee Portal",
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ],
                ),

                SizedBox(height: 5.h),

                /// LOGO
                Container(
                  height: 10.h,
                  width: 38.w,

                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: Image.asset("assets/logo.png", fit: BoxFit.cover),
                  ),
                ),

                SizedBox(height: 4.h),

                /// TITLE
                CommonText(
                  text: widget.isAdmin
                      ? (isLogin ? "Admin Login" : "Create Admin Account")
                      : "Employee Login",
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),

                SizedBox(height: 1.h),

                CommonText(
                  text: widget.isAdmin
                      ? (isLogin
                            ? "Login to continue"
                            : "Register your account")
                      : "Login with employee credentials",
                  fontSize: 15.sp,
                  color: AppColors.grey,
                ),

                SizedBox(height: 5.h),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(5.w),

                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      /// NAME FIELD

                      CommonTextFormField(
                        controller: controller.emailController,
                        hintText: "Enter Email",

                        keyboardType: TextInputType.emailAddress,

                        prefixIcon: Icon(Icons.email_outlined, size: 20.sp),
                      ),

                      SizedBox(height: 2.5.h),

                      CommonTextFormField(
                        controller: controller.passwordController,
                        hintText: "Enter Password",
                        obscureText: true,

                        prefixIcon: Icon(Icons.lock_outline, size: 20.sp),
                      ),

                      SizedBox(height: 4.h),

                      /// BUTTON
                      Obx(
                            () => CommonButton(
                          label: widget.isAdmin
                              ? "Admin Login"
                              : "Employee Login",

                          isLoading: controller.isLoading.value,

                          onPressed: () => controller.login(widget.isAdmin),

                          height: 55,
                          borderRadius: 18,

                          color: AppColors.primary,

                          icon: Icon(
                            Icons.arrow_forward_rounded,
                            color: AppColors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 5.h),

                /// FOOTER
                CommonText(
                  text: "Powered by Texa Innovates",
                  fontSize: 15.sp,
                  color: AppColors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
