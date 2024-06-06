import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

storeUserDataInLocalStorage({
  required UserCredential user,
  required bool isClient,
  required String userDataFromFirestore,
}) async {
  print('-----------------> Storing Data In Local Storage <-----------------');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('uid', user.user!.uid);
  prefs.setBool('isClient', isClient);
  prefs.setString('userData', userDataFromFirestore);
}

updateBooleanDataInLocalStorage(
    {required String key, required dynamic value}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, value);
}

removeDataFromLocalStorage() async {
  print(
      '-----------------> Removing Data From Local Storage <-----------------');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('uid');
  prefs.remove('isClient');
  prefs.remove('userData');
}

getDataFromLocalStorage() async {
  print(
      '-----------------> Getting Data From Local Storage <-----------------');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? uid = prefs.getString('uid');
  bool? isClient = prefs.getBool('isClient');
  bool? isFirstVisit = prefs.getBool('isFirstVisit');
  String? userData = prefs.getString('userData');

  return {
    'uid': uid,
    'isClient': isClient,
    'isFirstVisit': isFirstVisit,
    'userData': jsonDecode(userData ?? '{}')
  };
}

updateUserDataInLocalStorage({required Map<String, dynamic> data}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('userData', jsonEncode(data));
}
