import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/controller/firestore.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/utilities/constants/constants.dart';
import 'package:trim_time/views/homescreenclient/homescreenclient.dart';
import 'package:trim_time/views/sign_in.dart';

class ClientRegistrationPage extends StatefulWidget {
  ClientRegistrationPage({
    super.key,
    required this.photoURL,
    required this.phoneNumber,
    required this.email,
    required this.fullName,
    required this.gender,
  });

  final String photoURL;
  final String phoneNumber;
  final String email;
  final String fullName;
  final String gender;

  @override
  State<ClientRegistrationPage> createState() => _ClientRegistrationPageState();
}

class _ClientRegistrationPageState extends State<ClientRegistrationPage> {
  final isClient = true;

  late String dropDownValue;

  @override
  @override
  Widget build(BuildContext context) {
    SampleProvider sampleProvider =
        Provider.of<SampleProvider>(context, listen: false);

    TextEditingController fullNameController =
        TextEditingController(text: widget.fullName);
    TextEditingController nickNameController = TextEditingController();

    TextEditingController emailController =
        TextEditingController(text: widget.email);

    TextEditingController phoneNumberController =
        TextEditingController(text: widget.phoneNumber);

    TextEditingController addressController = TextEditingController();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Client's Registration Page"),
          actions: [
            IconButton(
              onPressed: () async {
                await signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const SignIn()),
                    (Route route) => false);
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Text('Register Yourself Here!'),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    sampleProvider.localDataInProvider['userData']['photoURL']),
              ),
              TextField(
                maxLength: 30,
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                ),
              ),
              TextField(
                maxLength: 30,
                controller: nickNameController,
                decoration: const InputDecoration(
                  labelText: 'Nick Name',
                ),
              ),
              TextField(
                enabled: false,
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextField(
                maxLength: 11,
                keyboardType: TextInputType.phone,
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),
              TextField(
                maxLength: 70,
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                ),
              ),
              Consumer<SampleProvider>(
                builder: (context, provider, child) {
                  return DropdownButton(
                    // Initial Value
                    value: provider.clientGender,

                    icon: const Icon(Icons.keyboard_arrow_down),

                    items: genders.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item.toUpperCase()),
                      );
                    }).toList(),

                    onChanged: (String? newValue) {
                      provider.updateClientGEnder(newValue!);
                    },
                  );
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  print('before firebase function call');
                  await updateUserRegistrationDataInFirestore(
                      userId: sampleProvider.localDataInProvider['userData']
                          ['uid'],
                      isClient: sampleProvider.localDataInProvider['userData']
                          ['isClient'],
                      data: {
                        'isRegistered': true,
                        'name': fullNameController.text,
                        'nickName': nickNameController.text,
                        'email': emailController.text,
                        'phoneNumber': phoneNumberController.text,
                        'gender': sampleProvider.clientGender.toLowerCase(),
                        'address': addressController.text,
                      });

                  print('after firebase function call');

                  sampleProvider.updateUserDataInLocalStorageByProvider();
                  print('after updateding local storage call');

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );

                  print('after navigation to home screen');
                  // }
                },
                child: const Text('Save Profile'),
              ),
            ],
          ),
        ));
  }
}
