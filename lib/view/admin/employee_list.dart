import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../controller/employee_report_controller.dart';
import '../../model/employee_model.dart';
import 'package:toastification/toastification.dart';
import '../../controller/employee_list_controller.dart';
import '../../data/const/color_theme.dart';
import 'add_employee.dart';
import 'employee_rerport.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  String selectedFilter = "All";
  final EmployeeController controller = Get.put(EmployeeController());

  // List<EmployeeModel> get filteredEmployees {
  //   if (selectedFilter == "Present") {
  //     return employees.where((e) => e.isPresent).toList();
  //   }
  //
  //   if (selectedFilter == "Absent") {
  //     return employees.where((e) => !e.isPresent).toList();
  //   }
  //
  //   return employees;
  // }


  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("All Employees"),
                leading: const Icon(Icons.people),
                onTap: () {
                  setState(() {
                    selectedFilter = "All";
                  });
                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: const Text("Present"),
                leading: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                onTap: () {
                  setState(() {
                    selectedFilter = "Present";
                  });
                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: const Text("Absent"),
                leading: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                onTap: () {
                  setState(() {
                    selectedFilter = "Absent";
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
                Get.to(
                      () => const AddEmployeeScreen(),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  // horizontal: 15.sp,
                  vertical: 9.sp,
                ),
                decoration: BoxDecoration(
                  color: AppColors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_add_alt_1,
                      color: AppColors.white,
                      size: 20.sp,
                    ),

                    SizedBox(width: 5.sp),

                    // CommonText(
                    //   text: "Add Employee",
                    //   fontSize: 13.sp,
                    //   fontWeight: FontWeight.w700,
                    //   color: AppColors.primary,
                    // ),
                  ],
                ),
              ),
            ),
          ),

          IconButton(
            onPressed: _showFilterBottomSheet,
            icon:  Icon(Icons.filter_list_rounded,size: 20.sp, color: Colors.white),
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
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                onChanged: controller.searchEmployee,
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
              )
            ),
          ),

          /// LIST
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.filteredList.isEmpty) {
                return const Center(
                  child: Text("No Employees Found"),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.getEmployees,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.sp,
                  ),
                  itemCount: controller.filteredList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: 14.sp,
                      ),
                      child: _EmployeeCard(
                        employee:
                        controller.filteredList[index],
                      ),
                    );
                  },
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}

/// =====================================================
/// EMPLOYEE CARD
/// =====================================================

class _EmployeeCard extends StatefulWidget {
  final EmployeeModel employee;
  const _EmployeeCard({required this.employee});

  @override
  State<_EmployeeCard> createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<_EmployeeCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!Get.isRegistered<EmployeeReportController>()) {
          Get.put(EmployeeReportController());
        }

        Get.to(
              () => EmployeeReportScreen(
            employeeId: widget.employee.employeeId,
          ),
        );
      },
      child: CommonCard(
        padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 14.sp),
        borderRadius: 18,
        child: SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// PROFILE IMAGE
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    widget.employee.image,
                    fit: BoxFit.cover,
                    loadingBuilder:
                        (context, child, progress) {
                      if (progress == null) return child;

                      return const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      );
                    },
                    errorBuilder:
                        (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient:
                          AppColors.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                      );
                    },
                  ),
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
                      text: widget.employee.name,
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
                        text: widget.employee.role,
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
                            text: widget.employee.phone,
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
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,

                onSelected: (value) {
                  switch (value) {
                    case "edit":
                      Get.to(
                            () => AddEmployeeScreen(
                          isEdit: true,
                          employee: widget.employee,
                        ),
                      );
                      break;

                    case "delete":
                      _showDeleteDialog(context);
                      break;
                  }
                },

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
                  PopupMenuItem<String>(
                    value: "edit",
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          color: AppColors.primary,
                          size: 17.sp,
                        ),

                        SizedBox(width: 8.sp),

                        const Text("Edit"),
                      ],
                    ),
                  ),

                  PopupMenuItem<String>(
                    value: "delete",
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: AppColors.danger,
                          size: 17.sp,
                        ),

                        SizedBox(width: 8.sp),

                        Text("Delete", style: TextStyle(color: AppColors.danger)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        title: const Text("Delete Employee"),

        content: const Text("Are you sure you want to delete this employee?"),

        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("Cancel"),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () async {
              Get.back();

              final controller =
              Get.find<EmployeeController>();

              final success =
              await controller.deleteEmployee(
                widget.employee.employeeId,
              );

              if (success) {
                toastification.show(
                  context: context,
                  title: const Text(
                    "Employee Deleted Successfully",
                  ),
                  autoCloseDuration:
                  const Duration(seconds: 3),
                );
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
