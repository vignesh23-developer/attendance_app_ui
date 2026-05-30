import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../data/const/color_theme.dart';
import 'add_employee.dart';


class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: CommonAppBar(
        title: "Employees",
        backgroundColor: AppColors.primary,
        titleColor: AppColors.white,
        showBack: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 14.sp),
            child: GestureDetector(
              onTap: () {
                Get.to(() => const AddEmployeeScreen());
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.sp,
                  vertical: 9.sp,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [

                    Icon(
                      Icons.person_add_alt_1,
                      color: AppColors.primary,
                      size: 18.sp,
                    ),

                    SizedBox(width: 5.sp),

                    CommonText(
                      text: "Add Employee",
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [

          /// SEARCH
          Padding(
            padding: EdgeInsets.all(16.sp),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: TextField(
                style: TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search employee...",
                  hintStyle: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.grey,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.greyDark,
                    size: 20.sp,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15.sp,
                  ),
                ),
              ),
            ),
          ),

          /// LIST
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 14.sp),
                  child: const _EmployeeCard(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// =====================================================
/// EMPLOYEE CARD
/// =====================================================

class _EmployeeCard extends StatelessWidget {
  const _EmployeeCard();

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      padding: EdgeInsets.symmetric(
        horizontal: 14.sp,
        vertical: 14.sp,
      ),
      borderRadius: 18,
      child: SizedBox(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            /// PROFILE IMAGE
            Container(
              width: 18.w,
              height: 18.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.person_rounded,
                color: AppColors.white,
                size: 24.sp,
              ),
            ),

            SizedBox(width: 14.sp),

            /// DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  /// NAME
                  CommonText(
                    text: "John Doe",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    maxLines: 1,
                  ),

                  SizedBox(height: 5.sp),

                  /// ROLE
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.sp,
                      vertical: 4.sp,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CommonText(
                      text: "Senior Developer",
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),

                  SizedBox(height: 8.sp),

                  /// PHONE
                  Row(
                    children: [

                      Icon(
                        Icons.phone_outlined,
                        size: 16.sp,
                        color: AppColors.greyDark,
                      ),

                      SizedBox(width: 5.sp),

                      Expanded(
                        child: CommonText(
                          text: "+91 9876543210",
                          fontSize: 14.sp,
                          color: AppColors.greyDark,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: 5.sp),

            /// MENU
            PopupMenuButton(
              padding: EdgeInsets.zero,
              icon: Container(
                padding: EdgeInsets.all(6.sp),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.greyDark,
                  size: 18.sp,
                ),
              ),
              itemBuilder: (context) => [

                PopupMenuItem(
                  child: CommonText(
                    text: "Edit",
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                  ),
                ),

                PopupMenuItem(
                  child: CommonText(
                    text: "Delete",
                    fontSize: 14.sp,
                    color: AppColors.danger,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
