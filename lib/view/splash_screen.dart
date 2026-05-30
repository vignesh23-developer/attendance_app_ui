import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../data/const/color_theme.dart';
import 'auth_file/role_selection.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterSplashScreen.scale(
        backgroundColor: AppColors.white,
        duration: const Duration(seconds: 3),
        animationDuration: const Duration(seconds: 3),

        nextScreen: const SelectRole(),

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