import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trim_time/colors/custom_colors.dart';

PreferredSizeWidget CustomAppBar({String title = ''}) {
  return AppBar(
    toolbarHeight: 50,
    centerTitle: true,
    titleTextStyle: TextStyle(
        color: CustomColors.white, fontSize: 18, fontWeight: FontWeight.w500),
    // backgroundColor: CustomColors.gunmetal,
    backgroundColor: CustomColors.peelOrange,
    title: Text(
      '$title',
    ),
  );
}