import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:scangen/Utils/Colors/app_colors.dart';
import 'package:scangen/Utils/Helper/helper_function.dart';
import 'package:screenshot/screenshot.dart';

class GeneratorController extends GetxController {
  RxString generateUrl = ''.obs;
  Rx<File?> showImage = Rx<File?>(null);
  Rx<File?> pickedImage = Rx<File?>(null);
  RxString selectedValue = 'Smooth Symbol'.obs;
  RxString showSelectedValue = 'Smooth Symbol'.obs;
  List<String> items = ['Smooth Symbol', 'Rounded Symbol'];
  RxBool menuOpen = false.obs;
  RxBool downloadLoading = false.obs;
  final ScreenshotController screenshotController = ScreenshotController();
  // -----Image  position
  RxString showImagePostionItem = 'Embedded'.obs;
  RxString selectedImagePostionItem = 'Embedded'.obs;
  List<String> imagePostionItems = ['Embedded', 'Background', 'Foreground'];

  //----Foreground Colors
  Rx<Color> onSelectedForegroundColor = Colors.black.obs;
  Rx<Color> showForegroundColor = Colors.black.obs;
  Rx<Color> selectedForegroundColor = Colors.black.obs;
  //----Background Colors
  Rx<Color> onSelectedBackgroundColor = Colors.white.obs;
  Rx<Color> showBackgroundColor = Colors.white.obs;
  Rx<Color> selectedBackgroundColor = Colors.white.obs;

  void foregroundColorChange() {
    selectedForegroundColor.value = onSelectedForegroundColor.value;
  }

  void onSelectedforegroundColorChange(Color color) {
    onSelectedForegroundColor.value = color;
  }

  void backgroundColorChange() {
    selectedBackgroundColor.value = onSelectedBackgroundColor.value;
  }

  void onSelectedBackgroundColorChange(Color color) {
    onSelectedBackgroundColor.value = color;
  }

  // --- Function for pick image for gallery
  void pickAndStoreImage() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        // If no image is picked, return null
        return null;
      }
      pickedImage.value = File(image.path);
    } catch (e) {
      if (kDebugMode) {
        print("Something Went Wrong. Error: $e");
      }
    }
  }

  //Function for download generated QR code
  Future<void> captureAndSaveImage() async {
    try {
      downloadLoading.value = true;
      // Capture the screenshot
      final Uint8List? uint8list = await screenshotController.capture();

      if (uint8list != null) {
        // Request storage permission
        final PermissionStatus status = await Permission.photos.request();

        if (status.isGranted) {
          // If permission is granted, save the image
          final result = await SaverGallery.saveImage(
            uint8list, // Pass the uint8list as the first argument
            fileName:
                'scangen_generatedqr-${DateTime.now().millisecondsSinceEpoch}',
            skipIfExists: true,
          );
          if (result.isSuccess) {
            HelperFunction.showSnackbar(
                text: "Downloaded successfully",
                context: Get.context!,
                color: AppColors.primary);
          } else {
            downloadLoading.value = false;
            HelperFunction.showSnackbar(
                text: "Failed to download QR code",
                context: Get.context!,
                color: Colors.red);
          }
        } else if (status.isDenied) {
          downloadLoading.value = false;
          // If permission is denied, request again for photos permission
          final PermissionStatus newStatus = await Permission.photos.request();
          if (newStatus.isGranted) {
            // Save the image after permission is granted
            final result = await SaverGallery.saveImage(
              uint8list, // Pass the uint8list as the first argument
              fileName:
                  'scangen_generatedqr-${DateTime.now().millisecondsSinceEpoch}',
              skipIfExists: true,
            );
            if (result.isSuccess) {
              HelperFunction.showSnackbar(
                  text: "Downloaded successfully",
                  context: Get.context!,
                  color: AppColors.primary);
            } else {
              downloadLoading.value = false;
              HelperFunction.showSnackbar(
                  text: "Failed to download QR code",
                  context: Get.context!,
                  color: Colors.red);
            }
          } else {
            downloadLoading.value = false;
            HelperFunction.showSnackbar(
                text: "Permission denied. Unable to download.",
                context: Get.context!,
                color: Colors.red);
          }
        } else if (status.isPermanentlyDenied) {
          downloadLoading.value = false;
          // If permission is permanently denied, guide the user to settings
          HelperFunction.showSnackbar(
              text:
                  "Permission permanently denied. Please enable it from settings.",
              context: Get.context!,
              color: Colors.red);
          // Optionally, open app settings
          await openAppSettings();
        }
      } else {
        downloadLoading.value = false;
        // Handle screenshot capture failure
        if (kDebugMode) {
          print("Screenshot capture failed.");
        }
        HelperFunction.showSnackbar(
            text: "Failed to capture QR code. Please try again.",
            context: Get.context!,
            color: Colors.red);
      }
    } catch (e) {
      downloadLoading.value = false;
      // Handle any unexpected errors
      if (kDebugMode) {
        print(
            "Something went wrong while downloading QR code image. Error: $e");
      }
      HelperFunction.showSnackbar(
          text: "An error occurred. Please try again.",
          context: Get.context!,
          color: Colors.red);
    } finally {
      downloadLoading.value = false;
    }
  }

  // -----Generate Button Press-- Function
  void generateQR(String textField, FocusNode focusNode, BuildContext context,
      GlobalKey<FormState> fromkey) {
    if (fromkey.currentState!.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());
      generateUrl.value = textField.trim();
      showSelectedValue.value = selectedValue.value;
      showImage.value = pickedImage.value;
      showImagePostionItem.value = selectedImagePostionItem.value;
      showForegroundColor.value = selectedForegroundColor.value;
      showBackgroundColor.value = selectedBackgroundColor.value;
    }
  }
}
