import 'package:get/get.dart';
import 'package:scangen/Utils/Components/bottom_nav_menu.dart';
import 'package:scangen/Utils/Helper/helper_function.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashServices extends GetxController {
  Future<bool> checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> setFirstTimeToFalse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    HelperFunction.mostStrictAnimationNavigation(Get.context!, BottomNavMenu());
  }
}
