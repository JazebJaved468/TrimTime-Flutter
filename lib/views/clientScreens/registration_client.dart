import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
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

  InputDecoration getTextFieldDecoration({required String placeHolderText}) {
    return InputDecoration(
      counterText: "",

      alignLabelWithHint: true,
      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
      // labelText: 'Full Name',
      hintText: placeHolderText,
      hintStyle: TextStyle(color: CustomColors.white.withOpacity(0.6)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: CustomColors.charcoal,
    );
  }

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
    return SafeArea(
      child: Scaffold(
          // resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: CustomColors.gunmetal,
            title: const Text(
              "Set Your Profile",
              style: TextStyle(
                  color: CustomColors.white, fontWeight: FontWeight.w600),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  await signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const SignIn()),
                      (Route route) => false);
                },
                icon: const Icon(
                  Icons.logout,
                  color: CustomColors.white,
                ),
              ),
            ],
          ),
          body: Container(
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            color: CustomColors.gunmetal,
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  // const Text('Register Yourself Here!'),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(sampleProvider
                        .localDataInProvider['userData']['photoURL']),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  TextField(
                    cursorColor: CustomColors.white.withOpacity(1),
                    cursorRadius: Radius.circular(10),
                    cursorOpacityAnimates: true,
                    decoration:
                        getTextFieldDecoration(placeHolderText: 'Full Name'),
                    style: TextStyle(
                      fontSize: 16,
                      color: CustomColors.white,
                    ),
                    maxLength: 30,
                    controller: fullNameController,
                  ),

                  SizedBox(
                    height: 16,
                  ),

                  // not styled
                  TextField(
                    cursorColor: CustomColors.white.withOpacity(1),
                    cursorRadius: Radius.circular(10),
                    cursorOpacityAnimates: true,
                    maxLength: 30,
                    controller: nickNameController,
                    decoration:
                        getTextFieldDecoration(placeHolderText: 'Nick Name'),
                    style: TextStyle(
                      fontSize: 16,
                      color: CustomColors.white,
                    ),
                  ),

                  SizedBox(
                    height: 16,
                  ),
                  TextField(
                    enabled: false,
                    controller: emailController,
                    decoration:
                        getTextFieldDecoration(placeHolderText: 'Email'),
                    style: TextStyle(
                      fontSize: 16,
                      color: CustomColors.white.withOpacity(0.5),
                    ),
                  ),

                  SizedBox(
                    height: 16,
                  ),
                  TextField(
                    cursorColor: CustomColors.white.withOpacity(1),
                    cursorRadius: Radius.circular(10),
                    cursorOpacityAnimates: true,
                    maxLength: 11,
                    keyboardType: TextInputType.phone,
                    controller: phoneNumberController,
                    decoration:
                        getTextFieldDecoration(placeHolderText: 'Phone Number'),
                    style: TextStyle(
                      fontSize: 16,
                      color: CustomColors.white,
                    ),
                  ),

                  SizedBox(
                    height: 16,
                  ),
                  TextField(
                    cursorColor: CustomColors.white.withOpacity(1),
                    cursorRadius: Radius.circular(10),
                    cursorOpacityAnimates: true,
                    maxLength: 70,
                    controller: addressController,
                    decoration:
                        getTextFieldDecoration(placeHolderText: 'Address'),
                    style: TextStyle(
                      fontSize: 16,
                      color: CustomColors.white,
                    ),
                  ),

                  SizedBox(
                    height: 16,
                  ),
                  Consumer<SampleProvider>(
                    builder: (context, provider, child) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 10),
                        decoration: BoxDecoration(
                          color: CustomColors.charcoal,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton(
                          dropdownColor: CustomColors.charcoal.withOpacity(1),

                          borderRadius: BorderRadius.circular(10),
                          alignment: Alignment.bottomLeft,
                          isDense: true,
                          elevation: 0,
                          underline: SizedBox(
                            width: 0,
                            height: 0,
                          ),
                          iconSize: 24,

                          isExpanded: true,
                          // Initial Value
                          value: provider.clientGender,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),

                          iconEnabledColor: CustomColors.white,
                          // icon: const Icon(Icons.keyboard_arrow_down),

                          items: genders.map((String item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(
                                item.toUpperCase(),
                                style: TextStyle(
                                  color: CustomColors.white,
                                ),
                              ),
                            );
                          }).toList(),

                          onChanged: (String? newValue) {
                            provider.updateClientGEnder(newValue!);
                          },
                        ),
                      );
                    },
                  ),

                  Consumer<SampleProvider>(builder: (context, provider, child) {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 30.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            backgroundColor: CustomColors.peelOrange,
                            // padding: const EdgeInsets.symmetric(
                            //     vertical: 14.0, horizontal: 0.0),
                          ),
                          onPressed: () async {
                            print('before firebase function call');

                            if (fullNameController.text.trim().isNotEmpty &&
                                nickNameController.text.trim().isNotEmpty &&
                                phoneNumberController.text.trim().isNotEmpty &&
                                addressController.text.trim().isNotEmpty) {
                              provider.setSaveClientProfileCIP(true);
                              await updateUserRegistrationDataInFirestore(
                                  userId: sampleProvider
                                      .localDataInProvider['userData']['uid'],
                                  isClient: sampleProvider
                                          .localDataInProvider['userData']
                                      ['isClient'],
                                  data: {
                                    'isRegistered': true,
                                    'name': fullNameController.text,
                                    'nickName': nickNameController.text,
                                    'email': emailController.text,
                                    'phoneNumber': phoneNumberController.text,
                                    'gender': sampleProvider.clientGender
                                        .toLowerCase(),
                                    'address': addressController.text,
                                  });

                              sampleProvider
                                  .updateUserDataInLocalStorageByProvider();

                              provider.setSaveClientProfileCIP(false);

                              if (mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen()),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Kindly fill all the fields"),
                                ),
                              );
                            }
                          },
                          child: Container(
                              height: 50,
                              child: Center(
                                child: provider.saveClientProfileCIP
                                    ? SpinKitFadingCircle(
                                        color: CustomColors.charcoal,
                                        size: 26.0,
                                      )
                                    : Text(
                                        'Save Profile',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: CustomColors.white,
                                        ),
                                      ),
                              ))),
                    );
                  }),
                ],
              ),
            ),
          )),
    );
  }
}
