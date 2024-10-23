import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:scangen/Utils/Colors/app_colors.dart';

class HelperFunction {
  static Future<void> copyToClipboardAndShowSnackbar({
    required String text,
    required BuildContext context,
    int duration = 1,
  }) async {
    // Copy the text to clipboard
    await Clipboard.setData(ClipboardData(text: text));

    // Show the snackbar
    showSnackbar(
      text: 'Text copied to clipboard!',
      context: context,
      color: AppColors.primary,
      duration: duration,
    );
  }

  static void showSnackbar({
    required String text,
    required BuildContext context,
    required Color color,
    int duration = 2,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        duration: Duration(seconds: duration),
        content: Center(
            child: Text(
          text,
          style: const TextStyle(color: AppColors.white),
          maxLines: 2,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        )),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: color,
      ),
    );
  }

  static void simpleAnimationNavigation(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeIn;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  static void mostStrictAnimationNavigation(
      BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeIn;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(
            curve: curve,
          ));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
      (Route<dynamic> route) => false,
    );
  }

  static Future<dynamic> showColorPicker({
    required BuildContext context,
    required Color pickerColor,
    required String title,
    required void Function(Color) onColorChanged,
    required void Function() gotIt,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: Text(title)),
        content: SingleChildScrollView(
          child: ColorPicker(
            hexInputBar: true,
            pickerColor: pickerColor,
            onColorChanged: onColorChanged,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: gotIt,
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
