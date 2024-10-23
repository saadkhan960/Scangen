import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';
import 'package:scangen/Controller/scanner/scanner_controller.dart';
import 'package:scangen/Utils/Colors/app_colors.dart';
import 'package:scangen/Utils/Helper/helper_function.dart';
import 'package:scangen/View/ScanScreen/Screen/show_barcode_info.dart';
import 'package:scangen/View/ScanScreen/widgets/scanner_error_widget.dart';

class ScannerBox extends StatelessWidget {
  ScannerBox({super.key, required this.controller});
  final MobileScannerController controller;
  final ScannerController scannerController = Get.find<ScannerController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: size.height * 0.3,
        width: size.width * 0.7,
        child: Stack(
          children: [
            // Your scanner overlay container
            Container(
              height: size.height * 0.3,
              width: size.width * 0.7,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
              child: const Center(
                child: Text(
                  "Scanner Stop",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            // MobileScanner widget
            MobileScanner(
              controller: controller,
              fit: BoxFit.cover,
              onDetect: (capture) async {
                if (!scannerController.isScanning.value) {
                  scannerController.isScanning.value = true;
                  for (var barcode in capture.barcodes) {
                    scannerController.barcodes.value =
                        barcode.rawValue ?? "Something Went Wrong";
                  }
                  await scannerController.audioPlayer
                      .play(AssetSource('sound/barcode_scanner.mp3'));
                  scannerController.addImage(capture.image!);

                  if (capture.image != null) {
                    HelperFunction.simpleAnimationNavigation(
                        context, const ShowBarcodeInfo());
                    await controller.stop();
                  }
                }
              },
              onDetectError: (error, stackTrace) {
                if (kDebugMode) {
                  print("error : $error stacktrace $stackTrace");
                }
              },
              errorBuilder: (context, error, child) {
                return ScannerErrorWidget(error: error);
              },
              placeholderBuilder: (p0, p1) {
                return Container(
                  height: size.height * 0.3,
                  width: size.width * 0.7,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Center(
                    child: Text(
                      "Scanner Loading",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),

            // QRScannerOverlay
            QRScannerOverlay(
              borderColor: AppColors.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
