import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:sizer/sizer.dart';

import '../../data/const/color_theme.dart';
import '../../data/local_storage/stroage_services.dart';
import '../../routes/app_pages.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  String name = "";
  String role = "";
  String email = "";
  String image = "";

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    name = await StorageService.getName() ?? "";
    role = await StorageService.getRoleName() ?? "";
    email = await StorageService.getEmail() ?? "";
    image = await StorageService.getImage() ?? "";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primary,
        title: const Text(
          "Admin Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          children: [
            /// PROFILE CARD
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.sp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 25.sp,
                    backgroundImage:
                    image.isNotEmpty ? NetworkImage(image) : null,
                    child: image.isEmpty
                        ? Icon(
                      Icons.admin_panel_settings_rounded,
                      size: 30.sp,
                      color: AppColors.primary,
                    )
                        : null,
                  ),

                  SizedBox(height: 12.sp),

                  Text(
                    name.isEmpty ? "Admin User" : name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 4.sp),

                  Text(
                    "System Administrator",
                    style: TextStyle(color: Colors.grey, fontSize: 15.sp),
                  ),

                  SizedBox(height: 16.sp),

                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.sp,
                      vertical: 8.sp,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      name,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.sp),

            /// DETAILS
            _ProfileTile(
              icon: Icons.email_outlined,
              title: "Email",
              value: email,
            ),

            // _ProfileTile(
            //   icon: Icons.phone_outlined,
            //   title: "Phone",
            //   value: "+91 9876543210",
            // ),

            _ProfileTile(
              icon: Icons.business_outlined,
              title: "Company",
              value: name,
            ),

            _ProfileTile(
              icon: Icons.badge_outlined,
              title: "Administrator",
              value: role.isEmpty ? "Administrator" : role.toUpperCase(),
            ),

            SizedBox(height: 20.sp),

            /// LOGOUT BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () async {
                  Get.back();
                  await StorageService.logout();
                  Get.offAllNamed(AppRoutes.selectRole);
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.sp),
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),

          SizedBox(width: 12.sp),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey)),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
