import 'dart:io';
import 'package:image/image.dart' as img;

Future<File> compressTo1MP(File file) async {
  try {
    print("===== IMAGE COMPRESSION START =====");

    final originalSize = await file.length();
    print("Original Size: $originalSize bytes");

    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      print("Image Decode Failed");
      return file;
    }

    print(
      "Original Resolution: ${image.width} x ${image.height}",
    );

    final resized = img.copyResize(
      image,
      width: 1000,
      height: (image.height * 1000 / image.width).round(),
    );

    print(
      "Resized Resolution: ${resized.width} x ${resized.height}",
    );

    final compressedPath =
        "${file.parent.path}/compressed_${file.uri.pathSegments.last}";

    final compressedFile = File(compressedPath);

    await compressedFile.writeAsBytes(
      img.encodeJpg(
        resized,
        quality: 85,
      ),
    );

    final compressedSize = await compressedFile.length();

    print("Compressed Size: $compressedSize bytes");
    print("===== IMAGE COMPRESSION END =====");

    return compressedFile;
  } catch (e) {
    print("COMPRESSION ERROR: $e");
    return file;
  }
}