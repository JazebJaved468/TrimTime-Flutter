import 'package:flutter/material.dart';
import 'package:trim_time/controller/initialization.dart';
import 'package:trim_time/controller/local_storage.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/views/authentication/signup_page.dart';
import 'package:trim_time/views/barberScreens/home_barber.dart';
import 'package:trim_time/views/clientScreens/home_client.dart';
import 'package:trim_time/views/barberScreens/registeration_barber.dart';
import 'package:trim_time/views/clientScreens/registration_client.dart';
import 'package:trim_time/views/splashSreen/on_boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Map<String, dynamic> localData;

  _loadData() async {
    print('-----------------> Splash Screen Starts <-----------------');
    // await Future.delayed(const Duration(seconds: 4));

    await initializeApp();

    localData = await getDataFromLocalStorage();

    if (localData['isFirstVisit']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnBoardingScreen()),
      );
    } else {
      if (localData['uid'] != null) {
        final isRegistered = localData['userData']['isRegistered'];
        if (localData['isClient']) {
          if (isRegistered) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ClientHomePage()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ClientRegistrationPage(
                        photoURL: localData['userData']['photoURL'],
                        phoneNumber: localData['userData']['phoneNumber'],
                        email: localData['userData']['email'],
                        fullName: localData['userData']['name'],
                        gender: localData['userData']['gender'],
                      )),
            );
          }
        } else if (!localData['isClient']) {
          if (isRegistered) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BarberHomePage()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => BarberRegistrationPage(
                        photoURL: localData['userData']['photoURL'],
                        phoneNumber: localData['userData']['phoneNumber'],
                        email: localData['userData']['email'],
                        fullName: localData['userData']['name'],
                        gender: localData['userData']['gender'],
                        openingTime: localData['userData']['openingTime'],
                        closingTime: localData['userData']['closingTime'],
                        services: localData['userData']['services'],
                      )),
            );
          }
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Signup()),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}