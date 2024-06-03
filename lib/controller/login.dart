import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trim_time/controller/date_time.dart';
import 'package:trim_time/models/local_storage_model.dart';
import 'package:uuid/uuid.dart';

initializeApp() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isFirstVisit = prefs.getBool('isFirstVisit');

  if (isFirstVisit == null) {
    updateBooleanDataInLocalStorage(key: 'isFirstVisit', value: true);
  } else {
    Map<String, dynamic>? response;
    LocalStorageModel? localStorageData;
    getLocalData() async {
      response = await getDataFromLocalStorage();
      localStorageData = LocalStorageModel.fromJson(response!);
    }
  }

  // ----------------------------------------------------------
  // generateTimeSlots(DateTime.parse('2024-06-02T11:30:00.000'));
  // DateTime today = DateTime.now();
  // DateTime openingTime =
  //     DateTime(today.year, today.month, today.day, 11, 0); // 11:00 AM
  // DateTime closingTime =
  //     DateTime(today.year, today.month, today.day, 23, 0); // 11:00 PM

  // List<Map<String, dynamic>> slots =
  //     generateTimeSlots(today, openingTime, closingTime);
}

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

  final response = await checkUserAlreadyExistsInOtherCategory(
      user.user!.uid, isClient, user);

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

    await storeUserDataInFirestore(user: user, isClient: isClient);

    // await users.doc(userId).set({
    //   'uid': userId,
    //   'isClient': isClient,
    //   'name': user.user!.displayName,
    //   'email': user.user!.email,
    //   'photoURL': user.user!.photoURL,
    // });
    return {
      'existsInItsOwnCategory': false,
    };
  }
}

updateUserDataInLocalStorage({required Map<String, dynamic> data}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('userData', jsonEncode(data));
}

getUserDataFromFirestore(String userId, bool isClient) async {
  // print('user Id ----> $userId');
  final collection = isClient ? 'clients' : 'barbers';
  CollectionReference users = FirebaseFirestore.instance.collection(collection);
  DocumentSnapshot _user = await users.doc(userId).get();
  // print('from function data ---->${_user.data()}');
  return _user.data() as Map<String, dynamic>;
}

updateUserRegistrationDataInFirestore(
    {required String userId,
    required bool isClient,
    required Map<String, dynamic> data}) async {
  final collection = isClient ? 'clients' : 'barbers';
  CollectionReference users = FirebaseFirestore.instance.collection(collection);
  await users.doc(userId).update(data);
}

updateBarberDataInFirestore(
    {required String userId,
    required bool isClient,
    required Map<String, dynamic> data}) async {
  final collection = isClient ? 'clients' : 'barbers';
  CollectionReference users = FirebaseFirestore.instance.collection(collection);
  await users.doc(userId).update(data);
}

generate7DaysSlots(DateTime startingDay, int openingTime, int closingTime) {
  var availableSlots = {};
  for (var i = 0; i < 7; i++) {
    String day = (startingDay.add(Duration(days: i)).toIso8601String());
    availableSlots[day] = {
      'slots': generateTimeSlots(DateTime.parse(day), openingTime, closingTime),
    };
  }

  print('Available Slots ---> $availableSlots');
  return availableSlots;
}

