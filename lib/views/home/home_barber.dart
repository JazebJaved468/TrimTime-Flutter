import 'package:flutter/material.dart';
import 'package:trim_time/controller/google_authentication.dart';
import 'package:trim_time/views/authentication/signup.dart';

class BarberHomePage extends StatelessWidget {
  const BarberHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barber Home Page'),
        actions: [
          IconButton(
            onPressed: () async {
              await signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Signup()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(
        child: Text('Hello Barber'),
      ),
    );
  }
}
