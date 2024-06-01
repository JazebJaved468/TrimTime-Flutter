import 'package:flutter/material.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/views/authentication/signup_page.dart';
import 'package:trim_time/views/home/home_barber.dart';
import 'package:trim_time/views/home/home_client.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _loadData() async {
    await Future.delayed(const Duration(seconds: 2));

    return await getDataFromLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Text('Error');
          } else if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;

            if (data['uid'] != null) {
              if (data['isClient'] == true) {
                return ClientHomePage();
              } else {
                return BarberHomePage();
              }
            } else {
              return const Signup();
            }
          }

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
