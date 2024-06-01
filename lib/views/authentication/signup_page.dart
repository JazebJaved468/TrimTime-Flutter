import 'package:flutter/material.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/views/authentication/registration_page.dart';
import 'package:trim_time/views/home/home_barber.dart';
import 'package:trim_time/views/home/home_client.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isClient = true;

  Future _handleLogin(BuildContext context) async {
    Map<String, dynamic> response = await signInWithGoogle(isClient: isClient);

    if (response['user'] != null) {
      if (response['existsInOtherCategory']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Account ALready exists in ${isClient ? 'barber' : 'client'} category'),
        ));
        await signOut();
      } else if (response['existsInItsOwnCategory'] && isClient) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClientHomePage()),
        );
      } else if (response['existsInItsOwnCategory'] && !isClient) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BarberHomePage()),
        );
      } else if (!response['existsInItsOwnCategory']) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RegistrationPage(
                    isClient: isClient,
                  )),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error in login. Please try again.'),
      ));
    }

    setState(() {
      _isLoading = false;
    });
  }

  bool _isLoading = false;

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
                  setState(() {
                    _isLoading = true;
                  });
                  _handleLogin(context);
                  // UserCredential? userCredential =
                  // Map<String, dynamic> loginResponse =
                  //     await signInWithGoogle(isClient: isClient);

                  // print('loginResponse----> ${(loginResponse)}');

                  // Handle what happens after successful login
                  // if (userCredential != null) {
                  // Navigate to the respective home page based on user type
                  // if (isClient) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => ClientHomePage()),
                  //   );
                  // } else {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => BarberHomePage()),
                  //   );
                  // }
                  // }
                } catch (e) {
                  // Handle sign in error
                  print(e);
                }
              },
              child: const Text('Sign in with Google'),
            ),
            _isLoading ? const CircularProgressIndicator() : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
