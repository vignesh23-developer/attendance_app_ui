import 'package:get/get.dart';
import '../data/const/api.dart';
import '../model/a_dashboard.dart';

class DashboardController extends GetxController {
  final ApiService apiService = ApiService();

  RxBool isLoading = false.obs;

  Rxn<DashboardModel> dashboard =
  Rxn<DashboardModel>();

  @override
  void onInit() {
    super.onInit();
    getDashboard();
  }

  Future<void> getDashboard() async {
    try {
      isLoading.value = true;

      final response = await apiService.getRequest(
        Api.dashboard,
      );

      if (response.statusCode == 200 &&
          response.data["success"] == true) {
        dashboard.value = DashboardModel.fromJson(
          response.data["data"],
        );

        print(
          "Dashboard Loaded : ${dashboard.value?.totalEmployees}",
        );
      }
    } catch (e) {
      print("Dashboard Error : $e");
    } finally {
      isLoading.value = false;
    }
  }
}