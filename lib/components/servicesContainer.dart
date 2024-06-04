import 'package:flutter/material.dart';
import 'package:trim_time/colors/custom_colors.dart';

class Services extends StatelessWidget {
  final bool clicked;
  final VoidCallback onTap;
  final String service;

  const Services({
    Key? key,
    required this.onTap,
    required this.service,
    required this.clicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 160,
        width: 120,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: clicked ? CustomColors.peelOrange : CustomColors.charcoal,
          border: Border.all(color: CustomColors.peelOrange),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Image.asset(
                  'assets/images/1.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              service,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: CustomColors.white,
                fontFamily: 'Raleway',
              ),
            ),
            Text(
              'Rs. 300',
              style: TextStyle(
                color: CustomColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
