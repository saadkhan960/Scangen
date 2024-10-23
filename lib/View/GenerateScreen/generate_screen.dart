import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scangen/Controller/generator/generator_controller.dart';
import 'package:scangen/Utils/App%20Gradient/app_gradient.dart';
import 'package:scangen/Utils/Colors/app_colors.dart';
import 'package:scangen/View/GenerateScreen/widgets/botton_sheet.dart';
import 'package:scangen/View/GenerateScreen/widgets/download_button.dart';
import 'package:scangen/View/GenerateScreen/widgets/generated_qr_code.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  final GeneratorController generatorController =
      Get.find<GeneratorController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.primaryGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            "Generate QR Code",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .apply(color: AppColors.white),
          ),
          actions: const [
            //Download Button
            DownloadButton()
          ],
        ),
        body: Stack(
          children: [
            //Generate Qr widget
            GeneratedQrCode(),
            // input & Setting Qr code widget
            const BottonSheet()
          ],
        ),
      ),
    );
  }
}
