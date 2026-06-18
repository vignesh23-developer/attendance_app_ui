import 'package:get/get.dart';
import '../controller/employee_report_controller.dart';
import '../controller/history_controller.dart';
import '../controller/home_controller.dart';
import '../controller/leave_controller.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<AttendanceController>(() => AttendanceController());
    Get.lazyPut<LeaveController>(() => LeaveController());
    Get.lazyPut<EmployeeReportController>(()=> EmployeeReportController());
  }
}