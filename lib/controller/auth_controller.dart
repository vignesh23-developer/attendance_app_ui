import 'package:attandance_app/data/const/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import '../../../routes/app_pages.dart';
import '../data/const/api.dart';
import '../data/local_storage/stroage_services.dart';

class AuthController extends GetxController {
  final ApiService apiService = ApiService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isLoading = false.obs;

  Future<void> login(bool isAdmin) async {
    try {
      isLoading.value = true;

      final endpoint = isAdmin ? Api.adminLogin : Api.employeeLogin;

      final response = await apiService.postRequest(endpoint, {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      });

      if (response.statusCode == 200 &&
          response.data["success"] == true) {

        print("Login Response: ${response.data}");
        print("Login Data: ${emailController.text.trim()} - ${passwordController.text.trim()}");
        print("Before Save");

        if (isAdmin) {
          final adminData = response.data["data"];

          await StorageService.saveToken(
            adminData["token"] ?? "",
          );

          await StorageService.saveRole("admin");

          await StorageService.saveUserData(
            name: adminData["name"] ?? "",
            role: adminData["role"] ?? "",
            image: adminData["image"],
            loginId: 0,
            email: adminData["email"] ?? "",
          );

          Get.offAllNamed(AppRoutes.adminBottom);
          return;
        }

        await StorageService.saveRole("employee");

        print("After Save");

        final userData = response.data["data"];
        if (userData != null) {
          await StorageService.saveUserData(
            name: userData["name"] ?? "",
            role: userData["role"] ?? "",
            image: userData["image"],
            loginId: userData["loginId"] ?? 0,
            number: userData["number"] ?? "",
            email: userData["email"] ?? "",
          );
        }

        if (isAdmin) {
          print("Going Admin Dashboard");
          Get.offAllNamed(AppRoutes.adminBottom);
        } else {
          print("Going Employee Dashboard");
          Get.offAllNamed(AppRoutes.employeeBottom);
        }
      } else {
        toastification.show(
          alignment: Alignment.topCenter,
          title: Text(
            "Error: ${response.data["message"] ?? "Login Failed"}",
            style: TextStyle(color: AppColors.black),
          ),
          autoCloseDuration: Duration(seconds: 3),
        );
      }
    } catch (e,stackTrace) {
      print("Login Error => $e");
      print(stackTrace);
      toastification.show(
        alignment: Alignment.topCenter,
        title: Text(
          "Error, ${e.toString()}",
          style: TextStyle(color: AppColors.black),
        ),
        autoCloseDuration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
