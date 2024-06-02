import 'package:flutter/material.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/models/local_storage_model.dart';
import 'package:trim_time/views/authentication/registration_page.dart';
import 'package:trim_time/views/authentication/signup_page.dart';
import 'package:trim_time/views/home/home_barber.dart';
import 'package:trim_time/views/home/home_client.dart';
import 'package:trim_time/views/splashSreen/on_boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Map<String, dynamic>? response;
  LocalStorageModel? localStorageData;

  _loadData() async {
    // await Future.delayed(const Duration(seconds: 4));

    await initializeApp();

    response = await getDataFromLocalStorage();
    localStorageData = LocalStorageModel.fromJson(response!);

    // print(localStorageData?.isClient);
    // print(localStorageData?.uid);
    // print(localStorageData?.isFirstVisit);

    if (localStorageData!.isFirstVisit!) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnBoardingScreen()),
      );
    } else {
      if (localStorageData!.uid != null) {
        if (localStorageData!.isClient!) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ClientHomePage()),
          );
        } else if (!localStorageData!.isClient!) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BarberHomePage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => RegistrationPage(
                      isClient: localStorageData!.isClient,
                    )),
          );
        }
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
