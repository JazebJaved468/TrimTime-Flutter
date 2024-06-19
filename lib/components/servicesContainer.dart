import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/providers/sample_provider.dart';

class Services extends StatelessWidget {
  // final bool clicked;
  // final VoidCallback onTap;
  final bool isSelected;
  final Map service;
  final bool isFirstCard;

  const Services({
    Key? key,
    // required this.onTap,
    required this.service,
    required this.isSelected,
    required this.isFirstCard,
    // required this.onTap,
    // required this.clicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SampleProvider sampleProvider =
        Provider.of<SampleProvider>(context, listen: false);

    // bool isSelected = sampleProvider.selectedService == service['serviceId'];

    return GestureDetector(
      onTap: () {
        sampleProvider.updateSelectedService(service['serviceId']);
      },

      // sampleProvider.updateSelectedService(service['serviceId']),
      child: Container(
        height: 160,
        width: 120,
        margin: EdgeInsets.only(right: 10, left: isFirstCard ? 16 : 0),
        decoration: BoxDecoration(
          color: isSelected ? CustomColors.peelOrange : CustomColors.charcoal,
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
              service['serviceName'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: CustomColors.white,
                fontFamily: 'Raleway',
              ),
            ),
            Text(
              service['price'].toString(),
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
