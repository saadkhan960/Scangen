import 'package:flutter/material.dart';
import 'package:scangen/Utils/App%20Gradient/app_gradient.dart';
import 'package:scangen/Utils/Colors/app_colors.dart';
import 'package:scangen/Utils/sizes/app_size.dart';
import 'package:scangen/View/ScanScreen/widgets/scanner_container.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  @override
  void initState() {
    super.initState();
  }

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
            "Scan Code",
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .apply(color: AppColors.white),
          ),
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
                      Text(
                        "Place QR code or Barcode inside the frame to scan",
                        softWrap: true,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow
                            .visible, // Use visible instead of ellipsis to show all lines
                        maxLines: 2,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .apply(color: AppColors.white),
                      ),
                      const SizedBox(height: AppSizes.spacerBtwSections),
                      const ScannerContainer()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
