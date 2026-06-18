import 'package:attandance_app/data/const/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sizer/sizer.dart';

import '../../data/local_storage/stroage_services.dart';
import '../../routes/app_pages.dart';

class SelectRole extends StatefulWidget {
  const SelectRole({super.key});

  @override
  State<SelectRole> createState() => _SelectRoleState();
}

class _SelectRoleState extends State<SelectRole> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 5.h),

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

              SizedBox(height: 5.h),

              CommonText(
                text: "Select Your Role",
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),

              SizedBox(height: 1.h),

              CommonText(
                text: "Choose your login access",
                fontSize: 13.sp,
                color: AppColors.grey,
              ),

              SizedBox(height: 6.h),

              GestureDetector(
                onTap: () async{
                  await StorageService.saveRole("admin");
                  Get.toNamed(AppRoutes.adminAuth);
                },

                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 2.5.h,
                  ),

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                    ),

                    borderRadius: BorderRadius.circular(22),

                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),

                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),

                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedUserAccount,
                          color: AppColors.white,
                          size: 26.sp,
                        ),
                      ),

                      SizedBox(width: 5.w),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: "Admin",
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),

                            SizedBox(height: 0.5.h),

                            CommonText(
                              text: "Manage employees & reports",
                              fontSize: 15.sp,
                              color: AppColors.white.withOpacity(0.9),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 3.h),

              GestureDetector(
                onTap: () async{
                  await StorageService.saveRole("employee");
                  Get.toNamed(AppRoutes.employeeAuth);
                },

                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 2.5.h,
                  ),

                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(22),

                    border: Border.all(
                      color: AppColors.secondary.withOpacity(0.3),
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),

                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),

                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedUser,
                          color: AppColors.secondary,
                          size: 26.sp,
                        ),
                      ),

                      SizedBox(width: 5.w),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: "Employee",
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),

                            SizedBox(height: 0.5.h),

                            CommonText(
                              text: "Track attendance & activities",
                              fontSize: 15.sp,
                              color: AppColors.grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
