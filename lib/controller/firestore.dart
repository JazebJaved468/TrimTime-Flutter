import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:trim_time/controller/date_time.dart';
import 'package:trim_time/controller/local_storage.dart';
import 'package:trim_time/controller/login.dart';
import 'package:uuid/uuid.dart';

getPopularBarbersFromFireStore() async {
  print(
      '-----------------> Getting Popular Barbers Listing from Firestore <-----------------');

  List allBarbers = await getAllBarbersFromFireStore();

  // Sort barbers by average rating in descending order
  allBarbers.sort((a, b) => b['averageRating'].compareTo(a['averageRating']));

  return allBarbers.take(3).toList();
}

rateBarberInFirestore({
  required String barberId,
  required String clientId,
  required String bookingId,
  required int rating,
  required String review,
  required String clientName,
}) async {
  print('-----------------> Rating Barber In FireStore <-----------------');
  var ratingId = const Uuid().v4();

  CollectionReference ratings =
      FirebaseFirestore.instance.collection('ratings');
  CollectionReference barbers =
      FirebaseFirestore.instance.collection('barbers');

  CollectionReference clients =
      FirebaseFirestore.instance.collection('clients');
  CollectionReference bookings =
      FirebaseFirestore.instance.collection('bookings');
  await ratings.doc(ratingId).set({
    'id': ratingId,
    'barberId': barberId,
    'clientId': clientId,
    'bookingId': bookingId,
    'rating': rating,
    'review': review,
    'createdAt': DateTime.now().toIso8601String(),
    'clientName': clientName,
  });

  await barbers.doc(barberId).update({
    'ratings': FieldValue.arrayUnion([ratingId])
  });

  await clients.doc(clientId).update({
    'ratings': FieldValue.arrayUnion([ratingId])
  });

  await bookings.doc(bookingId).update({
    'isRated': true,
  });
}

rateAppInFirestore({
  required String userId,
  required bool isClient,
  required int rating,
  required String review,
}) async {
  print('-----------------> Rating App In FireStore <-----------------');
  var ratingId = const Uuid().v4();

  CollectionReference appRatings =
      FirebaseFirestore.instance.collection('appRatings');

  await appRatings.doc(ratingId).set({
    'id': ratingId,
    'rating': rating,
    'review': review,
    'createdAt': DateTime.now().toIso8601String(),
    'userId': userId,
    'isClient': isClient,
  });
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

  CollectionReference ratings =
      FirebaseFirestore.instance.collection('ratings');

  QuerySnapshot ratingsSnapshot = await ratings.get();
  List? allRatings = ratingsSnapshot.docs.map((e) {
    return e.data() as Map<String, dynamic>;
  }).toList();

  Map<String, dynamic> localData = await getDataFromLocalStorage();

  if (localData['userData'] != null) {
    for (var barber in allBarbers) {
      if (localData['userData']['favourites'].contains(barber['uid'])) {
        barber['isFavourite'] = true;
      } else {
        barber['isFavourite'] = false;
      }
    }
  }

  for (var barber in allBarbers) {
    var barberId = barber['uid'];

    var ratings =
        allRatings.where((element) => element['barberId'] == barberId).toList();

    barber['reviews'] = ratings;
    double averageRating = ratings.isNotEmpty
        ? ratings.map((e) => e['rating']).reduce((a, b) => a + b) /
            ratings.length
        : 0.0;

    barber['averageRating'] = averageRating.toStringAsFixed(1);
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
    var fomattedDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
    var selectedDateFormatted =
        DateFormat('dd-MM-yyyy').format(DateTime.parse(selectedDate));

    if (selectedDateFormatted == fomattedDate) {
      if (barberData['availability'][date]['isAvailable']) {
        {
          barberData['availability'][date]['slots'].forEach((slot) {
            if (slot['isAvailable'] && slot['isBooked'] == false) {
              if (slot['slotId'] == slotId) {
                isAvailable = true;
              }
            }
          });
        }
      } else {
        isAvailable = false;
      }
    }
  });

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

  var bookingId = Uuid().v4();

  if (isSlotAvailable) {
    bookings.doc(bookingId).set({
      'id': bookingId,
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
      'bookings': FieldValue.arrayUnion([bookingId])
    });

    await clients.doc(clientId).update({
      'bookings': FieldValue.arrayUnion([bookingId])
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
      'bookingId': bookingId,
    }; // 0 means booking is successful
  } else {
    return {
      'status': -1,
      'message': 'Booking failed, slot is not available',
      'bookingId': null,
    }; // -1 means slot is not available, booking failed
  }
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
