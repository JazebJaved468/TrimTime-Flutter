import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trim_time/colors/custom_colors.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isClient = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.gunmetal,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
            padding: EdgeInsets.only(top: 15),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/signin_logo.png',
                  height: screenHeight * .3,
                  width: screenWidth * .5,
                ),
                SizedBox(
                  height: screenHeight * .01,
                ),
                const Text(
                  "Let's you in",
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.white,
                      fontFamily: 'dmsans'),
                ),
                SizedBox(
                  height: screenHeight * .05,
                ),
                const Text(
                  "Select Your Role",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: CustomColors.white,
                      fontFamily: 'dmsans'),
                ),
                SizedBox(
                  height: screenHeight * .05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton("Customer", isClient, () {
                      setState(() {
                        isClient = true;
                        print("cust");
                      });
                    }),
                    SizedBox(width: 20),
                    _buildButton("Barber", !isClient, () {
                      setState(() {
                        isClient = false;
                        print("brb");
                      });
                    }),
                  ],
                )
            ],
            ),),
            Container(
              padding: EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  const Text(
                  'Welcome to Trim Time!',
                  style: TextStyle(color: CustomColors.white),
                ),
                SizedBox(
                  height: screenHeight * .03,
                ),
                SizedBox(
                  width: 300, // Adjust the width as needed
                  child: OutlinedButton(
                    onPressed: () {
                      // Add your onPressed code here
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(29),
                      ),
                      side: const BorderSide(
                        color: Colors.transparent, // Remove border
                      ),
                      backgroundColor: const Color.fromARGB(
                          255, 52, 55, 66), // Background color of the button
                      padding: EdgeInsets.symmetric(
                          vertical:
                              screenHeight * .007), // Padding inside the button
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google_logo.png', // Path to your Google logo asset
                          height:
                              screenHeight * .05, // Adjust the size of the logo
                          width: screenWidth * .1,
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          "Continue with Google",
                          style: TextStyle(
                            color: Colors.white, // Text color
                            fontFamily: 'dmsans',
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                ],
              ),
            )
                
              ],
            ),
          ),
        ),
      );

  }

  Widget _buildButton(String text, bool isSelected, VoidCallback onPressed) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth * .4,
      height: 40,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: const BorderSide(
            color: CustomColors.peelOrange,
            width: 1,
          ),
          backgroundColor:
              isSelected ? CustomColors.peelOrange : Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : CustomColors.peelOrange,
            fontFamily: 'dmsans',
          ),
        ),
      ),
    );
  }
}
