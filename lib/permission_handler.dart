import 'package:permission_handler/permission_handler.dart';

Future<void> requestCameraPermission() async {
  var status = await Permission.camera.request();

  if (status.isGranted) {
    print("Camera Permission Granted");
  } else {
    print("Camera Permission Denied");
  }
}