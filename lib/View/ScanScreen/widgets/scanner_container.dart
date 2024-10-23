import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scangen/Controller/scanner/scanner_controller.dart';
import 'package:scangen/View/ScanScreen/widgets/scanner_box.dart';
import 'package:scangen/View/ScanScreen/widgets/scanner_button_widgets.dart';

class ScannerContainer extends StatefulWidget {
  const ScannerContainer({super.key});

  @override
  State<ScannerContainer> createState() => _ScannerContainerState();
}

class _ScannerContainerState extends State<ScannerContainer>
    with WidgetsBindingObserver {
  final ScannerController scannerController = Get.find<ScannerController>();
  late MobileScannerController controller;
  StreamSubscription<Object?>? _subscription;

  @override
  void initState() {
    super.initState();
    if (scannerController.isControllerActive.value) {
      controller = scannerController.controller;
    } else {
      scannerController.controller = MobileScannerController(
          autoStart: false, torchEnabled: false, returnImage: true);
      controller = scannerController.controller;
      scannerController.isControllerActive.value = true;
    }
    scannerController.zoomFactor.value = 0.0;
    WidgetsBinding.instance.addObserver(this);
    unawaited(controller.start());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!controller.value.hasCameraPermission) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        unawaited(controller.start());
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(children: [
      // Scanner Box
      ScannerBox(controller: controller),
      const SizedBox(
        height: 10,
      ),
      //Scanner Options
      Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SwitchCameraButton(controller: controller),
            StartStopMobileScannerButton(controller: controller),
            ToggleFlashlightButton(controller: controller),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      //Zoom Widget
      const BuildZoomScaleSlider(),
      const SizedBox(
        height: 20,
      ),
      // Pick Image From gallery
      SizedBox(
        width: size.width,
        child: AnalyzeImageFromGalleryButton(controller: controller),
      )
    ]);
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await controller.dispose();
    scannerController.isControllerActive.value = false;
  }
}
