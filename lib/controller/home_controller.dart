import 'dart:async';
import 'dart:io';
import 'package:attandance_app/data/const/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  // ── Observables ───────────────────────────────────────
  final RxBool isCheckedIn       = false.obs;
  final RxBool isLoading         = false.obs;
  final RxString capturedImage   = ''.obs;
  final RxString currentTime     = ''.obs;
  final RxString currentDate     = ''.obs;
  final RxString checkInTime     = ''.obs;
  final RxString checkOutTime    = ''.obs;
  final RxString elapsedTime     = '00:00:00'.obs;
  final RxDouble progressPercent = 0.0.obs;   // 0.0 – 1.0 (8 hr day)
  final RxBool halfDayReached    = false.obs;

  // ── Internals ─────────────────────────────────────────
  Timer? _clockTimer;
  Timer? _workTimer;
  DateTime? _checkInDateTime;
  late AnimationController pulseController;
  late Animation<double> pulseAnim;

  // ── Constants ─────────────────────────────────────────
  static const int _workDaySeconds = 8 * 3600;
  static const int _halfDaySeconds = 4 * 3600;


  final RxString currentLocation = 'Fetching...'.obs;

  @override
  void onInit() {
    super.onInit();
    _initPulse();
    _startClock();
    _loadSavedState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {

    try {

      debugPrint('STEP 1 : Checking location service');

      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      debugPrint('Location Service Enabled : $serviceEnabled');

      if (!serviceEnabled) {

        currentLocation.value = 'Location Off';

        debugPrint('ERROR : Location service disabled');

        return;
      }

      debugPrint('STEP 2 : Checking permission');

      permission = await Geolocator.checkPermission();

      debugPrint('Current Permission : $permission');

      if (permission == LocationPermission.denied) {

        debugPrint('Permission denied, requesting permission');

        permission = await Geolocator.requestPermission();

        debugPrint('New Permission : $permission');

        if (permission == LocationPermission.denied) {

          currentLocation.value = 'Permission Denied';

          debugPrint('ERROR : Permission denied');

          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {

        currentLocation.value = 'Permission Permanently Denied';

        debugPrint('ERROR : Permission permanently denied');

        return;
      }

      debugPrint('STEP 3 : Fetching GPS Position');

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      debugPrint(
        'Latitude : ${position.latitude} , Longitude : ${position.longitude}',
      );

      debugPrint('STEP 4 : Fetching placemark');

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      debugPrint('Placemark Count : ${placemarks.length}');

      if (placemarks.isNotEmpty) {

        final place = placemarks.first;

        debugPrint('Locality : ${place.locality}');
        debugPrint('Sub Admin Area : ${place.subAdministrativeArea}');
        debugPrint('Admin Area : ${place.administrativeArea}');
        debugPrint('Country : ${place.country}');

        currentLocation.value =
            place.locality ??
                place.subAdministrativeArea ??
                place.administrativeArea ??
                place.country ??
                'Unknown Location';

        debugPrint(
          'FINAL LOCATION : ${currentLocation.value}',
        );

      } else {

        currentLocation.value = 'Location Not Found';

        debugPrint('ERROR : Placemark empty');
      }

    } catch (e) {

      currentLocation.value = 'Location Error';

      debugPrint('LOCATION ERROR : $e');
    }
  }

  void _initPulse() {
    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    pulseAnim = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
    );
  }

  void _startClock() {
    _updateClock();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) => _updateClock());
  }

  void _updateClock() {
    final now = DateTime.now();
    currentTime.value = DateFormat('hh:mm a').format(now);
    currentDate.value = DateFormat('MMM dd, yyyy - EEEE').format(now);
  }

  Future<void> _loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCheckIn = prefs.getString('check_in_time');
    if (savedCheckIn != null) {
      _checkInDateTime = DateTime.parse(savedCheckIn);
      checkInTime.value = DateFormat('hh:mm a').format(_checkInDateTime!);
      isCheckedIn.value = true;
      _startWorkTimer();
    }
  }

  // ── Check-in flow ─────────────────────────────────────

  Future<void> onPunchTap() async {
    if (isCheckedIn.value) {
      _performCheckOut();
    } else {
      await _openCamera();
    }
  }

  Future<void> _openCamera() async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 85,
    );

    if (photo != null) {
      capturedImage.value = photo.path;
      _showPreviewDialog(photo.path);
    }
  }

  void _showPreviewDialog(String path) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Confirm Check-In',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(path),
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        capturedImage.value = '';
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF730323)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: CommonText(text: "Retake",color: AppColors.primary,fontSize: 15.sp,)
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        _performCheckIn(path);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF730323),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: CommonText(text: "Submit",color: AppColors.white,fontSize: 15.sp,),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _performCheckIn(String imagePath) async {
    isLoading.value = true;

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    _checkInDateTime = DateTime.now();
    checkInTime.value = DateFormat('hh:mm a').format(_checkInDateTime!);
    isCheckedIn.value = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('check_in_time', _checkInDateTime!.toIso8601String());

    _startWorkTimer();
    isLoading.value = false;

    Get.snackbar(
      '✅ Checked In',
      'Welcome! Have a great day at work.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF16A34A),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void _performCheckOut() {
    _workTimer?.cancel();
    checkOutTime.value = DateFormat('hh:mm a').format(DateTime.now());
    isCheckedIn.value = false;
    _checkInDateTime = null;
    capturedImage.value = '';

    SharedPreferences.getInstance().then((p) => p.remove('check_in_time'));

    Get.snackbar(
      '👋 Checked Out',
      'See you tomorrow! Total: ${elapsedTime.value}',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF730323),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );

    elapsedTime.value = '00:00:00';
    progressPercent.value = 0;
    halfDayReached.value = false;
  }

  void _startWorkTimer() {
    _workTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_checkInDateTime == null) return;
      final elapsed = DateTime.now().difference(_checkInDateTime!).inSeconds;
      final h = elapsed ~/ 3600;
      final m = (elapsed % 3600) ~/ 60;
      final s = elapsed % 60;
      elapsedTime.value =
      '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
      progressPercent.value = (elapsed / _workDaySeconds).clamp(0.0, 1.0);
      if (elapsed >= _halfDaySeconds && !halfDayReached.value) {
        halfDayReached.value = true;
      }
    });
  }

  @override
  void onClose() {
    _clockTimer?.cancel();
    _workTimer?.cancel();
    pulseController.dispose();
    super.onClose();
  }
}
