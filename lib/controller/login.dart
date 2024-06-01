import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trim_time/utilities/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<UserCredential> signInWithGoogle({required bool isClient}) async {
  print('<------ signInWithGoogle starts---->');
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn(
          // clientId: CLIENT_ID,
          )
      .signIn();

  // Obtain the auth details from the request

  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  UserCredential user =
      await FirebaseAuth.instance.signInWithCredential(credential);

  print('user----> ${user}');

  // if (user != null) {
  //   // Store user in local storage

  //   // Store user in firestore
  //   // StoreUserInFirestore(user);
  // }

  storeDataInLocalStorage(user: user, isClient: isClient);
  return user;
}

Future<void> StoreUserInFirestore() async {
  // print('StoreUserInFirestore---->');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  DocumentSnapshot user = await users.doc('1').get();

  print('users Collection ----> ${users}');
  print('User Document ----> ${user.data()}');
  // Store user in firestore
  // await FirebaseFirestore.instance.collection('users').doc(user.user!.uid).set({
  //   'name': user.user!.displayName,
  //   'email': user.user!.email,
  //   'photoURL': user.user!.photoURL,
  //   'uid': user.user!.uid,
  // });
}

getDataFromLocalStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? uid = prefs.getString('uid');
  bool? isClient = prefs.getBool('isClient');
  return {'uid': uid, 'isClient': isClient};
}

storeDataInLocalStorage(
    {required UserCredential user, required bool isClient}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('uid', user.user!.uid);
  prefs.setBool('isClient', isClient);
}

removeDataFromLocalStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('uid');
  prefs.remove('isClient');
}

signOut() async {
  GoogleSignIn().signOut();
  await FirebaseAuth.instance.signOut();
  removeDataFromLocalStorage();
  print('signedOut---->');
}
