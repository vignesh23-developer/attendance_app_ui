import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';
import '../data/const/api.dart';
import '../model/employee_model.dart';

class EmployeeController extends GetxController {
  final ApiService apiService = ApiService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController imageUrl = TextEditingController();

  RxBool isLoading = false.obs;

  RxList<EmployeeModel> employeeList = <EmployeeModel>[].obs;

  RxList<EmployeeModel> filteredList = <EmployeeModel>[].obs;

  @override
  void onInit() {
    getEmployees();
    super.onInit();
  }

  Future<void> getEmployees() async {
    try {
      isLoading(true);

      final response = await apiService.dio.get(Api.employeeList);

      if (response.statusCode == 200 && response.data["success"] == true) {
        employeeList.value = (response.data["data"] as List)
            .map((e) => EmployeeModel.fromJson(e))
            .toList();
        filteredList.value = List.from(employeeList);
      }
    } catch (e) {
      print("Employee List Error => $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateEmployee({
    required int employeeId,
    required String name,
    required String role,
    required String number,
  }) async {
    try {
      isLoading.value = true;

      final response = await apiService.dio.put(
        "${Api.updateEmployee}$employeeId",
        data: {
          "name": nameController.text.trim(),
          "role": roleController.text.trim(),
          "number": phoneController.text.trim(),
          "image": imageUrl.text.trim(),
        },
      );

      print("Update data: ${response.data}");

      if (response.statusCode == 200 && response.data["success"] == true) {
        Get.back();
        toastification.show(
          autoCloseDuration: Duration(seconds: 3),
          alignment: Alignment.topCenter,
          title: Text(
            "Employee Updated Successfully",
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold
            ),
          ),
        );
      }
    } catch (e) {
      print("Update Employee Error => $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteEmployee(int employeeId) async {
    try {
      final response = await apiService.dio.delete(
        "${Api.deleteEmployee}$employeeId",
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        employeeList.removeWhere((e) => e.employeeId == employeeId);

        filteredList.removeWhere((e) => e.employeeId == employeeId);

        return true;
      }

      return false;
    } catch (e) {
      print("Delete Employee Error => $e");
      return false;
    }
  }

  void searchEmployee(String value) {
    if (value.isEmpty) {
      filteredList.value = List.from(employeeList);
      return;
    }

    filteredList.value = employeeList.where((employee) {
      return employee.name.toLowerCase().contains(value.toLowerCase());
    }).toList();
  }
}
