import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trim_time/colors/custom_colors.dart';

class BarberHomePage extends StatefulWidget {
  BarberHomePage({super.key});

  @override
  State<BarberHomePage> createState() => _BarberHomePageState();
}

class _BarberHomePageState extends State<BarberHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Barber Home Page'),
        ),
        body: const Center(
            child: SpinKitFadingCircle(
          color: CustomColors.peelOrange,
          size: 50.0,
        )));
  }
}
