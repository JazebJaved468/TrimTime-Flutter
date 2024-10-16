import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:developer';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/controller/date_time.dart';
import 'package:trim_time/controller/firestore.dart';
import 'package:trim_time/controller/local_storage.dart';

import 'package:trim_time/providers/sample_provider.dart';

import 'package:trim_time/controller/upload_image.dart';
import 'package:trim_time/utilities/constants/constants.dart';
import 'package:trim_time/views/barberScreens/home_barber.dart';
import 'package:trim_time/views/sign_in/sign_in.dart';

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
    required this.uid,
  });

  final String photoURL;
  final String phoneNumber;
  final String email;
  final String fullName;
  final String gender;
  final int openingTime;
  final int closingTime;
  final Map<String, dynamic> services;
  final String uid;

  @override
  State<BarberRegistrationPage> createState() => _BarberRegistrationPageState();
}

class _BarberRegistrationPageState extends State<BarberRegistrationPage> {
  final isClient = false;
  late bool? isProvidingHaircut;
  late bool? isProvidingShave;
  late bool? isProvidingBeardTrim;
  late bool? isProvidingMassage;

  Uint8List? _image;
  _loadData() {
    isProvidingHaircut = widget.services['1']['isProviding'];
    isProvidingShave = widget.services['2']['isProviding'];
    isProvidingBeardTrim = widget.services['3']['isProviding'];
    isProvidingMassage = widget.services['4']['isProviding'];
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    selectImage() async {
      Uint8List? img = await pickImage(ImageSource.gallery);
      if (img == null) return;

      log('image file size: ${img.lengthInBytes}');

      _image = img;
      appProvider.notifyListeners();
    }

    appProvider.isProvidingHaircut = widget.services['1']['isProviding'];
    appProvider.isProvidingShave = widget.services['2']['isProviding'];
    appProvider.isProvidingBeardTrim = widget.services['3']['isProviding'];
    appProvider.isProvidingMassage = widget.services['4']['isProviding'];

    TextEditingController fullNameController =
        TextEditingController(text: widget.fullName);
    TextEditingController nickNameController = TextEditingController();

    TextEditingController emailController =
        TextEditingController(text: widget.email);

    TextEditingController phoneNumberController =
        TextEditingController(text: widget.phoneNumber);
    TextEditingController haircutPriceController =
        TextEditingController(text: widget.services['1']['price'].toString());
    TextEditingController beardTrimPriceController =
        TextEditingController(text: widget.services['2']['price'].toString());
    TextEditingController shavePriceController =
        TextEditingController(text: widget.services['3']['price'].toString());
    TextEditingController massagePriceController =
        TextEditingController(text: widget.services['4']['price'].toString());

    final shopNameController = TextEditingController();
    final shopAddressController = TextEditingController();
    final shopPhoneNumberController = TextEditingController();
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Barber's Registration Page"),
          actions: [
            IconButton(
              onPressed: () async {
                await appProvider.handleLogoutByProvider();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const SignIn()),
                    (Route route) => false);
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Container(
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Register Yourself Here!'),
                Consumer<AppProvider>(builder: (builder, provider, child) {
                  return _image != null
                      ? Stack(children: [
                          Container(
                            // color: Colors.pink,
                            width: 126,
                            height: 126,
                          ),
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: MemoryImage(_image!),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: IconButton(
                              onPressed: () {},
                              icon: GestureDetector(
                                onTap: () {
                                  selectImage();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: CustomColors.peelOrange,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Icon(
                                    Icons.camera_alt_rounded,
                                    color: CustomColors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ])
                      : Stack(children: [
                          Container(
                            width: 126,
                            height: 126,
                          ),
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(appProvider
                                .localDataInProvider['userData']['photoURL']),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: IconButton(
                              onPressed: () {},
                              icon: GestureDetector(
                                onTap: () {
                                  selectImage();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: CustomColors.black,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    color: CustomColors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]);
                }),
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
                    labelText: 'Nick Name   (Optional)',
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
                  controller: shopNameController,
                  decoration: const InputDecoration(
                    labelText: 'Shop Name',
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
                  keyboardType: TextInputType.phone,
                  controller: shopPhoneNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Shop Phone Number',
                  ),
                ),
                Consumer<AppProvider>(
                  builder: (context, provider, child) {
                    return DropdownButton(
                      // Initial Value
                      value: provider.barberGender,

                      icon: const Icon(Icons.keyboard_arrow_down),

                      items: genders.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items.toUpperCase()),
                        );
                      }).toList(),

                      onChanged: (String? newValue) {
                        provider.updateBarberGender(newValue!);
                      },
                    );
                  },
                ),
                const Text('Opening Time (Morning - Afternoon)'),
                Consumer<AppProvider>(
                  builder: (context, provider, child) {
                    return DropdownButton(
                      // Initial Value
                      value: provider.barberOpeningTime,

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
                        provider.updateBarberOpeningTime(newValue!);
                      },
                    );
                  },
                ),
                const Text('Closing Time (Evening - Night)'),
                Consumer<AppProvider>(
                  builder: (context, provider, child) {
                    return DropdownButton(
                      // Initial Value
                      value: provider.barberClosingTime,

                      icon: const Icon(Icons.keyboard_arrow_down),

                      items: closingTimes.map((int time) {
                        return DropdownMenuItem(
                          value: time,
                          child: Text('${time - 12} PM'),
                        );
                      }).toList(),

                      onChanged: (int? newValue) {
                        provider.updateBarberClosingTime(newValue!);
                      },
                    );
                  },
                ),
                Row(
                  children: [
                    Consumer<AppProvider>(builder: (context, provider, child) {
                      return Checkbox(
                        value: provider.isProvidingHaircut,
                        onChanged: (bool? updatedValue) {
                          provider.setIsProvidingHaircut(updatedValue!);
                        },
                      );
                    }),
                    const Text('Haircut'),
                    const SizedBox(
                      width: 20,
                    ),
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
                    Consumer<AppProvider>(builder: (context, provider, child) {
                      return Checkbox(
                        value: provider.isProvidingShave,
                        onChanged: (bool? updatedValue) {
                          provider.setIsProvidingShave(updatedValue!);
                        },
                      );
                    }),
                    const Text('Shave'),
                    const SizedBox(
                      width: 20,
                    ),
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
                    Consumer<AppProvider>(builder: (context, provider, child) {
                      return Checkbox(
                        value: provider.isProvidingBeardTrim,
                        onChanged: (bool? updatedValue) {
                          provider.setIsProvidingBeardTrim(updatedValue!);
                        },
                      );
                    }),
                    const Text('Beard Trim'),
                    const SizedBox(
                      width: 20,
                    ),
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
                    Consumer<AppProvider>(builder: (context, provider, child) {
                      return Checkbox(
                        value: provider.isProvidingMassage,
                        onChanged: (bool? updatedValue) {
                          provider.setIsProvidingMassage(updatedValue!);
                        },
                      );
                    }),
                    const Text('Massage'),
                    const SizedBox(
                      width: 20,
                    ),
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
                Consumer<AppProvider>(builder: (context, provider, child) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    onPressed: () async {
                      if (appProvider.isProvidingShave! ||
                          appProvider.isProvidingShave! ||
                          appProvider.isProvidingBeardTrim! ||
                          appProvider.isProvidingMassage!) {
                        if (fullNameController.text.trim().isNotEmpty &&
                            phoneNumberController.text.trim().isNotEmpty &&
                            shopNameController.text.trim().isNotEmpty &&
                            shopAddressController.text.trim().isNotEmpty &&
                            shopPhoneNumberController.text.trim().isNotEmpty &&
                            haircutPriceController.text.trim().isNotEmpty &&
                            shavePriceController.text.trim().isNotEmpty &&
                            beardTrimPriceController.text.trim().isNotEmpty &&
                            massagePriceController.text.trim().isNotEmpty) {
                          provider.setSaveClientProfileCIP(true);

                          if (_image != null) {
                            final photo = await appProvider
                                .updateUserProflileImage(
                                    userId: appProvider
                                        .localDataInProvider['userData']['uid'],
                                    isClient: appProvider
                                            .localDataInProvider['userData']
                                        ['isClient'],
                                    file: _image);

                            await updateUserRegistrationDataInFirestore(
                                userId: widget.uid,
                                isClient: isClient,
                                data: {
                                  'isRegistered': true,
                                  'name': fullNameController.text,
                                  'nickName': nickNameController.text,
                                  'email': emailController.text,
                                  'phoneNumber': phoneNumberController.text,
                                  'gender':
                                      appProvider.barberGender.toLowerCase(),
                                  'shopName': shopNameController.text,
                                  'shopAddress': shopAddressController.text,
                                  'openingTime': appProvider.barberOpeningTime,
                                  'closingTime': appProvider.barberClosingTime,
                                  'shopPhoneNumber':
                                      shopPhoneNumberController.text,
                                  'availability': generate7DaysSlots(
                                      DateTime.now(),
                                      appProvider.barberOpeningTime,
                                      appProvider.barberClosingTime),
                                  'services': {
                                    '1': {
                                      'serviceId': '1',
                                      'isProviding':
                                          appProvider.isProvidingHaircut,
                                      'price': int.parse(
                                          haircutPriceController.text),
                                    },
                                    '2': {
                                      'serviceId': '2',
                                      'isProviding':
                                          appProvider.isProvidingShave,
                                      'price':
                                          int.parse(shavePriceController.text),
                                    },
                                    '3': {
                                      'serviceId': '3',
                                      'isProviding':
                                          appProvider.isProvidingBeardTrim,
                                      'price': int.parse(
                                          beardTrimPriceController.text),
                                    },
                                    '4': {
                                      'serviceId': '4',
                                      'isProviding':
                                          appProvider.isProvidingMassage,
                                      'price': int.parse(
                                          massagePriceController.text),
                                    },
                                  },
                                  'photoURL': photo == ''
                                      ? appProvider
                                              .localDataInProvider['userData']
                                          ['photoURL']
                                      : photo,
                                });
                          } else {
                            await updateUserRegistrationDataInFirestore(
                                userId: widget.uid,
                                isClient: isClient,
                                data: {
                                  'isRegistered': true,
                                  'name': fullNameController.text,
                                  'nickName': nickNameController.text,
                                  'email': emailController.text,
                                  'phoneNumber': phoneNumberController.text,
                                  'gender':
                                      appProvider.barberGender.toLowerCase(),
                                  'shopName': shopNameController.text,
                                  'shopAddress': shopAddressController.text,
                                  'openingTime': appProvider.barberOpeningTime,
                                  'closingTime': appProvider.barberClosingTime,
                                  'shopPhoneNumber':
                                      shopPhoneNumberController.text,
                                  'availability': generate7DaysSlots(
                                      DateTime.now(),
                                      appProvider.barberOpeningTime,
                                      appProvider.barberClosingTime),
                                  'services': {
                                    '1': {
                                      'serviceId': '1',
                                      'isProviding':
                                          appProvider.isProvidingHaircut,
                                      'price': int.parse(
                                          haircutPriceController.text),
                                    },
                                    '2': {
                                      'serviceId': '2',
                                      'isProviding':
                                          appProvider.isProvidingShave,
                                      'price':
                                          int.parse(shavePriceController.text),
                                    },
                                    '3': {
                                      'serviceId': '3',
                                      'isProviding':
                                          appProvider.isProvidingBeardTrim,
                                      'price': int.parse(
                                          beardTrimPriceController.text),
                                    },
                                    '4': {
                                      'serviceId': '4',
                                      'isProviding':
                                          appProvider.isProvidingMassage,
                                      'price': int.parse(
                                          massagePriceController.text),
                                    },
                                  },
                                });
                          }

                          await updateUserDataInLocalStorage(
                              data: await getUserDataFromFirestore(
                                  widget.uid, isClient));

                          provider.setSaveClientProfileCIP(false);
                          if (_image != null) {
                            appProvider.setProfileImageInBytes(_image);
                          }
                          if (mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BarberHomePage()),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content:
                                Text('Kindly fill all the required fields'),
                          ));
                        }
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Please provide at least one service'),
                        ));
                      }
                    },
                    child: Container(
                      height: 50,
                      child: Center(
                        child: provider.saveClientProfileCIP
                            ? const SpinKitFadingCircle(
                                color: CustomColors.white,
                                size: 26.0,
                              )
                            : const Text(
                                'Save Profile',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: CustomColors.white,
                                ),
                              ),
                      ),
                    ),
                  );
                })
              ],
            ),
          ),
        ));
  }
}
