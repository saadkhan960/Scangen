import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scangen/Controller/generator/generator_controller.dart';
import 'package:scangen/Utils/Colors/app_colors.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:screenshot/screenshot.dart';

class GeneratedQrCode extends StatelessWidget {
  GeneratedQrCode({super.key});
  final GeneratorController generatorController =
      Get.find<GeneratorController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Screenshot(
                controller: generatorController.screenshotController,
                child: Container(
                  height: size.height * 0.4,
                  width: size.width * 0.9,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: generatorController.showBackgroundColor.value,
                      border: Border.all(color: AppColors.primary, width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  child: generatorController.generateUrl.value != ""
                      ? Center(
                          child: PrettyQrView.data(
                              decoration: PrettyQrDecoration(
                                  shape: generatorController
                                              .showSelectedValue.value ==
                                          "Smooth Symbol"
                                      ? PrettyQrSmoothSymbol(
                                          color: generatorController
                                              .showForegroundColor.value)
                                      : PrettyQrRoundedSymbol(
                                          color: generatorController
                                              .showForegroundColor.value),
                                  image: generatorController.showImage.value ==
                                          null
                                      ? null
                                      : PrettyQrDecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(generatorController
                                              .showImage.value!),
                                          position: generatorController
                                                      .showImagePostionItem
                                                      .value ==
                                                  "Embedded"
                                              ? PrettyQrDecorationImagePosition
                                                  .embedded
                                              : generatorController
                                                          .showImagePostionItem
                                                          .value ==
                                                      "Background"
                                                  ? PrettyQrDecorationImagePosition
                                                      .background
                                                  : PrettyQrDecorationImagePosition
                                                      .foreground,
                                        )),
                              data: generatorController.generateUrl.value),
                        )
                      : Center(
                          child: Text(
                            "No QR Code Generated Yet",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .apply(color: Colors.black),
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                ),
              ),
            ],
          );
        })
      ],
    );
  }
}
