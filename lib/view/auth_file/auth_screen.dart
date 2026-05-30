import 'package:attandance_app/data/const/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';

import '../../routes/app_pages.dart';

class AuthScreen extends StatefulWidget {
  final bool isAdmin;

  const AuthScreen({super.key, required this.isAdmin});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                  height: 16.h,
                  width: 34.w,

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
                    padding: const EdgeInsets.all(18),
                    child: Image.asset("assets/logo.png", fit: BoxFit.contain),
                  ),
                ),

                SizedBox(height: 4.h),

                /// TITLE
                CommonText(
                  text: isLogin ? "Welcome Back" : "Create Account",
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),

                SizedBox(height: 1.h),

                CommonText(
                  text: isLogin ? "Login to continue" : "Register your account",
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
                      if (!isLogin) ...[
                        CommonTextFormField(
                          controller: nameController,
                          hintText: "Enter Full Name",

                          prefixIcon: Icon(Icons.person_outline, size: 20.sp),
                        ),

                        SizedBox(height: 2.5.h),
                      ],

                      CommonTextFormField(
                        controller: emailController,
                        hintText: "Enter Email",

                        keyboardType: TextInputType.emailAddress,

                        prefixIcon: Icon(Icons.email_outlined, size: 20.sp),
                      ),

                      SizedBox(height: 2.5.h),

                      CommonTextFormField(
                        controller: passwordController,
                        hintText: "Enter Password",
                        obscureText: true,

                        prefixIcon: Icon(Icons.lock_outline, size: 20.sp),
                      ),

                      SizedBox(height: 4.h),

                      /// BUTTON
                      GestureDetector(
                        onTap: () {
                          if (!isLogin) {
                            nameController.clear();
                            emailController.clear();
                            passwordController.clear();

                            toastification.show(
                              autoCloseDuration: Duration(seconds: 3),
                              context: context,
                              alignment: Alignment.topCenter,
                              title: CommonText(
                                text: "Success \nRegistration Successful",
                                fontSize: 15.sp,
                                fontWeight: FontWeight.normal,
                              ),
                            );

                            setState(() {
                              isLogin = true;
                            });
                          }
                          else {
                            if (widget.isAdmin) {
                              Get.offAllNamed(AppRoutes.adminBottom);
                            } else {
                              Get.offAllNamed(AppRoutes.employeeBottom);
                            }
                          }
                        },

                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 2.h),

                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                            ),

                            borderRadius: BorderRadius.circular(18),
                          ),

                          child: Center(
                            child: CommonText(
                              text: isLogin ? "LOGIN" : "REGISTER",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 3.h),

                      /// SWITCH AUTH
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CommonText(
                            text: isLogin
                                ? "Don't have an account? "
                                : "Already have an account? ",
                            fontSize: 15.sp,
                            color: AppColors.grey,
                          ),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isLogin = !isLogin;
                              });
                            },

                            child: CommonText(
                              text: isLogin ? "Register" : "Login",
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
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
