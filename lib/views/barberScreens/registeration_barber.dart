import 'package:flutter/material.dart';

class BarberRegistrationPage extends StatefulWidget {
  BarberRegistrationPage({
    super.key,
    required this.photoURL,
    required this.phoneNumber,
    required this.email,
    required this.fullName,
    required this.gender,
    required this.openingTime,
    required this.closingTime,
    required this.services,
    required this.uid,
  });

  final String photoURL;
  final String phoneNumber;
  final String email;
  final String fullName;
  final String gender;
  final int openingTime;
  final int closingTime;
  final Map<String, dynamic> services;
  final String uid;

  @override
  State<BarberRegistrationPage> createState() => _BarberRegistrationPageState();
}

class _BarberRegistrationPageState extends State<BarberRegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
