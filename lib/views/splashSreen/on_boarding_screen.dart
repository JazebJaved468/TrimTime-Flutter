import 'package:flutter/material.dart';
import 'package:trim_time/controller/local_storage.dart';
import 'package:trim_time/views/sign_in.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('On Boarding Screen'),
          ElevatedButton(
              onPressed: () {
                updateBooleanDataInLocalStorage(
                    key: 'isFirstVisit', value: false);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                );
              },
              child: Text('get Started'))
        ],
      ),
    );
  }
}
