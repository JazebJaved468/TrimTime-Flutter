import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/controller/local_storage.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/barberScreens/home_barber.dart';
import 'package:trim_time/views/barberScreens/registeration_barber.dart';
import 'package:trim_time/views/clientScreens/home_client.dart';
import 'package:trim_time/views/clientScreens/registration_client.dart';
import 'package:trim_time/views/homescreenclient/homecontent.dart';
import 'package:trim_time/views/homescreenclient/homescreenclient.dart';
// import 'package:trim_time/views/sign_in.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isClient = true;

  // Future _handleLogin(BuildContext context) async {
  //   Map<String, dynamic> response = await signInWithGoogle(isClient: isClient);

  //   if (response['user'] != null) {
  //     final localData = await getDataFromLocalStorage();
  //     ;

  //     final isRegistered = localData['userData']['isRegistered'];

  //     if (response['existsInOtherCategory']) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text(
  //             'Account ALready exists in ${isClient ? 'barber' : 'client'} category'),
  //       ));
  //       await signOut();
  //     } else if (response['existsInItsOwnCategory'] && isClient) {
  //       if (isRegistered) {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => HomeScreen()),
  //         );
  //       } else {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => ClientRegistrationPage(
  //                     photoURL: localData['userData']['photoURL'],
  //                     phoneNumber: localData['userData']['phoneNumber'],
  //                     email: localData['userData']['email'],
  //                     fullName: localData['userData']['name'],
  //                     gender: localData['userData']['gender'],
  //                     shouldNavigate: true,
  //                   )),
  //         );
  //       }
  //     } else if (response['existsInItsOwnCategory'] && !isClient) {
  //       if (isRegistered) {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => BarberHomePage()),
  //         );
  //       } else {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => BarberRegistrationPage(
  //                     photoURL: localData['userData']['photoURL'],
  //                     phoneNumber: localData['userData']['phoneNumber'],
  //                     email: localData['userData']['email'],
  //                     fullName: localData['userData']['name'],
  //                     gender: localData['userData']['gender'],
  //                     openingTime: localData['userData']['openingTime'],
  //                     closingTime: localData['userData']['closingTime'],
  //                     services: localData['userData']['services'],
  //                     uid: localData['uid'],
  //                   )),
  //         );
  //       }
  //     } else if (!response['existsInItsOwnCategory']) {
  //       if (isClient) {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => ClientRegistrationPage(
  //                     photoURL: localData['userData']['photoURL'],
  //                     phoneNumber: localData['userData']['phoneNumber'],
  //                     email: localData['userData']['email'],
  //                     fullName: localData['userData']['name'],
  //                     gender: localData['userData']['gender'],
  //                     shouldNavigate: true,
  //                   )),
  //         );
  //       } else {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => BarberRegistrationPage(
  //                     photoURL: localData['userData']['photoURL'],
  //                     phoneNumber: localData['userData']['phoneNumber'],
  //                     email: localData['userData']['email'],
  //                     fullName: localData['userData']['name'],
  //                     gender: localData['userData']['gender'],
  //                     openingTime: localData['userData']['openingTime'],
  //                     closingTime: localData['userData']['closingTime'],
  //                     services: localData['userData']['services'],
  //                     uid: localData['uid'],
  //                   )),
  //         );
  //       }
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('Error in login. Please try again.'),
  //     ));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    SampleProvider sampleProvider =
        Provider.of<SampleProvider>(context, listen: false);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.gunmetal,
        body: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: screenWidth * .06),
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
                    // fontFamily: 'dmsans'
                  ),
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
                    // fontFamily: 'dmsans'
                  ),
                ),
                SizedBox(
                  height: screenHeight * .05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton("Client", isClient, () {
                      setState(() {
                        isClient = true;
                      });
                    }),
                    const SizedBox(width: 20),
                    _buildButton("Barber", !isClient, () {
                      setState(() {
                        isClient = false;
                      });
                    }),
                  ],
                ),
                SizedBox(
                  height: screenHeight * .2,
                  child: Consumer<SampleProvider>(
                    builder: (context, provider, child) {
                      // print(provider.signInCIP);
                      return provider.signInCIP
                          ? const SpinKitFadingCircle(
                              color: CustomColors.peelOrange,
                              size: 50.0,
                            )
                          : const SizedBox();
                    },
                  ),
                ),
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
                    onPressed: () async {
                      try {
                        sampleProvider.setSignInCIP(true);
                        await sampleProvider.handleLoginByProvider(
                            context: context, isClient: isClient);
                        sampleProvider.setSignInCIP(false);
                      } catch (e) {
                        print(e);
                      }
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
                            // fontFamily: 'dmsans',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
            // fontFamily: 'dmsans',
          ),
        ),
      ),
    );
  }
}
