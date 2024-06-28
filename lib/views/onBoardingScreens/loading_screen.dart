import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Future.delayed(Duration(seconds: 2), () {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => WelcomeScreen()),
    //   );
    // });
    return Scaffold(
      backgroundColor: CustomColors.gunmetal,
      body: Center(
        child: Container(
          // color: Colors.pink,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo
              SvgPicture.asset('assets/images/svgs/logo1.svg',
                  // Update with your logo asset path
                  height: screenHeight * .3,
                  width: screenWidth * .3),
              // Adjust size as needed

              // Loading Indicator
              Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.1),
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
