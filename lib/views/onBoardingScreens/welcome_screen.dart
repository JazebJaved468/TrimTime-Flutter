import 'package:flutter/material.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/views/onBoardingScreens/get_started_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          padding: EdgeInsets.only(bottom: 40, left: 25),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/welcome_bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to 👋 ',
                style: TextStyle(
                    color: CustomColors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'rubik'),
              ),
              SizedBox(
                height: 1,
              ),
              Text(
                'Trim Timer',
                style: TextStyle(
                    color: CustomColors.peelOrange,
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'dmsans'),
              ),
              SizedBox(height: 10),
              Text(
                "The best barber & salon app in the \ncountry for your good looks and beauty.",
                style: TextStyle(color: CustomColors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
