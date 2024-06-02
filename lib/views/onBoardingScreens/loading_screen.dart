import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trim_time/views/onBoardingScreens/welcome_screen.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    });
    return Scaffold(
      backgroundColor: CustomColors.gunmetal,
      body: Container(
        margin: const EdgeInsets.only(top: 300),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Logo
              Image.asset(
                'assets/images/C.png', // Update with your logo asset path
                height: 150.0,
                width: 150, // Adjust size as needed
              ),
              // const SizedBox(height: 100.0),
              // Loading Indicator
              Container(
                  margin: const EdgeInsets.only(top: 200),
                  child: const SpinKitFadingCircle(
                    color: CustomColors.peelOrange,
                    size: 50.0,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
