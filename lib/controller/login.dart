import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trim_time/controller/firestore.dart';
import 'package:trim_time/controller/local_storage.dart';

Future<Map<String, dynamic>> signInWithGoogle({required bool isClient}) async {
  print('-----------------> Signin With Google Starts <-----------------');

  final GoogleSignInAccount? googleUser = await GoogleSignIn(
          // clientId: CLIENT_ID,
          )
      .signIn();

  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  final credential;
  try {
    credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
  } catch (e) {
    print('Error in credential----> ${e}');
    return {
      'user': null,
      'existsInOtherCategory': false,
      'existsInItsOwnCategory': false,
    };
  }

  // Once signed in, return the UserCredential
  UserCredential user =
      await FirebaseAuth.instance.signInWithCredential(credential);

  final response = await checkUserAlreadyExistsInOtherCategory(
      user.user!.uid, isClient, user);

  if (response['existsInOtherCategory']) {
    return {
      'user': user,
      ...response,
    };
  }

  Map<String, dynamic> userDataFromFirestore =
      await getUserDataFromFirestore(user.user!.uid, isClient);

  await storeUserDataInLocalStorage(
    user: user,
    isClient: isClient,
    userDataFromFirestore:
        jsonEncode(userDataFromFirestore), // encoding map into json string
  );

  return {
    'user': user,
    ...response,
  };
}

Future<Map<String, dynamic>> checkUserAlreadyExistsInOtherCategory(
    String userId, bool isClient, UserCredential user) async {
  final collection = isClient ? 'barbers' : 'clients';
  CollectionReference users = FirebaseFirestore.instance.collection(collection);
  DocumentSnapshot _user = await users.doc(userId).get();

  if (_user.data() != null) {
    print('--------User already exists in other category');
    return {
      'existsInOtherCategory': true,
      'existsInItsOwnCategory': false,
    };
  } else {
    print('--------User does not exist in other category');
    checkUserAlreadyExistsInItsOwnCategory(userId, isClient, user);
    return {
      'existsInOtherCategory': false,
      ...await checkUserAlreadyExistsInItsOwnCategory(userId, isClient, user),
    };
  }
}

Future<Map<String, dynamic>> checkUserAlreadyExistsInItsOwnCategory(
    String userId, bool isClient, UserCredential user) async {
  final collection = isClient ? 'clients' : 'barbers';
  CollectionReference users = FirebaseFirestore.instance.collection(collection);
  DocumentSnapshot _user = await users.doc(userId).get();

  if (_user.data() != null) {
    print('--------User already exists in its own category');
    return {
      'existsInItsOwnCategory': true,
    };
  } else {
    print('--------User doesnot exist anywhere');
    print('--------Adding user to Database(Firestore)');

    await storeUserDataInFirestore(user: user, isClient: isClient);

    return {
      'existsInItsOwnCategory': false,
    };
  }
}

signOut() async {
  print('-----------------> Signout <-----------------');
  GoogleSignIn().signOut();
  await FirebaseAuth.instance.signOut();
  removeDataFromLocalStorage();
}
