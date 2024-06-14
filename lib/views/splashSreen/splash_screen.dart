import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/controller/initialization.dart';
import 'package:trim_time/controller/local_storage.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/barberScreens/home_barber.dart';
import 'package:trim_time/views/clientScreens/home_client.dart';
import 'package:trim_time/views/barberScreens/registeration_barber.dart';
import 'package:trim_time/views/clientScreens/registration_client.dart';
import 'package:trim_time/views/homescreenclient/homecontent.dart';
import 'package:trim_time/views/homescreenclient/homescreenclient.dart';
import 'package:trim_time/views/onBoardingScreens/loading_screen.dart';
import 'package:trim_time/views/onBoardingScreens/welcome_screen.dart';
import 'package:trim_time/views/sign_in.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Map<String, dynamic> localData;

  // _loadData() async {
  //   print('-----------------> Splash Screen Starts <-----------------');
  //   await Future.delayed(const Duration(seconds: 2));

  //   await initializeApp();

  //   localData = await getDataFromLocalStorage();

  //   if (localData['isFirstVisit']) {
  //     Navigator.pushReplacement(
  //       context,

  //       // MaterialPageRoute(builder: (context) => OnBoardingScreen()),
  //       MaterialPageRoute(builder: (context) => WelcomeScreen()),
  //     );
  //   } else {
  //     if (localData['uid'] != null) {
  //       final isRegistered = localData['userData']['isRegistered'];
  //       if (localData['isClient']) {
  //         if (isRegistered) {
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(builder: (context) => HomeScreen()),
  //           );
  //         } else {
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => ClientRegistrationPage(
  //                       photoURL: localData['userData']['photoURL'],
  //                       phoneNumber: localData['userData']['phoneNumber'],
  //                       email: localData['userData']['email'],
  //                       fullName: localData['userData']['name'],
  //                       gender: localData['userData']['gender'],
  //                       shouldNavigate: true,
  //                     )),
  //           );
  //         }
  //       } else if (!localData['isClient']) {
  //         if (isRegistered) {
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(builder: (context) => BarberHomePage()),
  //           );
  //         } else {
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => BarberRegistrationPage(
  //                       photoURL: localData['userData']['photoURL'],
  //                       phoneNumber: localData['userData']['phoneNumber'],
  //                       email: localData['userData']['email'],
  //                       fullName: localData['userData']['name'],
  //                       gender: localData['userData']['gender'],
  //                       openingTime: localData['userData']['openingTime'],
  //                       closingTime: localData['userData']['closingTime'],
  //                       services: localData['userData']['services'],
  //                       uid: localData['uid'],
  //                     )),
  //           );
  //         }
  //       }
  //     } else {
  //       Navigator.of(context).pushAndRemoveUntil(
  //           MaterialPageRoute(builder: (context) => SignIn()),
  //           (Route route) => false);
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();

    // _loadData();
  }

  @override
  Widget build(BuildContext context) {
    SampleProvider sampleProvider =
        Provider.of<SampleProvider>(context, listen: false);

    sampleProvider.initializeAppByProvider();

    return Consumer<SampleProvider>(builder: (context, provider, child) {
      if (mounted && provider.isAppInitialLoading) {
        return LoadingScreen();
      } else if (provider.localDataInProvider['isFirstVisit']) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => WelcomeScreen()),
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
                MaterialPageRoute(builder: (context) => HomeScreen()),
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
                          // shouldNavigate: true,
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
              MaterialPageRoute(builder: (context) => SignIn()),
              (Route route) => false);
        });
      }

      return LoadingScreen();
      // else{
      // return LoadingScreen();

      // }
      // return provider.isAppInitialLoading  LoadingScreen();
    });
  }
}
