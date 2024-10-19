import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/barberScreens/home_barber.dart';
import 'package:trim_time/views/barberScreens/registeration_barber.dart';
import 'package:trim_time/views/clientRegisteration/registration_client.dart';
import 'package:trim_time/views/homescreenclient/homescreenclient.dart';
import 'package:trim_time/views/onBoardingScreens/loading_screen.dart';
import 'package:trim_time/views/onBoardingScreens/welcome_screen.dart';
import 'package:trim_time/views/sign_in/sign_in.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Map<String, dynamic> localData;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    appProvider.initializeAppByProvider();

    return Consumer<AppProvider>(builder: (context, provider, child) {
      if (mounted && provider.isAppInitialLoading) {
        return const LoadingScreen();
      } else if (provider.localDataInProvider['isFirstVisit']) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        });
      } else if (provider.localDataInProvider['uid'] != null) {
        final isRegistered =
            provider.localDataInProvider['userData']['isRegistered'];
        if (provider.localDataInProvider['isClient']) {
          if (isRegistered) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ClientRegistrationPage(
                          photoURL: provider.localDataInProvider['userData']
                              ['photoURL'],
                          phoneNumber: provider.localDataInProvider['userData']
                              ['phoneNumber'],
                          email: provider.localDataInProvider['userData']
                              ['email'],
                          fullName: provider.localDataInProvider['userData']
                              ['name'],
                          gender: provider.localDataInProvider['userData']
                              ['gender'],
                        )),
              );
            });
          }
        } else if (!provider.localDataInProvider['isClient']) {
          if (isRegistered) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => BarberHomePage()),
              );
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => BarberRegistrationPage(
                          photoURL: provider.localDataInProvider['userData']
                              ['photoURL'],
                          phoneNumber: provider.localDataInProvider['userData']
                              ['phoneNumber'],
                          email: provider.localDataInProvider['userData']
                              ['email'],
                          fullName: provider.localDataInProvider['userData']
                              ['name'],
                          gender: provider.localDataInProvider['userData']
                              ['gender'],
                          openingTime: provider.localDataInProvider['userData']
                              ['openingTime'],
                          closingTime: provider.localDataInProvider['userData']
                              ['closingTime'],
                          services: provider.localDataInProvider['userData']
                              ['services'],
                          uid: provider.localDataInProvider['uid'],
                        )),
              );
            });
          }
        }
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const SignIn()),
              (Route route) => false);
        });
      }

      return const LoadingScreen();
    });
  }
}
