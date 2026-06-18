import 'package:dio/dio.dart';

class Api {
  static const baseUrl = "https://texa-attendance.texainnovates.com/auth/";

  // Admin API's
  static const adminLogin = "admin/login";
  static const employeeList = "admin/employee-list";
  static const deleteEmployee = "delete/employee/";
  static const updateEmployee = "update/employee/";
  static const leaveRequestList = "admin/leave-request-list";
  static const updateStatus = "admin/update-leave";
  static const employeeHistory = "admin/employee-history";
  static const dashboard = "admin/dashboard";



  // Employee API's
  static const employeeLogin = "employee/login";
  static const checkIn = "employee/checkin";
  static const checkOut = "employee/checkout";
  static const leaveRequest = "employee/leave-request";
  static const requestList = "employee/get-leave-requests";
  static const cancelLeave = "employee/delete-leave-request";
  static const history = "employee/attendance-status";
  static const employeeRegister = "employee/register";
}

class ApiService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: Api.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  Future<Response> getRequest(
      String endpoint,
      ) async {
    return await dio.get(endpoint);
  }



  Future<Response> postRequest(
      String endpoint,
      Map<String, dynamic> data,
      ) async {
    return await dio.post(
      endpoint,
      data: data,
    );
  }
}

class ApiServiceForm {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: Api.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  )..interceptors.add(
    LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ),
  );
}