import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("role", role);
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("role");
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> saveUserData({
    required String name,
    required String role,
    required int loginId,
    String? image,
    String? number,
    String? email,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("name", name);
    await prefs.setString("role_name", role);
    await prefs.setInt("loginId", loginId);

    if (number != null) {
      await prefs.setString("number", number);
    }

    if (email != null) {
      await prefs.setString("email", email);
    }

    if (image != null) {
      await prefs.setString("image", image);
    }
  }

  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("name");
  }

  static Future<int?> getLoginId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("loginId");
  }

  static Future<String?> getRoleName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("role_name");
  }

  static Future<String?> getImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("image");
  }

  static Future<String?> getNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("number");
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }
}
