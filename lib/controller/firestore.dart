import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:trim_time/controller/date_time.dart';
import 'package:trim_time/controller/local_storage.dart';
import 'package:trim_time/controller/login.dart';
import 'package:uuid/uuid.dart';

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

getAllClientBookingsFromFireStore({
  required String clientId,
}) async {
  print(
      '-----------------> Getting All Bookings Listing from Firestore <-----------------');
  CollectionReference bookings =
      FirebaseFirestore.instance.collection('bookings');
  QuerySnapshot querySnapshot =
      await bookings.where('clientId', isEqualTo: clientId).get();
  List? allBookings = querySnapshot.docs.map((e) {
    return e.data() as Map<String, dynamic>;
  }).toList();

  // print('All Bookings: $allBookings');

  for (var booking in allBookings) {
    Map<String, dynamic> barberData =
        await getUserDataFromFirestore(booking['barberId'], false);
    booking['barberData'] = barberData;
  }

  return allBookings;
}

getAllBarbersFromFireStore() async {
  print(
      '-----------------> Getting all Barbers Listing from Firestore <-----------------');
  CollectionReference barbers =
      FirebaseFirestore.instance.collection('barbers');
  QuerySnapshot querySnapshot = await barbers.get();
  List? allBarbers = querySnapshot.docs.map((e) {
    // print(e.data());
    return e.data() as Map<String, dynamic>;
  }).toList();

  Map<String, dynamic> localData = await getDataFromLocalStorage();

  // print('Local Data: ${localData}');

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

updateClientFavoritesInFirestore(
    {required String clientId, required List favouritesList}) async {
  print(
      '-----------------> Updating Client Favorites In FireStore <-----------------');
  CollectionReference clients =
      FirebaseFirestore.instance.collection('clients');

  print('updateing client favourites with this data $favouritesList');

  await clients.doc(clientId).update({'favourites': favouritesList});

  //  await updateUserDataInLocalStorage(
  // data: await getUserDataFromFirestore(uid, isClient));
}

checkBookingSlotIsAvailableInFirestore(
    {required String barberId,
    required String slotId,
    required String selectedDate}) async {
  print(
      '-----------------> Checking Booking Slot Is Available In FireStore <-----------------');

  bool isAvailable = false;
  CollectionReference barbers =
      FirebaseFirestore.instance.collection('barbers');

  DocumentSnapshot _barber = await barbers.doc(barberId).get();
  Map<String, dynamic> barberData = _barber.data() as Map<String, dynamic>;

  barberData['availability'].forEach((date, info) {
    // print('date ----> $date');
    var fomattedDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
    var selectedDateFormatted =
        DateFormat('dd-MM-yyyy').format(DateTime.parse(selectedDate));

    if (selectedDateFormatted == fomattedDate) {
      // print('date matched');
      if (barberData['availability'][date]['isAvailable']) {
        {
          barberData['availability'][date]['slots'].forEach((slot) {
            if (slot['isAvailable'] && slot['isBooked'] == false) {
              if (slot['slotId'] == slotId) {
                isAvailable = true;
              }
            }
          });
          // print('barber available on that day ----> $date');
          // barberAvailability = info;
        }
        // barberAvailability = info;
      } else {
        isAvailable = false;
      }
      // if (slot['isAvailable'] && slot['isBooked'] == false) {
      //   tempSlotsList.add(slot);
      // }

      //  slotsToShow = tempSlotsList;

      // print('slots list length ----> ${tempSlotsList.length}');
    }
  });

  // bookings.where('slotId', isEqualTo: 'slotId').get().then((value) {
  //   if (value.docs.isEmpty) {
  //     print('Slot is available');
  //   } else {
  //     print('Slot is not available');
  //   }
  // });
  return isAvailable;
}

createBookingInFirestore({
  required String barberId,
  required String clientId,
  required String serviceId,
  required Map slot,
  required String date,
  required int amount,
}) async {
  print('-----------------> Creating Booking In FireStore <-----------------');

  bool isSlotAvailable = await checkBookingSlotIsAvailableInFirestore(
      barberId: barberId, slotId: slot['slotId'], selectedDate: date);

  CollectionReference bookings =
      FirebaseFirestore.instance.collection('bookings');

  var uuid = Uuid().v4();

  if (isSlotAvailable) {
    bookings.add({
      'id': uuid,
      'barberId': barberId,
      'clientId': clientId,
      'serviceId': serviceId,
      'slotId': slot['slotId'],
      'startTime': slot['start'],
      'endTime': slot['end'],
      'isCompleted': false,
      'isCancelled': false,
      'isConfirmed': false,
      'isPaid': false,
      'isRated': false,
      'rating': 0,
      'review': '',
      'date': date,
      'paidAmount': 0,
      'totalAmount': amount,
      'updatedAt': DateTime.now().toIso8601String(),
    });

    CollectionReference barbers =
        FirebaseFirestore.instance.collection('barbers');

    CollectionReference clients =
        FirebaseFirestore.instance.collection('clients');

    await barbers.doc(barberId).update({
      'bookings': FieldValue.arrayUnion([uuid])
    });

    await clients.doc(clientId).update({
      'bookings': FieldValue.arrayUnion([uuid])
    });

    Map<String, dynamic> barberData =
        await getUserDataFromFirestore(barberId, false);

    barberData['availability'].forEach((_date, info) {
      var fomattedDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(_date));
      var selectedDateFormatted =
          DateFormat('dd-MM-yyyy').format(DateTime.parse(date));

      if (selectedDateFormatted == fomattedDate) {
        barberData['availability'][_date]['slots'].forEach((_slot) {
          if (_slot['slotId'] == slot['slotId']) {
            _slot['isBooked'] = true;
          }
        });
      }
    });

    updateBarberDataInFirestore(
        userId: barberId, isClient: false, data: barberData);

    updateUserDataInLocalStorage(
        data: await getUserDataFromFirestore(clientId, true));

    return {
      'status': 0,
      'message': 'Booking is successful',
      'bookingId': uuid,
    }; // 0 means booking is successful
  } else {
    return {
      'status': -1,
      'message': 'Booking failed, slot is not available',
      'bookingId': null,
    }; // -1 means slot is not available, booking failed
  }

  // bookings.add({
  //   'id': '',
  //   'barberId': '',
  //   'clientId': '',
  //   'serviceId': '',
  //   'slotId': '',
  //   'isCompleted': false,
  //   'isCancelled': false,
  //   'isConfirmed': false,
  //   'isPaid': false,
  //   'isRated': false,
  //   'rating': 0,
  //   'review': ''
  // });
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
      'services': {
        '1': {
          'price': 250,
          'serviceId': '1',
          'isProviding': true,
        },
        '2': {
          'price': 170,
          'isProviding': true,
          'serviceId': '2',
        },
        '3': {
          'price': 120,
          'isProviding': true,
          'serviceId': '3',
        },
        '4': {
          'price': 150,
          'isProviding': false,
          'serviceId': '4',
        },
      },
      'availability':
          generate7DaysSlots(DateTime.now(), OPENING_TIME, CLOSING_TIME)
    });
  }
}




// getHaircutBarbersFromFirestore() async {
//   print(
//       '-----------------> Getting Haircut Barbers Listng from Firestore <-----------------');
//   CollectionReference barbers =
//       FirebaseFirestore.instance.collection('barbers');

//   var haircutFilterBarbersList =
//       await barbers.where('services.1.isProviding', isEqualTo: true).get();

//   var tempList = haircutFilterBarbersList.docs.map((e) {
//     return e.data() as Map<String, dynamic>;
//   }).toList();

//   print(tempList);
// }