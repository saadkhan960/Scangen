import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scangen/Controller/scanner/scanner_controller.dart';
import 'package:scangen/Utils/Colors/app_colors.dart';
import 'package:scangen/Utils/Helper/helper_function.dart';
import 'package:scangen/View/ScanScreen/Screen/image_show_barcode_info.dart';

final ScannerController scannerController = Get.find<ScannerController>();

class AnalyzeImageFromGalleryButton extends StatelessWidget {
  const AnalyzeImageFromGalleryButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        "Scan From Image",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onPressed: () async {
        try {
          scannerController.zoomFactor.value = 0.0;
          final ImagePicker picker = ImagePicker();

          final XFile? image = await picker.pickImage(
            source: ImageSource.gallery,
          );

          if (image == null) {
            return;
          } else {
            scannerController.pickedImage = File(image.path);
          }

          final BarcodeCapture? barcodes = await controller.analyzeImage(
            image.path,
          );

          if (!context.mounted) {
            return;
          }
          if (barcodes == null) {
            HelperFunction.showSnackbar(
                color: Colors.red, context: context, text: "No Barcode Found!");
            return;
          } else {
            await scannerController.controller.stop();
            for (var barcode in barcodes.barcodes) {
              scannerController.imageScanbarcodes.value =
                  barcode.rawValue ?? "Something Went Wrong";
            }
            HelperFunction.simpleAnimationNavigation(
                context, const ImageShowBarcodeInfo());
          }
        } on MobileScannerBarcodeException catch (e) {
          debugPrint("Error while scan from image in barcodeexeption");
          HelperFunction.showSnackbar(
            color: Colors.red,
            context: context,
            text: e.toString(),
          );
          return;
        } catch (e) {
          debugPrint("Error while scan from image in Catch");
          HelperFunction.showSnackbar(
              color: Colors.red,
              context: context,
              text: "Something Wents Wrong!");
          return;
        }
      },
    );
  }
}

class StartStopMobileScannerButton extends StatelessWidget {
  const StartStopMobileScannerButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return IconButton(
            color: Colors.white,
            icon: const Icon(Icons.play_arrow),
            iconSize: 32.0,
            onPressed: () async {
              scannerController.isCameraActive.value = true;
              await controller.start();
            },
          );
        }

        return IconButton(
          color: Colors.white,
          icon: const Icon(Icons.stop),
          iconSize: 32.0,
          onPressed: () async {
            scannerController.isCameraActive.value = false;
            await controller.stop();
          },
        );
      },
    );
  }
}

class SwitchCameraButton extends StatelessWidget {
  const SwitchCameraButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        final int? availableCameras = state.availableCameras;

        if (availableCameras != null && availableCameras < 2) {
          return const SizedBox.shrink();
        }

        final Widget icon;

        switch (state.cameraDirection) {
          case CameraFacing.front:
            icon = const Icon(Icons.camera_front);
          case CameraFacing.back:
            icon = const Icon(Icons.camera_rear);
        }

        return IconButton(
          color: Colors.white,
          iconSize: 32.0,
          icon: icon,
          onPressed: () async {
            scannerController.zoomFactor.value = 0.0;
            await controller.switchCamera();
          },
        );
      },
    );
  }
}

class ToggleFlashlightButton extends StatelessWidget {
  const ToggleFlashlightButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        switch (state.torchState) {
          case TorchState.auto:
            return IconButton(
              color: Colors.white,
              iconSize: 32.0,
              icon: const Icon(Icons.flashlight_on),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.off:
            return IconButton(
              color: Colors.white,
              iconSize: 32.0,
              icon: const Icon(Icons.flashlight_off),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.on:
            return IconButton(
              color: Colors.white,
              iconSize: 32.0,
              icon: const Icon(Icons.flashlight_on),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.unavailable:
            return const SizedBox.square(
              dimension: 48.0,
              child: Icon(
                Icons.no_flash,
                size: 32.0,
                color: Colors.grey,
              ),
            );
        }
      },
    );
  }
}

class BuildZoomScaleSlider extends StatelessWidget {
  const BuildZoomScaleSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: scannerController.controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Text(
                '${(scannerController.zoomFactor.value * 100).toStringAsFixed(0)}%',
                overflow: TextOverflow.fade,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .apply(color: AppColors.white),
              ),
              Expanded(
                child: Slider(
                  value: scannerController.zoomFactor.value,
                  onChanged: (value) async {
                    scannerController.zoomFactor.value = value;
                    await scannerController.controller.setZoomScale(value);
                  },
                ),
              ),
              Text(
                '100%',
                overflow: TextOverflow.fade,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .apply(color: AppColors.white),
              ),
            ],
          ),
        );
      },
    );
  }
}
