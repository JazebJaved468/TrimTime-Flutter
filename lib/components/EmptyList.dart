import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trim_time/colors/custom_colors.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: 0.5,
            child: SvgPicture.asset(
              'assets/images/svgs/logo2.svg',
              width: 150,
            ),
          ),
          SizedBox(height: 30),
          Text(
            '$message',
            style: TextStyle(color: CustomColors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
