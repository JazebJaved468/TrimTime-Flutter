import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trim_time/controller/google_authentication.dart';
import 'package:trim_time/views/authentication/signup.dart';

class ClientHomePage extends StatelessWidget {
  ClientHomePage({super.key});

  final User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    print('User is logged in ---> ${user}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Home Page'),
        actions: [
          IconButton(
            onPressed: () async {
              await signOut();
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Signup()),
              // );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(
        child: Text('Hello Client'),
      ),
    );
  }
}
