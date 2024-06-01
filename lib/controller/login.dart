import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trim_time/utilities/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<UserCredential> signInWithGoogle() async {
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

  // Store user in local storage
  storeUserIdInLocalStorage(user);

  return user;
}

Future<void> StoreUserInFirestore(UserCredential user) async {
  print('StoreUserInFirestore---->');
  // Store user in firestore
  // await FirebaseFirestore.instance.collection('users').doc(user.user!.uid).set({
  //   'name': user.user!.displayName,
  //   'email': user.user!.email,
  //   'photoURL': user.user!.photoURL,
  //   'uid': user.user!.uid,
  // });
}

getUserIDFromLocalStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userID = prefs.getString('uid');
  return userID;
}

storeUserIdInLocalStorage(UserCredential user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('uid', user.user!.uid);
}

removeUserIdFromLocalStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('uid');
}

signOut() async {
  GoogleSignIn().signOut();
  await FirebaseAuth.instance.signOut();
  removeUserIdFromLocalStorage();
  print('signedOut---->');
}
