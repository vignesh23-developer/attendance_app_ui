import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:toastification/toastification.dart';
import '../data/const/api.dart';
import '../data/const/image_compresser.dart';
import '../data/local_storage/stroage_services.dart';
import '../model/attendance_response.dart';
import '../permission_handler.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  // ── OBSERVABLES ───────────────────────────────────────
  final isCheckedIn = false.obs;
  final isLoading = false.obs;
  final isReadyForAttendance = false.obs;

  final capturedImage = ''.obs;
  final currentTime = ''.obs;
  final currentDate = ''.obs;
  final checkInTime = ''.obs;
  final checkOutTime = ''.obs;
  final elapsedTime = '00:00:00'.obs;

  final progressPercent = 0.0.obs;
  final halfDayReached = false.obs;

  final currentLocation = 'Fetching...'.obs;

  final RxDouble latitude = 0.0.obs;
  final RxDouble longitude = 0.0.obs;

  Timer? _clockTimer;
  Timer? _workTimer;
  DateTime? _checkInDateTime;

  late AnimationController pulseController;
  late Animation<double> pulseAnim;

  final ApiService api = ApiService();

  final ApiServiceForm _apiServiceForm = ApiServiceForm();

  static const int _workDaySeconds = 8 * 3600;
  static const int _halfDaySeconds = 4 * 3600;

  @override
  void onInit() async {
    super.onInit();

    _initPulse();
    _startClock();

    await requestAllPermissions();

    await loadAttendanceStatus();
  }

  Future<void> requestAllPermissions() async {
    final cameraStatus = await Permission.camera.request();

    LocationPermission locationPermission =
    await Geolocator.requestPermission();

    await getCurrentLocation();

    isReadyForAttendance.value =
        cameraStatus.isGranted &&
            (locationPermission == LocationPermission.always ||
                locationPermission == LocationPermission.whileInUse);
  }

  // ── LOCATION ─────────────────────────────────────────
  Future<void> getCurrentLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        currentLocation.value = 'Location Off';
        return;
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        currentLocation.value = 'Permission Denied';
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // ✅ SAVE LAT LONG
      latitude.value = pos.latitude;
      longitude.value = pos.longitude;

      final placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;

        currentLocation.value =
            p.locality ??
            p.subAdministrativeArea ??
            p.administrativeArea ??
            p.country ??
            'Unknown';
        isReadyForAttendance.value = true;
      }
    } catch (_) {
      currentLocation.value = 'Location Error';
    }
  }

  // ── CLOCK ────────────────────────────────────────────
  void _startClock() {
    _updateClock();
    _clockTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateClock(),
    );
  }

  void _updateClock() {
    final now = DateTime.now();
    currentTime.value = DateFormat('hh:mm a').format(now);
    currentDate.value = DateFormat('MMM dd, yyyy - EEEE').format(now);
  }

  // ── RESTORE ───────────────────────────────────────────
  Future<void> loadAttendanceStatus() async {
    try {
      final employeeId = await StorageService.getLoginId();

      final response = await api.dio.post(
        Api.history,
        data: {"employee_id": employeeId},
      );

      print("ATTENDANCE RESPONSE => ${response.data}");

      final data = response.data["data"];



      if (data["status"].toString().toUpperCase() == "PRESENT") {

        isCheckedIn.value = true;

        final checkIn = data["checkin_time"];

        checkInTime.value = DateFormat('hh:mm a').format(
          DateFormat("HH:mm:ss").parse(checkIn),
        );

        final today = DateTime.now();

        _checkInDateTime = DateTime(
          today.year,
          today.month,
          today.day,
          int.parse(checkIn.split(":")[0]),
          int.parse(checkIn.split(":")[1]),
          int.parse(checkIn.split(":")[2]),
        );

        _startWorkTimer();
      } else if (data["status"] == "CHECKED_OUT") {

        isCheckedIn.value = false;

        _workTimer?.cancel();

        if (data["checkin_time"] != null) {
          checkInTime.value = DateFormat('hh:mm a').format(
            DateFormat("HH:mm:ss").parse(data["checkin_time"]),
          );
        }

        if (data["checkout_time"] != null) {
          checkOutTime.value = DateFormat('hh:mm a').format(
            DateFormat("HH:mm:ss").parse(data["checkout_time"]),
          );
        }

        if (data["total_hours"] != null) {
          elapsedTime.value = data["total_hours"];
        }

      } else {

        isCheckedIn.value = false;

        _workTimer?.cancel();

        checkInTime.value = "";
        checkOutTime.value = "";
        elapsedTime.value = "00:00:00";

        final prefs = await SharedPreferences.getInstance();

        await prefs.remove("check_in_time");
      }
    } catch (e) {
      print("LOAD ATTENDANCE ERROR => $e");
    }
  }

  // ── CAMERA ENTRY POINT (ONLY USED BY UI) ─────────────
  Future<void> openCameraForCheckIn() async {
    bool allowed = await validatePermissions();

    if (!allowed) return;

    final picker = ImagePicker();

    final photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      await _apiCheckIn(photo.path);
    }
  }

  Future<void> openCameraForCheckOut() async {
    bool allowed = await validatePermissions();

    if (!allowed) return;

    final picker = ImagePicker();

    final photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      await _apiCheckOut(photo.path);
    }
  }

  // ── CHECK-IN API ─────────────────────────────────────
  Future<void> _apiCheckIn(String imagePath) async {
    try {
      isLoading.value = true;

      print("========== CHECK-IN START ==========");
      print("Image Path: $imagePath");

      final file = await compressTo1MP(File(imagePath));
      print("Compressed File Path: ${file.path}");
      print("Compressed File Size: ${await file.length()} bytes");

      final employeeId = await StorageService.getLoginId();
      final employeeName= await StorageService.getName();
      print("Employee ID: $employeeId");

      print("Location: ${currentLocation.value}");
      print("Latitude: ${latitude.value}");
      print("Longitude: ${longitude.value}");

      final formData = FormData.fromMap({
        "employee_id": employeeId.toString(),
        "employee_name": employeeName.toString(),
        "checkin_location": currentLocation.value,
        "checkin_lat": latitude.value.toString(),
        "checkin_long": longitude.value.toString(),
        "checkin_image": await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      print("FormData Created Successfully");
      for (var field in formData.fields) {
        print("${field.key} = ${field.value}");
      }

      for (var file in formData.files) {
        print("${file.key} = ${file.value.filename}");
      }
      print("BEFORE API CALL");
      final response = await _apiServiceForm.dio.post(
        Api.checkIn,
        data: formData,
      );
      print("AFTER API CALL");

      print("Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      final model = AttendanceResponse.fromJson(response.data);

      print("API Success: ${model.success}");
      print("API Message: ${model.message}");

      toastification.show(
        title: Text(model.message),
        autoCloseDuration: const Duration(seconds: 3),
        alignment: Alignment.topCenter,
      );

      if (model.success) {
        print("Marking Check-In Locally...");
        _markCheckInLocal();
      }

      print("========== CHECK-IN END ==========");
    } catch (e, stack) {
      print("CRASH => $e");
      print(stack);

      toastification.show(title: Text("Error: $e"));
    } finally {
      isLoading.value = false;
    }
  }

  // ── CHECK-OUT API ────────────────────────────────────
  Future<void> _apiCheckOut(String imagePath) async {
    try {
      isLoading.value = true;

      final file = await compressTo1MP(File(imagePath));
      final employeeId = await StorageService.getLoginId();

      final formData = FormData.fromMap({
        "employee_id": employeeId.toString(),
        "checkout_location": currentLocation.value,
        "checkout_lat": latitude.value.toString(),
        "checkout_long": longitude.value.toString(),
        "checkout_image": await MultipartFile.fromFile(file.path),
      });

      for (var field in formData.fields) {
        print("${field.key} = ${field.value}");
      }

      for (var file in formData.files) {
        print("${file.key} = ${file.value.filename}");
      }
      print("BEFORE API CALL");
      final response = await _apiServiceForm.dio.post(
        Api.checkOut,
        data: formData,
      );
      print("AFTER API CALL");

      final model = AttendanceResponse.fromJson(response.data);

      toastification.show(
        title: Text(model.message),
        autoCloseDuration: const Duration(seconds: 3),
        alignment: Alignment.topCenter,
      );

      if (model.success) {
        _markCheckOutLocal();
      }
    } catch (e, stack) {
      print("CRASH => $e");
      print(stack);

      toastification.show(title: Text("Error: $e"));
    } finally {
      isLoading.value = false;
    }
  }

  // ── LOCAL CHECK-IN ───────────────────────────────────
  void _markCheckInLocal() async {
    _checkInDateTime = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("check_in_time", _checkInDateTime!.toIso8601String());
    checkInTime.value = DateFormat('hh:mm a').format(_checkInDateTime!);
    isCheckedIn.value = true;
    _startWorkTimer();
  }

  // ── LOCAL CHECK-OUT ──────────────────────────────────
  void _markCheckOutLocal() async {
    _workTimer?.cancel();
    _workTimer = null;

    checkOutTime.value =
        DateFormat('hh:mm a').format(DateTime.now());

    isCheckedIn.value = false;

    _checkInDateTime = null;

    // elapsed time reset panna koodadhu
    // elapsedTime.value = '00:00:00';

    progressPercent.value = 1;

    halfDayReached.value = false;

    // final prefs = await SharedPreferences.getInstance();
    //
    // await prefs.remove('check_in_time');
  }

  // ── TIMER ────────────────────────────────────────────
  void _startWorkTimer() {
    _workTimer?.cancel();

    _workTimer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {

        if (_checkInDateTime == null) return;

        final diff =
        DateTime.now().difference(_checkInDateTime!);

        final hours = diff.inHours;
        final minutes = diff.inMinutes % 60;
        final seconds = diff.inSeconds % 60;

        elapsedTime.value =
        "${hours.toString().padLeft(2, '0')}:"
            "${minutes.toString().padLeft(2, '0')}:"
            "${seconds.toString().padLeft(2, '0')}";

        progressPercent.value =
            (diff.inSeconds / _workDaySeconds)
                .clamp(0.0, 1.0);

        halfDayReached.value =
            diff.inSeconds >= _halfDaySeconds;
      },
    );
  }

  // ── PULSE ANIMATION ──────────────────────────────────
  void _initPulse() {
    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    pulseAnim = Tween<double>(begin: 1.0, end: 1.06).animate(pulseController);
  }

  @override
  void onClose() {
    _clockTimer?.cancel();
    _workTimer?.cancel();
    pulseController.dispose();
    super.onClose();
  }
}
