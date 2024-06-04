import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/utilities/constants/constants.dart';
import 'package:trim_time/views/authentication/signup_page.dart';
import 'package:trim_time/views/home/home_barber.dart';

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
    required this.services,
  });

  final String photoURL;
  final String phoneNumber;
  final String email;
  final String fullName;
  final String gender;
  final int openingTime;
  final int closingTime;
  final List services;

  @override
  State<BarberRegistrationPage> createState() => _BarberRegistrationPageState();
}

class _BarberRegistrationPageState extends State<BarberRegistrationPage> {
  final isClient = false;
  bool _isLoading = true;

  late String genderDropDownValue;
  late int openingTimeDropDownValue;
  late int closingTimeDropDownValue;
  late bool? isProvidingHaircut;
  late bool? isProvidingShave;
  late bool? isProvidingBeardTrim;
  late bool? isProvidingMassage;

  late Map<String, dynamic> localData;

  // LocalStorageModel? localStorageData;

  _loadData() async {
    await Future.delayed(const Duration(seconds: 2));

    localData = await getDataFromLocalStorage();

    print('------------>localData in barber registration page----> $localData');

    final _services = localData['userData']['services'];

    setState(() {
      isProvidingHaircut = _services[0]['isProviding'];
      isProvidingShave = _services[1]['isProviding'];
      isProvidingBeardTrim = _services[2]['isProviding'];
      isProvidingMassage = _services[3]['isProviding'];
      genderDropDownValue = localData['userData']['gender'];
      openingTimeDropDownValue = localData['userData']['openingTime'];
      closingTimeDropDownValue = localData['userData']['closingTime'];
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final sampleProvider = Provider.of<SampleProvider>(context, listen: false);

    sampleProvider.isProvidingHaircut = widget.services[0]['isProviding'];
    sampleProvider.isProvidingShave = widget.services[1]['isProviding'];
    sampleProvider.isProvidingBeardTrim = widget.services[2]['isProviding'];
    sampleProvider.isProvidingMassage = widget.services[3]['isProviding'];

    TextEditingController fullNameController =
        TextEditingController(text: widget.fullName);
    TextEditingController nickNameController = TextEditingController();

    TextEditingController emailController =
        TextEditingController(text: widget.email);

    TextEditingController phoneNumberController =
        TextEditingController(text: widget.phoneNumber);
    TextEditingController haircutPriceController =
        TextEditingController(text: widget.services[0]['price'].toString());
    TextEditingController beardTrimPriceController =
        TextEditingController(text: widget.services[2]['price'].toString());
    TextEditingController shavePriceController =
        TextEditingController(text: widget.services[1]['price'].toString());
    TextEditingController massagePriceController =
        TextEditingController(text: widget.services[3]['price'].toString());

    final shopNameController = TextEditingController();
    final shopAddressController = TextEditingController();
    final shopPhoneNumberController = TextEditingController();

    TextEditingController addressController = TextEditingController();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("BArber's Registration Page"),
          actions: [
            IconButton(
              onPressed: () async {
                await signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Signup()),
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const Text('Register Yourself Here!'),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage(localData['userData']['photoURL']),
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
                        labelText: 'Your Address',
                      ),
                    ),
                    TextField(
                      maxLength: 70,
                      controller: shopNameController,
                      decoration: const InputDecoration(
                        labelText: 'Shpo Name',
                      ),
                    ),
                    TextField(
                      maxLength: 70,
                      controller: shopAddressController,
                      decoration: const InputDecoration(
                        labelText: 'Shop Address',
                      ),
                    ),
                    TextField(
                      maxLength: 11,
                      controller: shopPhoneNumberController,
                      decoration: const InputDecoration(
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
                    const Text('Opening Time (Morning - Afternoon)'),
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
                    const Text('Closing Time (Evening - Night)'),
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
                    Row(
                      children: [
                        Consumer<SampleProvider>(
                            builder: (context, provider, child) {
                          return Checkbox(
                            value: provider.isProvidingHaircut,
                            onChanged: (bool? updatedValue) {
                              provider.setIsProvidingHaircut(updatedValue!);
                            },
                          );
                        }),
                        const Text('Haircut'),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            maxLength: 3,
                            controller: haircutPriceController,
                            decoration: const InputDecoration(
                              labelText: 'Price',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Consumer<SampleProvider>(
                            builder: (context, provider, child) {
                          return Checkbox(
                            value: provider.isProvidingShave,
                            onChanged: (bool? updatedValue) {
                              provider.setIsProvidingShave(updatedValue!);
                            },
                          );
                        }),
                        const Text('Shave'),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            maxLength: 3,
                            controller: shavePriceController,
                            decoration: const InputDecoration(
                              labelText: 'Price',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Consumer<SampleProvider>(
                            builder: (context, provider, child) {
                          return Checkbox(
                            value: provider.isProvidingBeardTrim,
                            onChanged: (bool? updatedValue) {
                              provider.setIsProvidingBeardTrim(updatedValue!);
                            },
                          );
                        }),
                        const Text('Beard Trim'),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            maxLength: 3,
                            controller: beardTrimPriceController,
                            decoration: const InputDecoration(
                              labelText: 'Price',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Consumer<SampleProvider>(
                            builder: (context, provider, child) {
                          return Checkbox(
                            value: provider.isProvidingMassage,
                            onChanged: (bool? updatedValue) {
                              provider.setIsProvidingMassage(updatedValue!);
                            },
                          );
                        }),
                        const Text('Massage'),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            maxLength: 3,
                            controller: massagePriceController,
                            decoration: const InputDecoration(
                              labelText: 'Price',
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (sampleProvider.isProvidingShave! ||
                            sampleProvider.isProvidingShave! ||
                            sampleProvider.isProvidingBeardTrim! ||
                            sampleProvider.isProvidingMassage!) {
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
                                'shopPhoneNumber':
                                    shopPhoneNumberController.text,
                                'availability': generate7DaysSlots(
                                    DateTime.now(),
                                    openingTimeDropDownValue,
                                    closingTimeDropDownValue),
                                'services': [
                                  {
                                    'serviceId': '1',
                                    'isProviding':
                                        sampleProvider.isProvidingHaircut,
                                    'price':
                                        int.parse(haircutPriceController.text),
                                  },
                                  {
                                    'serviceId': '2',
                                    'isProviding':
                                        sampleProvider.isProvidingShave,
                                    'price':
                                        int.parse(shavePriceController.text),
                                  },
                                  {
                                    'serviceId': '3',
                                    'isProviding':
                                        sampleProvider.isProvidingBeardTrim,
                                    'price': int.parse(
                                        beardTrimPriceController.text),
                                  },
                                  {
                                    'serviceId': '4',
                                    'isProviding':
                                        sampleProvider.isProvidingMassage,
                                    'price':
                                        int.parse(massagePriceController.text),
                                  },
                                ],
                              });

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BarberHomePage()),
                          );

                          await updateUserDataInLocalStorage(
                              data: await getUserDataFromFirestore(
                                  localData['uid'], isClient));
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content:
                                Text('Please provide at least one service'),
                          ));
                        }
                      },
                      child: const Text('Update Profile'),
                    ),
                  ],
                ),
              ));
  }
}
