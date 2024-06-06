import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trim_time/controller/date_time.dart';
import 'package:trim_time/controller/local_storage.dart';

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

updateBarberAvailabilityInFirestore(
    {required String barberId, required Map<String, dynamic> data}) async {
  print(
      '-----------------> Updating Barber Availability In FireStore <-----------------');

  CollectionReference barbers =
      FirebaseFirestore.instance.collection('barbers');

  await barbers.doc(barberId).update({'availability': data});
}

getBarberListingFromFireStore() async {
  print('-----------------> Getting Barber Listing <-----------------');
  CollectionReference barbers =
      FirebaseFirestore.instance.collection('barbers');
  QuerySnapshot querySnapshot = await barbers.get();
  List? allBarbers = querySnapshot.docs.map((e) {
    // print(e.data());
    return e.data() as Map<String, dynamic>;
  }).toList();

  Map<String, dynamic> localData = await getDataFromLocalStorage();

  print('Local Data: ${localData}');

  if (localData['userData'] != null) {
    for (var barber in allBarbers) {
      if (localData['userData']['favourites'].contains(barber['uid'])) {
        barber['isFavourite'] = true;
      } else {
        barber['isFavourite'] = false;
      }
    }
  }

  return allBarbers;
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
      'favourites': [],
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
