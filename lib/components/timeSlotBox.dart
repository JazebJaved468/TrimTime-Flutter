import 'package:flutter/material.dart';
import 'package:trim_time/colors/custom_colors.dart';

class TimeSlot extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final String time;

  const TimeSlot({Key? key, required this.isSelected, required this.onTap, required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(5),
        width: 120,
        height: 39,
        decoration: BoxDecoration(
          color: isSelected ? CustomColors.peelOrange : CustomColors.transparent,
          borderRadius: const BorderRadius.all(
            Radius.circular(50),
          ),
          border: Border.all(color: CustomColors.peelOrange),
        ),
        child: Center(
          child: Text(
            time,
            style: TextStyle(
              color: isSelected ? CustomColors.white : CustomColors.peelOrange,
              fontFamily: 'Poppins',
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}