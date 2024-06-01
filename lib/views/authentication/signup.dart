import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trim_time/controller/google_authentication.dart';
import 'package:trim_time/views/home/home_barber.dart';
import 'package:trim_time/views/home/home_client.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isClient = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Text(
              'I am a:',
              style: TextStyle(fontSize: 24),
            ),
            ListTile(
              title: const Text('Client'),
              leading: Radio(
                value: true,
                groupValue: isClient,
                onChanged: (value) {
                  setState(() {
                    isClient = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Barber'),
              leading: Radio(
                value: false,
                groupValue: isClient,
                onChanged: (value) {
                  setState(() {
                    isClient = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential? userCredential = await signInWithGoogle();
                  // Handle what happens after successful login
                  if (userCredential != null) {
                    // Navigate to the respective home page based on user type
                    if (isClient) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ClientHomePage()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BarberHomePage()),
                      );
                    }
                  }
                } catch (e) {
                  // Handle sign in error
                  print(e);
                }
              },
              child: const Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
