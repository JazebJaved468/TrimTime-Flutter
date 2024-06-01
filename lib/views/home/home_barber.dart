import 'package:flutter/material.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/views/authentication/signup_page.dart';

class BarberHomePage extends StatelessWidget {
  BarberHomePage({super.key});

  Map<String, dynamic>? localData;
  getLocalData() async {
    localData = await getDataFromLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barber Home Page'),
        actions: [
          IconButton(
            onPressed: () async {
              await signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Signup()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
          child: FutureBuilder(
        future: getLocalData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return Text(
              'Welcome Barber with userID \n${localData!['uid']} \n isClient: ${localData!['isClient']}');
        },
      )),
    );
  }
}
