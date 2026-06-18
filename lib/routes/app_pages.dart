import 'package:attandance_app/view/splash_screen.dart';
import 'package:get/get.dart';
import '../view/auth_file/auth_screen.dart';
import '../view/auth_file/role_selection.dart';
import '../view/dashboard.dart';
import 'binding.dart';

class AppRoutes {

  /// Common Pages ..............
  static const splash = '/';
  static const selectRole = '/selectRole';
  static const adminAuth = '/adminAuth';
  static const employeeAuth = '/employeeAuth';
  static const adminBottom = '/adminBottom';
  static const employeeBottom = '/employeeBottom';


  /// --------------------------------------------------
  /// Admin Pages ...............
  /// --------------------------------------------------


  /// --------------------------------------------------
  /// Employee Pages............
  /// --------------------------------------------------



}

class AppPages {
  static final pages = [

    /// Common Pages ..............

    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),

    GetPage(name: AppRoutes.selectRole, page: () => const SelectRole()),

    GetPage(
      name: AppRoutes.adminAuth,
      page: () => const AuthScreen(isAdmin: true),
    ),

    GetPage(
      name: AppRoutes.employeeAuth,
      page: () => const AuthScreen(isAdmin: false),
    ),

    GetPage(
      name: AppRoutes.adminBottom,
      page: () => const BottomNavScreen(isAdmin: true),
    ),
    GetPage(
      name: AppRoutes.employeeBottom,
      page: () => const BottomNavScreen(isAdmin: false),
      binding: Binding()
    ),

    /// --------------------------------------------------
    /// Employee Pages............
    /// --------------------------------------------------
  ];
}

