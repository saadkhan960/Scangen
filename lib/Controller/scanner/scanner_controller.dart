import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:typed_data';

class ScannerController extends GetxController {
  RxDouble zoomFactor = 0.0.obs;
  RxBool isControllerActive = true.obs;
  RxBool isCameraActive = true.obs;
  RxString barcodes = 'Something Went Wrong'.obs;
  RxString imageScanbarcodes = 'Something Went Wrong'.obs;
  File? pickedImage;
  Rx<Uint8List?> barcodeImage = Rx<Uint8List?>(null);
  RxBool isScanning = false.obs;
  MobileScannerController controller = MobileScannerController(
      autoStart: false, torchEnabled: false, returnImage: true);
  final AudioPlayer audioPlayer = AudioPlayer();

  // Method to add an image of the scanned barcode
  void addImage(Uint8List image) {
    barcodeImage.value = image;
  }

  // Main function to determine and format QR data
  String formatQrData(String data) {
    if (data.startsWith("WIFI:")) {
      return formatWifiData(data);
    } else {
      return formatParagraph(data);
    }
  }

// Function to format Wi-Fi QR code data
  String formatWifiData(String data) {
    String pattern = r'([T|P|S|H]):([^;]+)'; // Match each key and its value
    RegExp regExp = RegExp(pattern);

    StringBuffer formattedData = StringBuffer();

    // Check for matches in the data
    for (var match in regExp.allMatches(data)) {
      String key = match.group(1)!.trim();
      String value = match.group(2)!.trim();

      // Format based on the key
      switch (key) {
        case 'T':
          formattedData.writeln('Security: $value'); // E.g., WPA
          break;
        case 'P':
          formattedData.writeln('Password: $value'); // E.g., Kh21
          break;
        case 'S':
          formattedData.writeln(
              'SSID: ${value.split('(')[0].trim()}'); // E.g., AMAFHH.NET
          break;
        case 'H':
          formattedData.writeln('Hidden: $value'); // E.g., false
          break;
      }
    }

    return formattedData.toString().trim();
  }

// Function to format a paragraph of text
  String formatParagraph(String data) {
    final List<String> sentences = data.split('. ');
    StringBuffer formattedData = StringBuffer();

    for (String sentence in sentences) {
      if (sentence.trim().isNotEmpty) {
        formattedData.writeln('${sentence.trim()}.');
      }
    }

    return formattedData.toString().trim();
  }
}