storeUserDataInFirestore(
    {required UserCredential user, required bool isClient}) async {
  print('user data from google ----> ${user.user}');
  if (isClient) {
    CollectionReference clients =
        FirebaseFirestore.instance.collection('clients');
    await clients.doc(user.user!.uid).set({
      'uid': user.user!.uid,
      'isClient': isClient,
      'name': user.user!.displayName,
      'email': user.user!.email,
      'photoURL': user.user!.photoURL,
      'phoneNumber': user.user!.phoneNumber ?? '',
      'isRegistered': false,
      'nickName': '',
      'address': '',
      'gender': 'male',
      'favourite': [],
      'bookings': [],
      'ratings': [],
    });
  } else {
    CollectionReference barbers =
        FirebaseFirestore.instance.collection('barbers');

    DateTime today = DateTime.now();

    // Print today's date

    // String day1 = DateFormat('dd-MM-yyyy').format(today);
    // String day2 = DateFormat('dd-MM-yyyy').format(today.add(Duration(days: 1)));
    // String day3 = DateFormat('dd-MM-yyyy').format(today.add(Duration(days: 2)));
    // String day4 = DateFormat('dd-MM-yyyy').format(today.add(Duration(days: 3)));
    // String day5 = DateFormat('dd-MM-yyyy').format(today.add(Duration(days: 4)));
    // String day6 = DateFormat('dd-MM-yyyy').format(today.add(Duration(days: 5)));
    // String day7 = DateFormat('dd-MM-yyyy').format(today.add(Duration(days: 6)));
    // String day8 = DateFormat('dd-MM-yyyy').format(today.add(Duration(days: 7)));

    // String day1 = today.toIso8601String();
    // String day2 = (today.add(Duration(days: 1)).toIso8601String());
    // String day3 = (today.add(Duration(days: 2)).toIso8601String());
    // String day4 = (today.add(Duration(days: 3)).toIso8601String());
    // String day5 = (today.add(Duration(days: 4)).toIso8601String());
    // String day6 = (today.add(Duration(days: 5)).toIso8601String());
    // String day7 = (today.add(Duration(days: 6)).toIso8601String());
    // String day8 = (today.add(Duration(days: 7)).toIso8601String());

    // print(
    //     'Today with formattnig ---> ${DateFormat('dd-MM-yyyy').format(today)}');

    // Print today's date
    // print('Today: ${today.day}-${today.month}-${today.year}');
    // print(
    //     'Tomorrow: ${today.add(Duration(days: 1)).day}-${today.month}-${today.year}');

    await barbers.doc(user.user!.uid).set({
      'uid': user.user!.uid,
      'isClient': isClient,
      'name': user.user!.displayName,
      'email': user.user!.email,
      'photoURL': user.user!.photoURL,
      'phoneNumber': user.user!.phoneNumber ?? '',
      'ratings': [],
      'isRegistered': false,
      'nickName': '',
      'gender': 'male',
      'shopName': '',
      'shopAddress': '',
      'shopPhoneNumber': '',
      'openingTime': 11,
      'closingTime': 23,
      'bookings': [],
      'services': [
        {
          'price': 250,
          'id': '1',
          'name': 'haircut',
          'isProviding': true,
        },
        {
          'price': 170,
          'id': '2',
          'name': 'shave',
          'isProviding': true,
        },
        {
          'price': 120,
          'id': '3',
          'name': 'beard trim',
          'isProviding': true,
        },
        {
          'price': 150,
          'id': '4',
          'name': 'massage',
          'isProviding': false,
        },
      ],
      'availability':
          generate7DaysSlots(DateTime.now(), OPENING_TIME, CLOSING_TIME)
    });
  }
}

getDataFromLocalStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? uid = prefs.getString('uid');
  bool? isClient = prefs.getBool('isClient');
  bool? isFirstVisit = prefs.getBool('isFirstVisit');
  String? userData = prefs.getString('userData');

  print('keys in local storage ---> ${prefs.getKeys()}');
  print('-----------------getting data from local storage-----------------');

  print(' uid----> $uid');
  print(' isClient----> $isClient');
  print(' isFirstVisit----> $isFirstVisit');
  print(' userData----> ${jsonDecode(userData ?? '{}')}');
  return {
    'uid': uid,
    'isClient': isClient,
    'isFirstVisit': isFirstVisit,
    'userData': jsonDecode(userData ?? '{}')
  };
}

storeUserDataInLocalStorage({
  required UserCredential user,
  required bool isClient,
  required String userDataFromFirestore,
}) async {
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
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('uid');
  prefs.remove('isClient');
  prefs.remove('userData');
}

signOut() async {
  GoogleSignIn().signOut();
  await FirebaseAuth.instance.signOut();
  removeDataFromLocalStorage();
  print('signedOut---->');
}
