import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:scangen/Theme/theme_data.dart';
import 'package:scangen/Utils/Components/bottom_nav_menu.dart';
import 'package:scangen/View/Splash%20Screen/splash_screen.dart';
import 'package:scangen/View/Splash%20Screen/splash_services/splash_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> firstTimeCheck() async {
    return await SplashServices().checkFirstTime();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scangen',
      theme: CustomThemeData.customTheme,
      home: FutureBuilder<bool>(
        future: firstTimeCheck(),
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (snapshot.hasData) {
            if (data == true) {
              return const SplashScreen();
            } else {
              return BottomNavMenu();
            }
          } else {
            return const SplashScreen();
          }
        },
      ),
    );
  }
}
