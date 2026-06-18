import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../data/const/color_theme.dart';
import '../data/local_storage/stroage_services.dart';
import '../routes/app_pages.dart';
import 'auth_file/role_selection.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<void> checkLogin() async {
    String? token = await StorageService.getToken();
    String? role = await StorageService.getRole();
    int? loginId = await StorageService.getLoginId();

    print("TOKEN => $token");
    print("ROLE => $role");
    print("LOGIN ID => $loginId");

    await Future.delayed(const Duration(seconds: 3));

    // Admin Check
    if (role == "admin" &&
        token != null &&
        token.isNotEmpty) {
      Get.offAllNamed(AppRoutes.adminBottom);
      return;
    }

    // Employee Check
    if (role == "employee" &&
        loginId != null &&
        loginId > 0) {
      Get.offAllNamed(AppRoutes.employeeBottom);
      return;
    }

    Get.offAll(const SelectRole());
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterSplashScreen.scale(
        backgroundColor: AppColors.white,
        duration: const Duration(seconds: 3),
        animationDuration: const Duration(seconds: 3),

        nextScreen: const SizedBox(),

        childWidget: SizedBox(
          height: 20.h,
          width: 40.w,
          child: Image.asset(
            "assets/logo.png",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}