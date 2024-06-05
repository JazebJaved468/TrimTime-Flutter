import 'package:flutter/material.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/views/barberScreens/home_barber.dart';
import 'package:trim_time/views/clientScreens/home_client.dart';
import 'package:trim_time/views/barberScreens/registeration_barber.dart';
import 'package:trim_time/views/clientScreens/registration_client.dart';

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
      final localData = await getDataFromLocalStorage();
      ;

      final isRegistered = localData['userData']['isRegistered'];

      if (response['existsInOtherCategory']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Account ALready exists in ${isClient ? 'barber' : 'client'} category'),
        ));
        await signOut();
      } else if (response['existsInItsOwnCategory'] && isClient) {
        // localData

        // isRegistered = localData['isRegistered'];

        if (isRegistered) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ClientHomePage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ClientRegistrationPage(
                      photoURL: localData['userData']['photoURL'],
                      phoneNumber: localData['userData']['phoneNumber'],
                      email: localData['userData']['email'],
                      fullName: localData['userData']['name'],
                      gender: localData['userData']['gender'],
                    )),
          );
        }
      } else if (response['existsInItsOwnCategory'] && !isClient) {
        if (isRegistered) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BarberHomePage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BarberRegistrationPage(
                      photoURL: localData['userData']['photoURL'],
                      phoneNumber: localData['userData']['phoneNumber'],
                      email: localData['userData']['email'],
                      fullName: localData['userData']['name'],
                      gender: localData['userData']['gender'],
                      openingTime: localData['userData']['openingTime'],
                      closingTime: localData['userData']['closingTime'],
                      services: localData['userData']['services'],
                    )),
          );
        }
      } else if (!response['existsInItsOwnCategory']) {
        if (isClient) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ClientRegistrationPage(
                      photoURL: localData['userData']['photoURL'],
                      phoneNumber: localData['userData']['phoneNumber'],
                      email: localData['userData']['email'],
                      fullName: localData['userData']['name'],
                      gender: localData['userData']['gender'],
                    )),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BarberRegistrationPage(
                      photoURL: localData['userData']['photoURL'],
                      phoneNumber: localData['userData']['phoneNumber'],
                      email: localData['userData']['email'],
                      fullName: localData['userData']['name'],
                      gender: localData['userData']['gender'],
                      openingTime: localData['userData']['openingTime'],
                      closingTime: localData['userData']['closingTime'],
                      services: localData['userData']['services'],
                    )),
          );
        }
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {},
          )),
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
                } catch (e) {
                  // Handle sign in error
                  print(e);
                }
              },
              child: const Text('Sign in with Google'),
            ),
            _isLoading ? const CircularProgressIndicator() : const SizedBox(),
            Text('Extra Light', style: TextStyle(fontWeight: FontWeight.w100)),
            Text('Light', style: TextStyle(fontWeight: FontWeight.w200)),
            Text('Regular', style: TextStyle(fontWeight: FontWeight.w300)),
            Text('Medium', style: TextStyle(fontWeight: FontWeight.w400)),
            Text('Semi Bold', style: TextStyle(fontWeight: FontWeight.w500)),
            Text('Bold', style: TextStyle(fontWeight: FontWeight.w600)),
            Text('Extra Bold', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
