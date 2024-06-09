
// DATE TIME FLOW
// DateTime.now().toIso8601String() => '2021-09-29T14:00:00.000' => DateTime.parse('2021-09-29T14:00:00.000') => DateFormate('yyyy-MM-dd').format(parsedDate) => '2021-09-29'

// 'services': [
//         {'id': 1, 'name': 'haircut', 'price': 250},
//         {'id': 2, 'name': 'shave', 'price': 170},
//         {'id': 3, 'name': 'beard trim', 'price': 120},
//         {'id': 4, 'name': 'massage', 'price': 150},
//       ],

// PRICE
// {
//            
//           'price': 0,
//           'serviceId': '',
//         }



// BOOKING  
// {
// //          'id': uuid,
//       'barberId': barberId,
//       'clientId': clientId,
//       'serviceId': serviceId,
//       'slotId': slot['slotId'],
//       'startTime': slot['start'],
//       'endTime': slot['end'],
//       'isCompleted': false,
//       'isCancelled': false,
//       'isConfirmed': false,
//       'isPaid': false,
//       'isRated': false,
//       'rating': 0,
//       'review': '',
//       'date': date,
//       'paidAmount': 0,
//       'totalAmount': 0,
//       'updatedAt': DateTime.now().toIso8601String(),
//         }

// RATING
// {
//           'rating': 0,
//           'review': ''
//           'id' : '',
//           'barberId': '',
//           'clientId': '',
//           'bookingId': '',
//            'id': '',
//         }


// USER
//  {'uid': user.user!.uid,
//       'isClient': isClient,
//       'name': user.user!.displayName,
//       'email': user.user!.email,
//       'photoURL': user.user!.photoURL,
//       'phoneNumber': user.user!.phoneNumber ?? '',
//       'isRegistered': false,
//       'nickName': '',
//       'address': '',
//       'gender': 'male',
//       'favourite': [],
//       'bookings': [],
//       'ratings': ['ratingId'],
// }

// SERVICES
//  'services': [
//         {
//           'id': 1,
//           'name': 'haircut',
//         },
//         {
//           'id': 2,
//           'name': 'shave',
//         },
//         {
//           'id': 3,
//           'name': 'beard trim',
//         },
//         {
//           'id': 4,
//           'name': 'massage',
//         },
//       ],