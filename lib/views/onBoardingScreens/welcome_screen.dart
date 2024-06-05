import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/views/onBoardingScreens/get_started_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GetStartedScreen()),
          );
        },
        child: Container(
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.only(bottom: 35, left: 25),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/welcome_bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            height: screenHeight * .28,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: TextStyle(
                      color: CustomColors.white,
                      fontSize: screenWidth * .109,
                      fontWeight: FontWeight.bold),
                  child: AnimatedTextKit(
                    totalRepeatCount: 1,
                    animatedTexts: [
                      TyperAnimatedText(
                        'Welcome to 👋 ',
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                    onTap: () {
                      print("Tap Event");
                    },
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Container(
                  height: screenHeight * .1,
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: screenWidth * 0.15,
                      color: CustomColors.peelOrange,
                      fontWeight: FontWeight.bold,
                    ),
                    child: Animate(
                      effects: [
                        FadeEffect(
                          delay: 1000.ms,
                        ),
                        const ScaleEffect(alignment: Alignment.centerLeft)
                      ],
                      child: const Text("Trim Time").animate(),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.00,
                ),
                Animate(
                  effects: [
                        FadeEffect(
                          delay: 1500.ms,
                        ),
                        const ScaleEffect(alignment: Alignment.centerLeft)
                      ],
                  child: Text(
                    "The best barber & salon app in the \ncountry for your good looks and beauty.",
                    style: TextStyle(
                        color: CustomColors.white, fontSize: screenWidth * 0.04),
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
