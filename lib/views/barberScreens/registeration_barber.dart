import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:trim_time/providers/sample_provider.dart';

import 'package:trim_time/controller/upload_image.dart';

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
  // bool _isLoading = true;

  // late String genderDropDownValue;
  // late int openingTimeDropDownValue;
  // late int closingTimeDropDownValue;
  late bool? isProvidingHaircut;
  late bool? isProvidingShave;
  late bool? isProvidingBeardTrim;
  late bool? isProvidingMassage;

  // late Map<String, dynamic> localData;

  // LocalStorageModel? localStorageData;

  Uint8List? _image;
  _loadData() {
    // await Future.delayed(const Duration(seconds: 2));

    // localData = await getDataFromLocalStorage();

    // print('------------>localData in barber registration page----> $localData');

    // final _services = localData['userData']['services'];

    // setState(() {
    isProvidingHaircut = widget.services['1']['isProviding'];
    isProvidingShave = widget.services['2']['isProviding'];
    isProvidingBeardTrim = widget.services['3']['isProviding'];
    isProvidingMassage = widget.services['4']['isProviding'];
    // genderDropDownValue = widget.gender;
    // openingTimeDropDownValue = widget.openingTime;
    // closingTimeDropDownValue = widget.closingTime;
    // _isLoading = false;
    // });
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
    return Container();
  }
}
