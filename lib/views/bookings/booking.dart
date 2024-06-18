import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:intl/intl.dart';
import 'package:trim_time/views/reviewsAndRating/reviews.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final isClient = true;
  int selectedIndex = 0;

  late List currentListing;

  @override
  Widget build(BuildContext context) {
    SampleProvider sampleProvider =
        Provider.of<SampleProvider>(context, listen: false);
    switch (selectedIndex) {
      case 1:
        currentListing = sampleProvider.cancelledBookingsClient;
        break;
      case 2:
        currentListing = sampleProvider.completedBookingsClient;
        break;
      default:
        currentListing = sampleProvider.upcomingBookingsClient;
    }

    return Scaffold(
      backgroundColor: CustomColors.gunmetal,
      appBar: AppBar(
        backgroundColor: CustomColors.gunmetal,
        title: const Text(
          'My Bookings',
          style: TextStyle(color: CustomColors.white),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildChoiceChip('Upcoming', 0),
                buildChoiceChip('Cancelled', 1),
                buildChoiceChip('Completed', 2),
              ],
            ),
          ),
          Consumer<SampleProvider>(
            builder: (context, provider, child) {
              return Expanded(
                child: selectedIndex == 0 &&
                        provider.upcomingBookingsClient.isEmpty
                    ? const Center(
                        child: Text(
                          'No upcoming bookings',
                          style: TextStyle(color: CustomColors.white),
                        ),
                      )
                    : selectedIndex == 1 &&
                            provider.cancelledBookingsClient.isEmpty
                        ? const Center(
                            child: Text(
                              'No Cancelled bookings',
                              style: TextStyle(color: CustomColors.white),
                            ),
                          )
                        : selectedIndex == 2 &&
                                provider.completedBookingsClient.isEmpty
                            ? const Center(
                                child: Text(
                                  'No Completed bookings',
                                  style: TextStyle(color: CustomColors.white),
                                ),
                              )
                            : ListView.builder(
                                itemCount: currentListing.length,
                                itemBuilder: (context, index) {
                                  final booking = currentListing[index];
                                  return BookingCardClient(
                                    booking: booking,
                                  );
                                },
                              ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildChoiceChip(String label, int index) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color:
              isSelected ? CustomColors.peelOrange : CustomColors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: CustomColors.peelOrange,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? CustomColors.white : CustomColors.peelOrange,
          ),
        ),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class BookingCardClient extends StatelessWidget {
  BookingCardClient({Key? key, required this.booking}) : super(key: key);
  final Map booking;

  late String startTime = booking['startTime'];
  late String endTime = booking['endTime'];
  late bool isCancelled = booking['isCancelled'];
  late bool isCompleted = booking['isCompleted'];
  late bool isConfirmed = booking['isConfirmed'];
  // late bool isCancelled = false;
  // late bool isCompleted = true;
  // late bool isConfirmed = true;
  late String barberName = booking['barberData']['name'];
  late String shopName = booking['barberData']['shopName'];
  late String totalAmount = booking['totalAmount'].toString();
  late String imageUrl = booking['barberData']['photoURL'];
  late bool isRated = booking['isRated'];
  late bool isPaid = booking['isPaid'];
  late String slotId = booking['slotId'];
  late String bookingId = booking['id'];
  late String serviceId = booking['serviceId'];

  late String dateTime =
      DateFormat('EEE, d MMM yyyy, h:mm a').format(DateTime.parse(startTime));

  late String day = DateFormat('EEEE').format(DateTime.parse(startTime));
  late String date = DateFormat('d MMM yyyy').format(DateTime.parse(startTime));

  late String startTimeFormatted =
      DateFormat('h:mm a').format(DateTime.parse(startTime));

  late String endTimeFormatted =
      DateFormat('h:mm a').format(DateTime.parse(endTime));

  late bool isPayButtonEnabled = !isPaid && isConfirmed;

  shouldShowRateButton() {
    return isCompleted && isConfirmed && !isRated && !isCancelled;
  }

  getServiceName() {
    if (serviceId == '1') {
      return 'Haircut';
    } else if (serviceId == '2') {
      return 'Shave';
    } else if (serviceId == '3') {
      return 'Beard Trim';
    } else {
      return 'Massage';
    }
  }

  @override
  Widget build(BuildContext context) {
    // String day = DateFormat('EEEE').format(DateTime.parse(dateTime));
    // String date = DateFormat('d MMM').format(DateTime.parse(dateTime));
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        barberName,
                        style: const TextStyle(
                            color: CustomColors.peelOrange,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rs. ${totalAmount}',
                        style: const TextStyle(
                            color: CustomColors.peelOrange,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    shopName,
                    style: const TextStyle(color: CustomColors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Booking Day: $day',
                    style: const TextStyle(color: CustomColors.white),
                  ),
                  Text(
                    'Booking Date: $date',
                    style: const TextStyle(color: CustomColors.white),
                  ),
                  Text(
                    'Booking Time: $startTimeFormatted - $endTimeFormatted',
                    style: const TextStyle(color: CustomColors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Booking ID: $bookingId',
                    style: const TextStyle(color: CustomColors.white),
                  ),
                  Text(
                    'Service: ${getServiceName()}',
                    style: const TextStyle(color: CustomColors.white),
                  ),
                  Container(
                    child: Text(
                      'Status: ${isConfirmed ? 'Confirmed By Barber, Pay to secure spot' : 'Pending'}',
                      style: const TextStyle(color: CustomColors.white),
                    ),
                  ),
                  Visibility(
                      child: Text(
                        'rated ✨',
                        style: TextStyle(color: CustomColors.white),
                      ),
                      visible: isRated),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        // Expanded(
                        //   flex: 2,
                        Visibility(
                          visible: shouldShowRateButton(),
                          child: Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReviewsAndRating(
                                      bookingData: booking,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: CustomColors.peelOrange),
                              child: const Text(
                                'Rate BArber',
                                style: TextStyle(color: CustomColors.white),
                              ),
                            ),
                          ),
                        ),
                        // ),
                        Expanded(
                          child: Visibility(
                            visible: isConfirmed && !isPaid,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: CustomColors.peelOrange),
                              child: const Text(
                                'Pay',
                                style: TextStyle(color: CustomColors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
