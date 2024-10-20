import 'package:flutter/material.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/components/CustomAppBar.dart';
import 'package:trim_time/components/EmptyList.dart';

class BarberReviews extends StatefulWidget {
  const BarberReviews({super.key});

  @override
  State<BarberReviews> createState() => _BarberReviewsState();
}

class _BarberReviewsState extends State<BarberReviews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Reviews',
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
