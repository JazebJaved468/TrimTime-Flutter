import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/components/CustomAppBar.dart';
import 'package:trim_time/components/EmptyList.dart';
import 'package:trim_time/controller/firestore.dart';

class BarberBookings extends StatefulWidget {
  const BarberBookings({super.key});

  @override
  State<BarberBookings> createState() => _BarberBookingsState();
}

class _BarberBookingsState extends State<BarberBookings> {
  dynamic bookings;
  Map<String, Map<String, dynamic>> userCache = {}; // Cache user data
  String? confirmingBookingId; // Track which booking is being confirmed

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    dynamic fetchedBookings =
        await getBarberBookings('XdW13qLwfDSXGKLg4mz2UAUBq7I3');

    List<dynamic> futureBookings = fetchedBookings.where((booking) {
      DateTime startTime = DateTime.parse(booking['startTime']);
      return startTime.isAfter(DateTime.now());
    }).toList();

    futureBookings.sort((a, b) {
      return a['isConfirmed'] == b['isConfirmed']
          ? 0
          : (a['isConfirmed'] ? 1 : -1);
    });

    setState(() {
      bookings = futureBookings;
    });
  }

  Future<void> confirmUserBookingHandler(String bookingId) async {
    setState(() {
      confirmingBookingId = bookingId; // Set the booking being confirmed
    });

    try {
      await confirmUserBooking(bookingId);

      setState(() {
        final bookingIndex =
            bookings.indexWhere((booking) => booking['id'] == bookingId);
        if (bookingIndex != -1) {
          bookings[bookingIndex]['isConfirmed'] = true;
        }
        confirmingBookingId = null; // Reset after confirmation
      });
    } catch (error) {
      print(error);
      setState(() {
        confirmingBookingId = null; // Reset in case of error
      });
    }
  }

  Future<Map<String, dynamic>> getUserData(String uid) async {
    if (!userCache.containsKey(uid)) {
      dynamic userData = await getUserDataFromFirestore(uid, true);
      userCache[uid] = userData;
    }
    return userCache[uid]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Bookings',
        leftIcon: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: CustomColors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: CustomColors.gunmetal,
      body: bookings == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : bookings.isEmpty
              ? EmptyList(message: 'No Bookings Found')
              : ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return FutureBuilder<Map<String, dynamic>>(
                      future: getUserData(booking['clientId']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (snapshot.hasData) {
                          final userData = snapshot.data!;
                          String photoUrl = userData['photoURL'] ?? '';
                          int totalAmount = booking['totalAmount'] ?? 0.0;
                          int paidAmount = booking['paidAmount'] ?? 0.0;
                          int remainingPayment = totalAmount - paidAmount;

                          return Card(
                            margin: EdgeInsets.all(12),
                            color: CustomColors.charcoal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(photoUrl),
                                        radius: 30,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        userData['name'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Start Time: ${formatStartTime(booking['startTime'])}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.attach_money,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Total Fee: Rs.${booking['totalAmount']}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(
                                        booking['isPaid']
                                            ? Icons.check_circle_outline
                                            : Icons.error_outline,
                                        color: booking['isPaid']
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        booking['isPaid']
                                            ? 'Paid: Rs.${paidAmount.toStringAsFixed(2)}'
                                            : 'Paid: Not Paid',
                                        style: TextStyle(
                                          color: booking['isPaid']
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (booking['isConfirmed'])
                                    SizedBox(height: 5),
                                  if (booking['isConfirmed'])
                                    remainingPayment>0 ? Row(
                                      children: [
                                        Icon(
                                          Icons.warning_amber_outlined,
                                          color: Colors.yellow,
                                        ),
                                        SizedBox(width: 5),
                                          Text(
                                          'Payment Due: Rs.${remainingPayment.toStringAsFixed(2)}',
                                          style:
                                              TextStyle(color: Colors.yellow),
                                        ),
                                      ],
                                    ):Text(''),
                                  SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: booking['isConfirmed']
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.check,
                                                color: Colors.green,
                                              ),
                                              SizedBox(width: 5),
                                              Text('Confirmed',
                                                  style: TextStyle(
                                                      color: Colors.green)),
                                            ],
                                          )
                                        : confirmingBookingId == booking['id']
                                            ? CircularProgressIndicator()
                                            : ElevatedButton(
                                                onPressed: () =>
                                                    confirmUserBookingHandler(
                                                        booking['id']),
                                                child: Text('Confirm',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                style: ElevatedButton
                                                    .styleFrom(
                                                  backgroundColor:
                                                      CustomColors.peelOrange,
                                                ),
                                              ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Center(
                            child: Text('No user found',
                                style: TextStyle(color: Colors.white)),
                          );
                        }
                      },
                    );
                  },
                ),
    );
  }
}

String formatStartTime(String isoString) {
  DateTime dateTime = DateTime.parse(isoString);
  String formattedDate =
      DateFormat('EEEE, yyyy-MM-dd – kk:mm').format(dateTime);
  return formattedDate;
}
