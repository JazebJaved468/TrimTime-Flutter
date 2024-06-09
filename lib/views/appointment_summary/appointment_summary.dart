import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/controller/firestore.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/utilities/constants/constants.dart';
import 'package:trim_time/views/homescreenclient/homescreenclient.dart';

class AppointmentSummary extends StatefulWidget {
  const AppointmentSummary({super.key});

  @override
  State<AppointmentSummary> createState() => _AppointmentSummaryState();
}

class _AppointmentSummaryState extends State<AppointmentSummary> {
  // final List<Map<String, String>> services = [
  //   {'name': 'Haircut', 'price': '500'},
  //   {'name': 'Hair Coloring', 'price': '2000'},
  //   {'name': 'Face Treatment', 'price': '800'},
  //   // Add more services as needed
  // ];

  @override
  Widget build(BuildContext context) {
    SampleProvider sampleProvider =
        Provider.of<SampleProvider>(context, listen: false);

    String date = DateFormat('dd-MM-yyyy').format(sampleProvider.selectedDate);
    String startTime = DateFormat('hh : mm a')
        .format(DateTime.parse(sampleProvider.selectedSlot['start']));
    String endtime = DateFormat('hh : mm a')
        .format(DateTime.parse(sampleProvider.selectedSlot['end']));
    String serviceName = sampleProvider.getSelectedServiceName();
    int servicePrice = sampleProvider.getSelectedServicePrice();

    // Calculate the total price
    int total = sampleProvider.getTotalPrice();
    // services.fold(0, (sum, item) => sum + int.parse(item['price']!));
    return Scaffold(
      backgroundColor: CustomColors.gunmetal,
      appBar: AppBar(
        backgroundColor: CustomColors.gunmetal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Booking Summary',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Scrollable background content
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: 20,
                    right: 20,
                  ),
                  decoration: const BoxDecoration(
                      color: CustomColors.charcoal,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Barber',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            sampleProvider.selectedBarber['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Salon',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            sampleProvider.selectedBarber['shopName'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Address',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Flexible(
                            child: Text(
                              sampleProvider.selectedBarber['shopAddress'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontFamily: 'Poppins',
                              ),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Phone',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            sampleProvider.selectedBarber['phoneNumber'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Booking Date',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            date,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Booking Hours',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            '${startTime} - ${endtime}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: 20,
                    right: 20,
                  ),
                  decoration: const BoxDecoration(
                      color: CustomColors.charcoal,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            serviceName,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            'Rs. ${servicePrice}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'GST (18%)',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            'Rs. ${servicePrice * GST_PERCENTAGE}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      // ...services.map(
                      //     (service) //It spreads the resulting list of widgets into the parent widget's children list.
                      //     {
                      //   return Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text(
                      //             service['name']!,
                      //             style: const TextStyle(
                      //               color: Colors.grey,
                      //               fontSize: 12,
                      //               fontFamily: 'Poppins',
                      //             ),
                      //           ),
                      //           Text(
                      //             'Rs. ${service['price']}',
                      //             style: const TextStyle(
                      //               color: Colors.white,
                      //               fontSize: 13,
                      //               fontFamily: 'Poppins',
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       const SizedBox(
                      //         height: 10,
                      //       ),
                      //     ],
                      //   );
                      // }),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 91, 90, 90),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            'Rs. $total',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Fixed position container
          Consumer<SampleProvider>(builder: (context, provider, child) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(30), // Margin around the button
                child: GestureDetector(
                  onTap: () async {
                    // Navigator.of(context).pop();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const ()),
                    // );

                    provider.setCreateBookingCIP(true);

                    int responseCode = await provider.createBooking();

                    if (responseCode == -1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Sorry, Someone booked that slot in mean time, booking failed',
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Booking is successful'),
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }
                    // bool isSlotAvailable =
                    //     await checkBookingSlotIsAvailableInFirestore(
                    //         barberId: provider.selectedBarber['uid'],
                    //         slotId: provider.selectedSlot['slotId'],
                    //         selectedDate:
                    // provider.selectedDate.toIso8601String());

                    // int response = await createBookingInFirestore(
                    //   barberId: provider.selectedBarber['uid'],
                    //   clientId: provider.userData['uid'],
                    //   serviceId: provider.selectedService,
                    //   slot: provider.selectedSlot,
                    //   selectedDate: provider.selectedDate.toIso8601String(),
                    // );

                    // if (response == -1) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text(
                    //         'Sorry, Someone booked that slot in mean time, booking failed',
                    //       ),
                    //     ),
                    //   );
                    //   Navigator.pop(context);
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text('Booking is successful'),
                    //     ),
                    //   );

                    // if (result == 0) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text('Booking is successful'),
                    //     ),
                    //   );
                    //   Navigator.pop(context);
                    // }

                    //  else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text('Booking failed'),
                    //     ),
                    //   );
                    // }
                    // }

                    await provider.updateAllBookings();
                    await provider.updateUpcomingBookingsClient();
                    provider.setCreateBookingCIP(false);
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: CustomColors.peelOrange,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: provider.createBookingCIP
                          ? const SpinKitFadingCircle(
                              color: CustomColors.charcoal,
                              size: 30.0,
                            )
                          : Text(
                              'Book Now',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),

                      //  Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //   'Confirm Booking',
                      //   style: TextStyle(
                      //       color: Colors.white,
                      //       fontSize: 20,
                      //       fontWeight: FontWeight.bold,
                      //       fontFamily: 'Poppins'),
                      // ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      // Image(
                      //   image: AssetImage('assets/images/stripe-logo.png'),
                      //   height: 25,
                      // ),
                      // ],
                    ),
                  ),
                ),
              ),
            );
          }),
          // ),
        ],
      ),
    );
  }
}

// //example payment page
// class NextScreen extends StatelessWidget {
//   const NextScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Make Payment'),
//       ),
//     );
//   }
// }
