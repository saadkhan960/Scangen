import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scangen/Controller/BottomNav/bottom_nav.dart';
import 'package:scangen/Controller/generator/generator_controller.dart';
import 'package:scangen/Controller/scanner/scanner_controller.dart';
import 'package:scangen/Utils/Colors/app_colors.dart';
import 'package:scangen/View/GenerateScreen/generate_screen.dart';
import 'package:scangen/View/ScanScreen/scan_screen.dart';

class BottomNavMenu extends StatelessWidget {
  BottomNavMenu({super.key});

  final BottomNav bottomNavController = Get.put(BottomNav());
  final ScannerController scannerController = Get.put(ScannerController());
  final GeneratorController generatorController =
      Get.put(GeneratorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Obx(() => BottomNavigationBar(
              backgroundColor: AppColors.dark,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.qr_code_scanner),
                  label: 'Scan',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.qr_code_2_rounded),
                  label: 'Generate',
                ),
              ],
              currentIndex: bottomNavController.selectedIndex.value,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Theme.of(context).unselectedWidgetColor,
              onTap: (index) => bottomNavController.onItemTapped(index),
            )),
      ),
      body: Obx(() => bottomNavController.selectedIndex.value == 0
          ? const ScanScreen()
          : const GenerateScreen()),
    );
  }
}
