import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trim_time/controller/date_time.dart';

initializeApp() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isFirstVisit = prefs.getBool('isFirstVisit');
  late Map<String, dynamic> localData;

  if (isFirstVisit == null) {
    updateBooleanDataInLocalStorage(key: 'isFirstVisit', value: true);
  } else {
    localData = await getDataFromLocalStorage();

    if (localData['uid'] != null) {
      updateUserDataInLocalStorage(
          data: await getUserDataFromFirestore(
              localData['uid'], localData['isClient']));
    }
  }
}

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

updateUserDataInLocalStorage({required Map<String, dynamic> data}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('userData', jsonEncode(data));
}

getUserDataFromFirestore(String userId, bool isClient) async {
  print(
      '-----------------> Getting User Data From FireStore <-----------------');
  final collection = isClient ? 'clients' : 'barbers';
  CollectionReference users = FirebaseFirestore.instance.collection(collection);
  DocumentSnapshot _user = await users.doc(userId).get();
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

  return availableSlots;
}

storeUserDataInFirestore(
    {required UserCredential user, required bool isClient}) async {
  print(
      '-----------------> Storing User Data In FireStore From Google <-----------------');
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
          'serviceId': '1',
          'isProviding': true,
        },
        {
          'price': 170,
          'serviceId': '2',
          'isProviding': true,
        },
        {
          'price': 120,
          'serviceId': '3',
          'isProviding': true,
        },
        {
          'price': 150,
          'serviceId': '4',
          'isProviding': false,
        },
      ],
      'availability':
          generate7DaysSlots(DateTime.now(), OPENING_TIME, CLOSING_TIME)
    });
  }
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

signOut() async {
  print('-----------------> Signout <-----------------');
  GoogleSignIn().signOut();
  await FirebaseAuth.instance.signOut();
  removeDataFromLocalStorage();
}

updateBarberAvailabilityInFireStore(
    {required String barberId, required Map<String, dynamic> data}) async {
  print(
      '-----------------> Updating Barber Availability In FireStore <-----------------');

  CollectionReference barbers =
      FirebaseFirestore.instance.collection('barbers');

  await barbers.doc(barberId).update({'availability': data});
}
