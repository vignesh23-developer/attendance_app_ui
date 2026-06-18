import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toastification/toastification.dart';

Future<void> requestCameraPermission() async {
  var status = await Permission.camera.request();

  if (status.isGranted) {
    print("Camera Permission Granted");
  } else {
    print("Camera Permission Denied");
  }
}

Future<bool> validatePermissions() async {
  bool locationEnabled =
  await Geolocator.isLocationServiceEnabled();

  if (!locationEnabled) {
    toastification.show(
      title: const Text(
        "Please enable Location Service",
      ),
      autoCloseDuration: const Duration(seconds: 3),
    );

    return false;
  }

  var locationPermission =
  await Geolocator.checkPermission();

  if (locationPermission ==
      LocationPermission.denied ||
      locationPermission ==
          LocationPermission.deniedForever) {

    toastification.show(
      title: const Text(
        "Location permission required",
      ),
      autoCloseDuration: const Duration(seconds: 3),
    );

    return false;
  }

  var cameraStatus = await Permission.camera.status;

  if (!cameraStatus.isGranted) {
    toastification.show(
      title: const Text(
        "Camera permission required",
      ),
      autoCloseDuration: const Duration(seconds: 3),
    );

    return false;
  }

  return true;
}