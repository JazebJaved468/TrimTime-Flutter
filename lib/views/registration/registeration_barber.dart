import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/controller/date_time.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/models/local_storage_model.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/utilities/constants/constants.dart';
import 'package:trim_time/views/authentication/signup_page.dart';
import 'package:trim_time/views/home/home_barber.dart';
import 'package:trim_time/views/home/home_client.dart';

class BarberRegistrationPage extends StatefulWidget {
  BarberRegistrationPage({
    super.key,
    required this.photoURL,
    required this.phoneNumber,
    required this.email,
    required this.fullName,
    required this.gender,
    required this.openingTime,
    required this.closingTime,
  });

  final String photoURL;
  final String phoneNumber;
  final String email;
  final String fullName;
  final String gender;
  final int openingTime;
  final int closingTime;

  @override
  State<BarberRegistrationPage> createState() => _BarberRegistrationPageState();
}

class _BarberRegistrationPageState extends State<BarberRegistrationPage> {
  final isClient = false;
  bool _isLoading = true;

  late String genderDropDownValue;
  // = 'Male';
  late int openingTimeDropDownValue;
  late int closingTimeDropDownValue;

  late Map<String, dynamic> localData;

  // LocalStorageModel? localStorageData;

  _loadData() async {
    await Future.delayed(const Duration(seconds: 2));

    localData = await getDataFromLocalStorage();

    print('localDAta in registration page----> $localData');

    setState(() {
      genderDropDownValue = localData['userData']['gender'];
      openingTimeDropDownValue = localData['userData']['openingTime'];
      closingTimeDropDownValue = localData['userData']['closingTime'];
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
    final shopNameController = TextEditingController();
    final shopAddressController = TextEditingController();
    final shopPhoneNumberController = TextEditingController();
    ;
    TextEditingController addressController = TextEditingController();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("BArber's Registration Page"),
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
                        labelText: 'Your Address',
                      ),
                    ),
                    TextField(
                      maxLength: 70,
                      controller: shopNameController,
                      decoration: InputDecoration(
                        labelText: 'Shpo Name',
                      ),
                    ),
                    TextField(
                      maxLength: 70,
                      controller: shopAddressController,
                      decoration: InputDecoration(
                        labelText: 'Shop Address',
                      ),
                    ),
                    TextField(
                      maxLength: 11,
                      controller: shopPhoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Shop Phone Number',
                      ),
                    ),
                    DropdownButton(
                      // Initial Value
                      value: genderDropDownValue,

                      icon: const Icon(Icons.keyboard_arrow_down),

                      items: genders.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items.toUpperCase()),
                        );
                      }).toList(),

                      onChanged: (String? newValue) {
                        setState(() {
                          genderDropDownValue = newValue!;
                        });
                      },
                    ),
                    Text('Opening Time (Morning - Afternoon)'),
                    DropdownButton(
                      // Initial Value
                      value: openingTimeDropDownValue,

                      icon: const Icon(Icons.keyboard_arrow_down),

                      items: openingTimes.map((int time) {
                        return DropdownMenuItem(
                          value: time,
                          child: Text(time < 12
                              ? '$time AM'
                              : time == 12
                                  ? '12 PM'
                                  : '${time - 12} PM'),
                        );
                      }).toList(),

                      onChanged: (int? newValue) {
                        setState(() {
                          openingTimeDropDownValue = newValue!;
                        });
                      },
                    ),
                    Text('Closing Time (Evening - Night)'),
                    DropdownButton(
                      // Initial Value
                      value: closingTimeDropDownValue,

                      icon: const Icon(Icons.keyboard_arrow_down),

                      items: closingTimes.map((int time) {
                        return DropdownMenuItem(
                          value: time,
                          child: Text('${time - 12} PM'),
                        );
                      }).toList(),

                      onChanged: (int? newValue) {
                        setState(() {
                          closingTimeDropDownValue = newValue!;
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
                              'gender': genderDropDownValue.toLowerCase(),
                              'address': addressController.text,
                              'shopName': shopNameController.text,
                              'shopAddress': shopAddressController.text,
                              'openingTime': openingTimeDropDownValue,
                              'closingTime': closingTimeDropDownValue,
                              'shopPhoneNumber': shopPhoneNumberController.text,
                              'availability': generate7DaysSlots(
                                  DateTime.now(),
                                  openingTimeDropDownValue,
                                  closingTimeDropDownValue)
                            });

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BarberHomePage()),
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
