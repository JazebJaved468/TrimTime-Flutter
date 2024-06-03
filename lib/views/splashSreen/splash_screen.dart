import 'package:flutter/material.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/models/local_storage_model.dart';
import 'package:trim_time/views/authentication/signup_page.dart';
import 'package:trim_time/views/home/home_barber.dart';
import 'package:trim_time/views/home/home_client.dart';
import 'package:trim_time/views/registration/registeration_barber.dart';
import 'package:trim_time/views/registration/registration_client.dart';
import 'package:trim_time/views/splashSreen/on_boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Map<String, dynamic> localData;
  // LocalStorageModel? localStorageData;

  _loadData() async {
    print('in splash screen');
    // await Future.delayed(const Duration(seconds: 4));

    await initializeApp();

    localData = await getDataFromLocalStorage();
    // localStorageData = LocalStorageModel.fromJson(response!);

    // print(localStorageData?.isClient);
    // print(localStorageData?.uid);
    // print(localStorageData?.isFirstVisit);

    // print('firestoreData----> ${firestoreData}');

    if (localData['isFirstVisit']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnBoardingScreen()),
      );
    } else {
      if (localData['uid'] != null) {
        // var firestoreData = await getUserDataFromFirestore(
        //     localStorageData!.uid!, localStorageData!.isClient!);

        // print('<-------data from local storage----> \n $localData');

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
                      )),
            );
          }
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => BarberHomePage()),
          // );
        }

        //  else {
        // if (!localStorageData!.isClient!) {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => ClientRegistrationPage()),
        //   );
        // } else {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => BarberRegistrationPage()),
        //   );
        // }
        // }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Signup()),
        );
      }
    }

    // return response;
  }

  @override
  void initState() {
    // TODO: implement initState
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

    // FutureBuilder(
    //   future: _loadData(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Center(child: const CircularProgressIndicator());
    //     } else if (snapshot.hasError) {
    //       return const Text('Error');
    //     } else if (snapshot.hasData) {
    //       Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;

    //       if (data['uid'] != null) {
    //         if (data['isClient']) {
    //           return ClientHomePage();
    //         } else {
    //           return BarberHomePage();
    //         }
    //       } else {
    //         return const Signup();
    //       }
    //     }

    //   },
    // ),
  }
}
