import 'package:flutter/material.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/components/CustomAppBar.dart';
import 'package:trim_time/components/EmptyList.dart';

class BarberBookings extends StatefulWidget {
  const BarberBookings({super.key});

  @override
  State<BarberBookings> createState() => _BarberBookingsState();
}

class _BarberBookingsState extends State<BarberBookings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Bookings',
          leftIcon: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: CustomColors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: CustomColors.gunmetal,
        body: EmptyList(message: 'Coming Soon'));
  }
}
