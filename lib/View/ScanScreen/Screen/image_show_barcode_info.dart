import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:scangen/Controller/scanner/scanner_controller.dart';
import 'package:scangen/Utils/App%20Gradient/app_gradient.dart';
import 'package:scangen/Utils/Colors/app_colors.dart';
import 'package:scangen/Utils/Helper/helper_function.dart';
import 'package:scangen/Utils/sizes/app_size.dart';

class ImageShowBarcodeInfo extends StatelessWidget {
  const ImageShowBarcodeInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final ScannerController scannerController = Get.find<ScannerController>();
    File? pickImage = scannerController.pickedImage;
    final qrText = scannerController.imageScanbarcodes.value;
    final size = MediaQuery.of(context).size;
    Future startScannerAndNavigateBack(BuildContext context) async {
      // Ensure the scanner is started again before navigating back
      await scannerController.controller.start(); // Start the scanner here
      scannerController.isScanning.value = false;
      scannerController.zoomFactor.value = 0.0;

      if (Navigator.canPop(context)) {
        Navigator.pop(
            context); // Ensure navigation happens after starting the scanner
      }
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        didPop = true;
        startScannerAndNavigateBack(context);
      },
      child: Container(
        decoration: const BoxDecoration(gradient: AppGradients.primaryGradient),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Scan Details",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .apply(color: AppColors.white),
            ),
            leading: IconButton(
                onPressed: () {
                  startScannerAndNavigateBack(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.white,
                )),
            backgroundColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.defaultSpace),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.white),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Column(
                      children: [
                        if (pickImage != null)
                          Text("Scan Image",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .apply(color: AppColors.white)),
                        const SizedBox(height: AppSizes.spaceBtwItems),
                        if (pickImage != null)
                          ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              child: Image.file(
                                File(scannerController.pickedImage!.path),
                                height: size.height * 0.3,
                                width: size.width * 0.7,
                                fit: BoxFit.cover,
                              )),
                        if (pickImage != null)
                          const SizedBox(height: AppSizes.spaceBtwItems),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("The Data get from Code ",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .apply(color: AppColors.white)),
                            IconButton(
                              icon: const Icon(Icons.copy,
                                  color: AppColors.white),
                              onPressed: () {
                                HelperFunction.copyToClipboardAndShowSnackbar(
                                    text: qrText, context: context);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.spaceBtwItems),
                        Container(
                          width: size.width * 0.8,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            border: Border.all(color: AppColors.white),
                          ),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 230,
                            ),
                            child: SingleChildScrollView(
                              child: SelectableText(
                                scannerController.formatQrData(qrText),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .apply(color: AppColors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacerBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        startScannerAndNavigateBack(context);
                      },
                      child: Text(
                        "Scan Code",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
