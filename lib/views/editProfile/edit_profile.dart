import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/components/CustomAppBar.dart';
import 'package:trim_time/controller/firestore.dart';
import 'package:trim_time/controller/upload_image.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/utilities/constants/constants.dart';

class EditProfileClient extends StatefulWidget {
  const EditProfileClient({super.key});

  @override
  State<EditProfileClient> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfileClient> {
  final isClient = true;

  // late String dropDownValue;

  InputDecoration getTextFieldDecoration({required String placeHolderText}) {
    return InputDecoration(
      counterText: "",

      alignLabelWithHint: true,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
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

  Uint8List? _image;
  // selectImage() async {
  //   Uint8List? img = await pickImage(ImageSource.gallery);
  //   if (img == null) return;

  //   log('image file size: ${img.lengthInBytes}');

  //   setState(() {
  //     _image = img;
  //   });
  // }

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

    TextEditingController fullNameController = TextEditingController(
        text: appProvider.localDataInProvider['userData']['name']);
    TextEditingController nickNameController = TextEditingController(
        text: appProvider.localDataInProvider['userData']['nickName']);

    TextEditingController emailController = TextEditingController(
        text: appProvider.localDataInProvider['userData']['email']);

    TextEditingController phoneNumberController = TextEditingController(
        text: appProvider.localDataInProvider['userData']['phoneNumber']);

    TextEditingController addressController = TextEditingController(
        text: appProvider.localDataInProvider['userData']['address']);

    print('image: ${appProvider.profileImageInBytes}');

    return Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          title: 'Your Profile',
          leftIcon: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: CustomColors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          color: CustomColors.gunmetal,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Consumer<AppProvider>(builder: (builder, provider, child) {
                  return _image != null
                      ? Stack(children: [
                          Container(
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
                      : appProvider.profileImageInBytes != null
                          ? Stack(children: [
                              Container(
                                // color: Colors.pink,
                                width: 126,
                                height: 126,
                              ),
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: MemoryImage(
                                    appProvider.profileImageInBytes!),
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
                                backgroundImage: NetworkImage(
                                    appProvider.localDataInProvider['userData']
                                        ['photoURL']),
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
                            ]);
                }),

                const SizedBox(
                  height: 30,
                ),

                TextField(
                  cursorColor: CustomColors.white.withOpacity(1),
                  cursorRadius: const Radius.circular(10),
                  cursorOpacityAnimates: true,
                  decoration:
                      getTextFieldDecoration(placeHolderText: 'Full Name'),
                  style: const TextStyle(
                    fontSize: 16,
                    color: CustomColors.white,
                  ),
                  maxLength: 30,
                  controller: fullNameController,
                ),

                const SizedBox(
                  height: 16,
                ),

                // not styled
                TextField(
                  cursorColor: CustomColors.white.withOpacity(1),
                  cursorRadius: const Radius.circular(10),
                  cursorOpacityAnimates: true,
                  maxLength: 30,
                  controller: nickNameController,
                  decoration:
                      getTextFieldDecoration(placeHolderText: 'Nick Name'),
                  style: const TextStyle(
                    fontSize: 16,
                    color: CustomColors.white,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),
                TextField(
                  enabled: false,
                  controller: emailController,
                  decoration: getTextFieldDecoration(placeHolderText: 'Email'),
                  style: TextStyle(
                    fontSize: 16,
                    color: CustomColors.white.withOpacity(0.5),
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),
                TextField(
                  cursorColor: CustomColors.white.withOpacity(1),
                  cursorRadius: const Radius.circular(10),
                  cursorOpacityAnimates: true,
                  maxLength: 11,
                  keyboardType: TextInputType.phone,
                  controller: phoneNumberController,
                  decoration:
                      getTextFieldDecoration(placeHolderText: 'Phone Number'),
                  style: const TextStyle(
                    fontSize: 16,
                    color: CustomColors.white,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),
                TextField(
                  cursorColor: CustomColors.white.withOpacity(1),
                  cursorRadius: const Radius.circular(10),
                  cursorOpacityAnimates: true,
                  maxLength: 70,
                  controller: addressController,
                  decoration:
                      getTextFieldDecoration(placeHolderText: 'Address'),
                  style: const TextStyle(
                    fontSize: 16,
                    color: CustomColors.white,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),
                Consumer<AppProvider>(
                  builder: (context, provider, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
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
                        underline: const SizedBox(
                          width: 0,
                          height: 0,
                        ),
                        iconSize: 24,

                        isExpanded: true,
                        // Initial Value
                        value: provider.localDataInProvider['userData']
                                ['gender']
                            .toString(),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),

                        iconEnabledColor: CustomColors.white,
                        // icon: const Icon(Icons.keyboard_arrow_down),

                        items: genders.map((String item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(
                              item.toUpperCase(),
                              style: const TextStyle(
                                color: CustomColors.white,
                              ),
                            ),
                          );
                        }).toList(),

                        onChanged: (String? newValue) {
                          provider.editClientGEnder(newValue!);
                        },
                      ),
                    );
                  },
                ),

                Consumer<AppProvider>(builder: (context, provider, child) {
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 30.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // minimumSize: const Size(double.infinity, 0),
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
                            provider.setEditClientProfileCIP(true);

                            if (mounted) {
                              Navigator.pop(context);
                            }

                            if (_image != null) {
                              final photo =
                                  await appProvider.updateUserProflileImage(
                                      userId: appProvider
                                              .localDataInProvider['userData']
                                          ['uid'],
                                      isClient: appProvider
                                              .localDataInProvider['userData']
                                          ['isClient'],
                                      file: _image);

                              await updateUserRegistrationDataInFirestore(
                                  userId: appProvider
                                      .localDataInProvider['userData']['uid'],
                                  isClient: appProvider
                                          .localDataInProvider['userData']
                                      ['isClient'],
                                  data: {
                                    'name': fullNameController.text,
                                    'nickName': nickNameController.text,
                                    'phoneNumber': phoneNumberController.text,
                                    'gender': appProvider
                                        .localDataInProvider['userData']
                                            ['gender']
                                        .toLowerCase(),
                                    'address': addressController.text,
                                    'photoURL': photo == ''
                                        ? appProvider
                                                .localDataInProvider['userData']
                                            ['photoURL']
                                        : photo,
                                  });
                            } else {
                              await updateUserRegistrationDataInFirestore(
                                  userId: appProvider
                                      .localDataInProvider['userData']['uid'],
                                  isClient: appProvider
                                          .localDataInProvider['userData']
                                      ['isClient'],
                                  data: {
                                    'name': fullNameController.text,
                                    'nickName': nickNameController.text,
                                    'phoneNumber': phoneNumberController.text,
                                    'gender': appProvider
                                        .localDataInProvider['userData']
                                            ['gender']
                                        .toLowerCase(),
                                    'address': addressController.text,
                                  });
                            }

                            appProvider
                                .updateUserDataInLocalStorageByProvider();

                            provider.setEditClientProfileCIP(false);
                            if (_image != null) {
                              appProvider.setProfileImageInBytes(_image);
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
                              child: provider.editClientProfileCIP
                                  ? const SpinKitFadingCircle(
                                      color: CustomColors.charcoal,
                                      size: 26.0,
                                    )
                                  : const Text(
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
        ));
  }
}
