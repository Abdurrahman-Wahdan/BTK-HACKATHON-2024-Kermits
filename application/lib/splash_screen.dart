import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:btk/home_page.dart';
import 'package:btk/navbar.dart';
import 'package:btk/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: SingleChildScrollView(
        // Wrap in SingleChildScrollView
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: LottieBuilder.asset(
                  "assets/Lottie/Animation - 1729793817443.json"),
            ),
          ],
        ),
      ),
      nextScreen: NavigationMenu(),
      splashIconSize: 400,
      backgroundColor: Colors.white,
    );
  }
}
