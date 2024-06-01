import 'package:flutter/material.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/views/authentication/signup_page.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key, required this.isClient});

  final isClient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${isClient ? "Client's" : "Barber's"} Registration Page'),
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
      body: const Center(
        child: Text('Register Yourself Here!'),
      ),
    );
  }
}
