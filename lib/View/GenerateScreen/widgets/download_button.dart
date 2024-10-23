import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scangen/Controller/generator/generator_controller.dart';
import 'package:scangen/Utils/Colors/app_colors.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton({super.key});

  @override
  Widget build(BuildContext context) {
    final GeneratorController generatorController =
        Get.find<GeneratorController>();
    return Obx(
      () => generatorController.generateUrl.value == ""
          ? const SizedBox()
          : generatorController.downloadLoading.value
              ? Center(
                  child: Container(
                    margin: const EdgeInsets.only(right: 15),
                    height: 25,
                    width: 25,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  ),
                )
              : IconButton(
                  onPressed: () async {
                    await generatorController.captureAndSaveImage();
                  },
                  icon: const Icon(
                    Icons.file_download_outlined,
                    color: AppColors.white,
                    size: 30,
                  )),
    );
  }
}
