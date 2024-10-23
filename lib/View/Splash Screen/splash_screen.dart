import 'package:flutter/material.dart';
import 'package:scangen/Utils/App%20Gradient/app_gradient.dart';
import 'package:scangen/Utils/sizes/app_size.dart';
import 'package:scangen/View/Splash%20Screen/splash_services/splash_services.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.primaryGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.03,
          ),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.1),
              Image.asset(
                "assets/images/banner.png",
                height: size.height * 0.5,
                width: size.width,
              ),
              const SizedBox(
                height: AppSizes.spacerBtwSections,
              ),
              FittedBox(
                child: Text(
                  "Welcome to Scangen!",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(
                height: AppSizes.spaceBtwItems,
              ),
              Flexible(
                child: Text(
                  "Effortlessly scan QR codes and barcodes with lightning speed or create your own custom QR codes in just a few taps. Whether it's for quick access or personal use, Scangen has you covered!",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const SizedBox(
                height: AppSizes.spacerBtwSections,
              ),
              SizedBox(
                width: size.width * 0.7,
                child: ElevatedButton(
                  onPressed: () async {
                    await SplashServices.setFirstTimeToFalse();
                  },
                  child: FittedBox(
                    child: Text(
                      "Continue",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
