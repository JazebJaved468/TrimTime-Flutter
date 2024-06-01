import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> signInWithGoogle({required bool isClient}) async {
  print('<------ signInWithGoogle starts---->');

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

  print('user----> ${user}');

  storeDataInLocalStorage(user: user, isClient: isClient);

  return {
    'user': user,
    ...await checkUserAlreadyExistsInOtherCategory(
        user.user!.uid, isClient, user),
  };
}

Future<Map<String, dynamic>> checkUserAlreadyExistsInOtherCategory(
    String userId, bool isClient, UserCredential user) async {
  final collection = isClient ? 'barbers' : 'clients';
  CollectionReference users = FirebaseFirestore.instance.collection(collection);
  DocumentSnapshot _user = await users.doc(userId).get();

  if (_user.data() != null) {
    print('User already exists in other category');
    return {
      'existsInOtherCategory': true,
      'existsInItsOwnCategory': false,
    };
  } else {
    print('User does not exist in other category');
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
    print('User already exists in its own category');
    return {
      'existsInItsOwnCategory': true,
    };
  } else {
    print('user doesnot exist anywhere');
    print('adding user to database');
    await users.doc(userId).set({
      'uid': userId,
      'isClient': isClient,
      'name': user.user!.displayName,
      'email': user.user!.email,
      'photoURL': user.user!.photoURL,
    });
    return {
      'existsInItsOwnCategory': false,
    };
  }
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
