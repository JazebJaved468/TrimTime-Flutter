import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/models/local_storage_model.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/authentication/signup_page.dart';
import 'package:trim_time/views/home/home_client.dart';

class ClientRegistrationPage extends StatefulWidget {
  ClientRegistrationPage(
      {super.key,
      required this.photoURL,
      required this.phoneNumber,
      required this.email,
      required this.fullName,
      required this.gender});

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
  bool _isLoading = true;
  List<String> genders = ['male', 'female'];

  late String dropDownValue;

  late Map<String, dynamic> localData;

  // LocalStorageModel? localStorageData;

  _loadData() async {
    await Future.delayed(const Duration(seconds: 2));

    localData = await getDataFromLocalStorage();

    print('localDAta in registration page----> $localData');

    setState(() {
      dropDownValue = localData['userData']['gender'];
      _isLoading = false;
    });

    print('after set state function');
    // localStorageData = LocalStorageModel.fromJson(response!);

    // return await getUserDataFromFirestore(localStorageData!.uid!, isClient);
  }

  // String dropDownValue = 'male';
  // List<String> genders = ['male', 'female'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();

    print('print after init state function');
  }

  @override
  Widget build(BuildContext context) {
    // print('email----> ${widget.email}');
    // print('number----> ${widget.phoneNumber}');
    // print('name----> ${widget.fullName}');
    // print('photoURL----> ${widget.photoURL}');
    SampleProvider provider =
        Provider.of<SampleProvider>(context, listen: true);

    TextEditingController fullNameController =
        TextEditingController(text: widget.fullName);
    TextEditingController nickNameController = TextEditingController();
    ;
    TextEditingController emailController =
        TextEditingController(text: widget.email);
    ;
    TextEditingController phoneNumberController =
        TextEditingController(text: widget.phoneNumber);
    ;
    final genderController = TextEditingController(text: widget.gender);
    ;
    TextEditingController addressController = TextEditingController();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Client's Registration Page"),
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
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Text('Register Yourself Here!'),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage(localData['userData']['photoURL']),
                    ),
                    TextField(
                      maxLength: 30,
                      controller: fullNameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                      ),
                    ),
                    TextField(
                      maxLength: 30,
                      controller: nickNameController,
                      decoration: InputDecoration(
                        labelText: 'Nick Name',
                      ),
                    ),
                    TextField(
                      enabled: false,
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    TextField(
                      maxLength: 11,
                      keyboardType: TextInputType.phone,
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                      ),
                    ),
                    TextField(
                      maxLength: 70,
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                      ),
                    ),
                    DropdownButton(
                      // Initial Value
                      value: dropDownValue,

                      icon: const Icon(Icons.keyboard_arrow_down),

                      items: genders.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item.toUpperCase()),
                        );
                      }).toList(),

                      onChanged: (String? newValue) {
                        setState(() {
                          dropDownValue = newValue!;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await updateUserRegistrationDataInFirestore(
                            userId: localData['uid'],
                            isClient: localData['isClient'],
                            data: {
                              'isRegistered': true,
                              'name': fullNameController.text,
                              'nickName': nickNameController.text,
                              'email': emailController.text,
                              'phoneNumber': phoneNumberController.text,
                              'gender': dropDownValue.toLowerCase(),
                              'address': addressController.text,
                            });

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ClientHomePage()),
                        );

                        await updateUserDataInLocalStorage(
                            data: await getUserDataFromFirestore(
                                localData['uid'], isClient));
                      },
                      child: Text('Update Profile'),
                    ),
                  ],
                ),
              ));

    // FutureBuilder(
    //     future: _loadData(),
    //     builder: (builder, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Center(child: CircularProgressIndicator());
    //       } else if (snapshot.hasError) {
    //         return Center(
    //           child: Text('Error: ${snapshot.error}'),
    //         );
    //       } else {
    //         final data = snapshot.data as Map<String, dynamic>;
    //         provider.userData = data;

    //         print('data from provider----> ${provider.userData}');
    //         return
    //       }
    //     }),
    // );
  }
}
