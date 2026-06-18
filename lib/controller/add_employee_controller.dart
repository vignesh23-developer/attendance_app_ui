import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';

import '../data/const/api.dart';

class AddEmployeeController extends GetxController {
  final ApiService _apiService = ApiService();

  final nameController = TextEditingController();
  final roleController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  RxBool isLoading = false.obs;
  Rx<File?> profileImage = Rx<File?>(null);

  @override
  void onClose() {
    nameController.dispose();
    roleController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  /// Pick Image
  Future<void> pickImage() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      profileImage.value = File(image.path);
    }
  }

  /// Register Employee
  Future<void> registerEmployee() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar("Error", "Enter employee name");
      return;
    }

    if (roleController.text.trim().isEmpty) {
      Get.snackbar("Error", "Enter role");
      return;
    }

    if (emailController.text.trim().isEmpty) {
      Get.snackbar("Error", "Enter email");
      return;
    }

    if (passwordController.text.trim().isEmpty) {
      Get.snackbar("Error", "Enter password");
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      Get.snackbar("Error", "Enter phone number");
      return;
    }

    isLoading.value = true;

    try {
      /// If backend accepts image url only
      /// Replace this after image upload API

      String imageUrl = "";

      final response = await _apiService.postRequest(Api.employeeRegister, {
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "role": roleController.text.trim(),
        "number": phoneController.text.trim(),
        "image": imageUrl,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        toastification.show(
          autoCloseDuration: Duration(seconds: 3),
          alignment: Alignment.topCenter,
          style: ToastificationStyle.fillColored,
          title: Text(
            "Success ${response.data["message"] ?? "Employee Registered Successfully"}",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        clearFields();
      }
    } on DioException catch (e) {
      Get.snackbar(
        "Error",
        e.response?.data["message"] ?? "Something went wrong",
      );
    } finally {
      isLoading.value = false;
    }
  }



  void clearFields() {
    nameController.clear();
    roleController.clear();
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
    profileImage.value = null;
  }
}
