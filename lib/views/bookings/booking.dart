import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/components/CustomAppBar.dart';
import 'package:trim_time/components/EmptyList.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:intl/intl.dart';
import 'package:trim_time/utilities/helpers/functions.dart';
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
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    switch (selectedIndex) {
      case 1:
        currentListing = appProvider.cancelledBookingsClient;
        break;
      case 2:
        currentListing = appProvider.completedBookingsClient;
        break;
      default:
        currentListing = appProvider.upcomingBookingsClient;
    }

    return Scaffold(
      backgroundColor: CustomColors.gunmetal,
      appBar: CustomAppBar(
        title: 'My Bookings',
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
          Consumer<AppProvider>(
            builder: (context, provider, child) {
              return Expanded(
                child: selectedIndex == 0 &&
                        provider.upcomingBookingsClient.isEmpty
                    ? const EmptyList(message: 'No Upcoming Bookings')
                    : selectedIndex == 1 &&
                            provider.cancelledBookingsClient.isEmpty
                        ? const EmptyList(message: 'No Cancelled Bookings')
                        : selectedIndex == 2 &&
                                provider.completedBookingsClient.isEmpty
                            ? const EmptyList(message: 'No Completed Bookings')
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

class BookingCardClient extends StatelessWidget {
  BookingCardClient({Key? key, required this.booking}) : super(key: key);
  final Map booking;

  late String startTime = booking['startTime'];
  late String endTime = booking['endTime'];
  late bool isCancelled = booking['isCancelled'];
  late bool isCompleted = booking['isCompleted'];
  late bool isConfirmed = booking['isConfirmed'];
  late String barberName = booking['barberData']['name'];
  late String shopName = booking['barberData']['shopName'];
  late String shopAddress = booking['barberData']['shopAddress'];
  late String phoneNumber = booking['barberData']['phoneNumber'];
  late String totalAmount = booking['totalAmount'].toString();
  late String imageUrl = booking['barberData']['photoURL'];
  late bool isRated = booking['isRated'];
  late bool isPaid = booking['isPaid'];
  late String slotId = booking['slotId'];
  late String bookingId = booking['id'];
  late String serviceId = booking['serviceId'];

// Just for testing
  // late bool isCancelled = false;
  // late bool isCompleted = false;
  // late bool isConfirmed = true;
  // late bool isRated = false;
  // late bool isPaid = false;

  late String dateTime =
      DateFormat('EEE, d MMM yyyy, h:mm a').format(DateTime.parse(startTime));

  late String day = DateFormat('EEEE').format(DateTime.parse(startTime));
  late String date = DateFormat('d MMM yyyy').format(DateTime.parse(startTime));

  late String startTimeFormatted =
      DateFormat('h:mm a').format(DateTime.parse(startTime));

  late String endTimeFormatted =
      DateFormat('h:mm a').format(DateTime.parse(endTime));

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

  Widget getCustomButton({required BuildContext context}) {
    if (!isCancelled &&
        (!isConfirmed || isConfirmed) &&
        !isPaid &&
        !isRated &&
        !isCompleted) {
      return Container(
        child: ElevatedButton(
          onPressed: () {
            if (!isConfirmed) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Please wait for the barber to confirm your booking'),
                ),
              );
            } else {
              //  paymentFunction();
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.peelOrange),
          child: const Text(
            'Pay',
            style: TextStyle(color: CustomColors.white),
          ),
        ),
      );
    } else if (!isCancelled && !isRated && isCompleted && isPaid) {
      return Container(
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
            'Rate',
            style: TextStyle(color: CustomColors.white),
          ),
        ),
      );
    } else if (!isCancelled && isCompleted && isPaid && isRated) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: CustomColors.peelOrange),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Rated',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    // String day = DateFormat('EEEE').format(DateTime.parse(dateTime));
    // String date = DateFormat('d MMM').format(DateTime.parse(dateTime));
    return Card(
      color: CustomColors.charcoal,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
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
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        children: [
                          const Icon(Icons.calendar_month,
                              size: 18, color: CustomColors.white),
                          Text(
                            '$day',
                            style: const TextStyle(color: CustomColors.white),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        children: [
                          const Icon(Icons.edit_calendar_outlined,
                              size: 18, color: CustomColors.white),
                          Text(
                            '$date',
                            style: const TextStyle(color: CustomColors.white),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        children: [
                          const Icon(Icons.timer_outlined,
                              size: 18, color: CustomColors.white),
                          Text(
                            '$startTimeFormatted - $endTimeFormatted',
                            style: const TextStyle(color: CustomColors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                const Icon(
                  Icons.person_outline_rounded,
                  color: CustomColors.peelOrange,
                  size: 18,
                ),
                Text(
                  '${capitalizeFirstLetterOfEachWord(barberName)}',
                  style: const TextStyle(
                      color: CustomColors.peelOrange,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                const Icon(Icons.store_mall_directory,
                    size: 18, color: CustomColors.white),
                Text(
                  '${capitalizeFirstLetterOfEachWord(shopName)}',
                  style: const TextStyle(color: CustomColors.white),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                const Icon(Icons.phone, size: 18, color: CustomColors.white),
                Text(
                  '$phoneNumber',
                  style: const TextStyle(color: CustomColors.white),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                const Icon(Icons.shortcut_sharp,
                    size: 18, color: CustomColors.white),
                Text(
                  '$shopAddress',
                  style: const TextStyle(color: CustomColors.white),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 36,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    children: [
                      const Icon(Icons.monetization_on_outlined,
                          size: 18, color: CustomColors.peelOrange),
                      Text(
                        'Rs. $totalAmount',
                        style: const TextStyle(
                          color: CustomColors.peelOrange,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  getCustomButton(context: context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
