import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/components/carousel.dart';
import 'package:trim_time/components/reviewBox.dart';
import 'package:trim_time/components/servicesContainer.dart';
import 'package:trim_time/components/timeSlotBox.dart';
import 'package:trim_time/controller/firestore.dart';
import 'package:trim_time/controller/local_storage.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/clientScreens/summary.dart';
import 'package:trim_time/views/appointment_summary/appointment_summary.dart';

class BarberProfile extends StatefulWidget {
  const BarberProfile({super.key});

  @override
  State<BarberProfile> createState() => _BarberProfileState();
}

class _BarberProfileState extends State<BarberProfile> {
  late bool isFavourite;

  bool clicked = false;
  var selectedService = null; //req for make an appointment
  var selectedDate = null; //req for make an appointment
  var selectedDay = null;
  bool customIcon = false;
  int selectedIndex = -1;
  var selectedtime = null; //req for make an appointment
  List<String> selectedServices = [];
  // List of time slots
  List<String> times = [
    '1:00 PM - 1:30 PM',
    '1:30 PM - 2:00 PM',
    '2:00 PM - 2:30 PM',
    '2:30 PM - 3:00 PM',
    '3:00 PM - 3:30 PM'
  ];

  // List<String> services = [
  //   'Hair Cut',
  //   'Beard Trim',
  //   'Hair Coloring',
  //   'Face Treatment',
  // ];

  void onTimeSlotTap(int index, String time) {
    setState(() {
      selectedtime = time;
      selectedIndex = index; //tapped index
      print(time);
    });
  }

  // void onServiceTap(String service) {
  //   setState(() {
  //     if (selectedServices.contains(service)) {
  //       selectedServices.remove(service);
  //     } else {
  //       selectedServices.add(service);
  //     }
  //     print(selectedServices); // For debugging purposes
  //   });
  // }

  Future<void> selectDate() async {
    DateTime? selected = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(days: 7),
      ),
      initialDate: DateTime.now(),
    );

    if (selected != null) {
      print(selected);
      setState(() {
        // selectedDate = selected.toString();
        selectedDate = DateFormat('EEEE, dd-MM-yyyy').format(selected);
        selectedDay = DateFormat('EEEE').format(selected);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SampleProvider sampleProvider =
        Provider.of<SampleProvider>(context, listen: false);

    String selectedBarberId = sampleProvider.selectedBarber['uid'];
    List services = sampleProvider.getBarberServicesForBarberProfile();

    print('services in widgett ----> $services');

    print('selected barber ----> ${sampleProvider.selectedBarber['uid']}');

    return Scaffold(
      backgroundColor: CustomColors.gunmetal,
      body: Stack(
        children: [
          // Scrollable background content
          SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //1.Carousel
              ImageCarousel(),

              const SizedBox(
                height: 25,
              ),

              //2. Name
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      sampleProvider.selectedBarber['name'],
                      style: TextStyle(
                          fontSize: 30,
                          color: CustomColors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          fontFamily: 'Raleway'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Consumer<SampleProvider>(
                          builder: (context, provider, Widget? child) {
                        isFavourite = sampleProvider.allBarbers.firstWhere(
                            (element) =>
                                element['uid'] ==
                                selectedBarberId)['isFavourite'];
                        return GestureDetector(
                          onTap: () async {
                            if (isFavourite) {
                              print('remove fav');
                              sampleProvider
                                  .removeBarberFromFavourites(selectedBarberId);
                            } else {
                              print('add fav');
                              sampleProvider
                                  .addBarberToFavourites(selectedBarberId);
                            }
                          },
                          child: Icon(
                            isFavourite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavourite ? Colors.red : Colors.white,
                          ),
                        );
                      }),
                    )
                  ],
                ),
              ),

              //3. Salon Name
              const SizedBox(
                height: 10,
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.store_mall_directory,
                      color: CustomColors.peelOrange,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      sampleProvider.selectedBarber['shopName'],
                      style: TextStyle(
                          color: CustomColors.white,
                          fontSize: 15,
                          fontFamily: 'Raleway',
                          letterSpacing: 1),
                    )
                  ],
                ),
              ),

              //4. Address
              const SizedBox(
                height: 10,
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.pin,
                      color: CustomColors.peelOrange,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(
                        sampleProvider.selectedBarber['shopAddress'],
                        style: TextStyle(
                          color: CustomColors.white,
                          fontSize: 15,
                          fontFamily: 'Raleway',
                          letterSpacing: 1,
                        ),
                        softWrap: true,
                      ),
                    )
                  ],
                ),
              ),

              //5. phone

              const SizedBox(
                height: 10,
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: CustomColors.peelOrange,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      sampleProvider.selectedBarber['phoneNumber'],
                      style: TextStyle(
                          color: CustomColors.white,
                          fontSize: 15,
                          fontFamily: 'Raleway',
                          letterSpacing: 1),
                    ),
                  ],
                ),
              ),

              //6. rating
              const SizedBox(
                height: 10,
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.star_half_outlined,
                      color: CustomColors.peelOrange,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '4.8 (3279 reviews)',
                      style: TextStyle(
                          color: CustomColors.white,
                          fontSize: 15,
                          fontFamily: 'Raleway',
                          letterSpacing: 1),
                    )
                  ],
                ),
              ),
              //7. Services
              const SizedBox(
                height: 5,
              ),

              Divider(
                color: CustomColors.charcoal,
              ),

              Container(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Select Service',
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.white),
                ),
              ),

              //services boxes
              const SizedBox(
                height: 15,
              ),

              // Consumer<SampleProvider>(builder: (context, provider, child) {
              //   return
              SizedBox(
                height: 160,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Consumer<SampleProvider>(
                        builder: (context, provider, child) {
                      return Services(
                        service: services[index],
                        isSelected: provider.selectedService ==
                            services[index]['serviceId'],
                        // onTap: provider.updateSelectedService(
                        //     services[index]['serviceId']),
                      );
                    });
                  },
                  itemCount: services.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                ),
              )
              // })
              ,

              // SizedBox(
              //   height: 160,
              //   child: ListView.builder(
              //     itemBuilder: (context, index) {
              //       return Services(
              //         service: services[index],
              //         clicked: selectedServices.contains(services[index]),
              //         onTap: ,
              //       );
              //     },
              //     itemCount: services.length,
              //     shrinkWrap: true,
              //     scrollDirection: Axis.horizontal,
              //   ),
              // ),
              // Container(
              //   padding: const EdgeInsets.only(left: 15),
              //   child: SingleChildScrollView(
              //     scrollDirection: Axis.horizontal,
              //     child: Row(
              //       children: [
              //         // Services(),
              //         // SizedBox(
              //         //   width: 10,
              //         // ),
              //         // Services(),
              //         // SizedBox(
              //         //   width: 10,
              //         // ),
              //         // Services(),
              //         // SizedBox(
              //         //   width: 10,
              //         // ),
              //         // Services(),

              //         ///he spread operator ... takes each Services from the generated list and inserts it into the  list of row children.

              //         ...List.generate(services.length, (index) {
              //           return Services(
              //             service: services[index],
              //             clicked: selectedServices.contains(services[index]),
              //             onTap: () => onServiceTap(services[index]),
              //           );
              //         }),
              //       ],
              //     ),
              //   ),
              // ),

              const SizedBox(
                height: 20,
              ),
              //8. date

              Container(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Date',
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.white),
                    ),
                    Consumer<SampleProvider>(
                        builder: (context, provider, child) {
                      return InkWell(
                        onTap: () async {
                          DateTime? selected = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              Duration(days: 6),
                            ),
                            initialDate:
                                sampleProvider.selectedDate ?? DateTime.now(),
                          );

                          print('DAte selected ----> $selected');

                          if (selected != null) {
                            sampleProvider.updateSelectedDate(selected);
                            sampleProvider.updateSlotsToShow();
                          }
                          print(
                              'DAte selected in provider ----> ${sampleProvider.selectedDate}');

                          // selectDate();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.calendar_month_outlined,
                            color: CustomColors.white,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              Center(
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    width: double.infinity,
                    // height: 70,
                    decoration: BoxDecoration(
                        color: CustomColors.charcoal,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Consumer<SampleProvider>(
                        builder: (context, provider, child) {
                          var date = DateFormat('EEEE, dd-MM-yyyy')
                              .format(provider.selectedDate);
                          return Text(
                            provider.selectedDate == null
                                ? 'No Day Selected'
                                : 'Schedule Booking on $date',
                            style: TextStyle(
                              color: CustomColors.white,
                              fontFamily: 'Poppins',
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),

                      // Text(
                      //   selectedDate == null
                      //       ? 'No Day Selected'
                      //       : 'Schedule Booking on $selectedDate',
                      //   style: TextStyle(
                      //     color: CustomColors.white,
                      //     fontFamily: 'Poppins',
                      //     fontSize: 15,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                    )),
              ),

              //9. Time

              const SizedBox(
                height: 20,
              ),

              Container(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Select Time',
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.white),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                width: double.infinity,
                // height: 70,
                decoration: BoxDecoration(
                    color: CustomColors.charcoal,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Consumer<SampleProvider>(
                    builder: (context, provider, child) {
                  var day = DateFormat('EEEE').format(provider.selectedDate);

                  List slots = provider.slotsToShow;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: provider.selectedDate == null
                        ? Center(
                            child: Text(
                              'No Day Selected',
                              style: TextStyle(
                                color: CustomColors.white,
                                fontFamily: 'Poppins',
                                fontSize: 15,
                              ),
                            ),
                          )
                        : slots.length == 0
                            ? Center(
                                child: Text(
                                  'Barber is not Available on $day',
                                  style: TextStyle(
                                    color: CustomColors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 15,
                                  ),
                                ),
                              )
                            :

                            // Wrap(
                            //   spacing: 10,
                            //   runSpacing: 20,
                            //   children: List.generate(slots.length, (index) {
                            //     return TimeSlot(
                            //       time: slots[index]['time'],
                            //       isSelected: selectedIndex == index,
                            //       onTap: () => onTimeSlotTap(
                            //           index, slots[index]['time']),
                            //     );
                            //   }),
                            // )

                            // Text('have slots'),

                            ExpansionTile(
                                shape:
                                    const Border(), //to remove divider lines when expanded
                                title: Text(
                                  day,
                                  style: TextStyle(
                                    color: CustomColors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 15,
                                  ),
                                ),
                                trailing: Icon(
                                  customIcon
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: customIcon
                                      ? CustomColors.peelOrange
                                      : CustomColors.peelOrange,
                                ),
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                          child: Wrap(
                                        spacing: 10,
                                        runSpacing: 20,
                                        // children: [
                                        //   TimeSlot(),
                                        //   TimeSlot(),
                                        //   TimeSlot(),
                                        //   TimeSlot(),
                                        //   TimeSlot(),
                                        // ],
                                        children: List.generate(slots.length,
                                            (index) {
                                          return Consumer<SampleProvider>(
                                              builder:
                                                  (context, provider, child) {
                                            return TimeSlot(
                                              slot: slots[index],
                                              isSelected: provider
                                                      .selectedSlot['slotId'] ==
                                                  slots[index]['slotId'],

                                              ///We set the isSelected property of each TimeSlot widget to true if its index matches the selectedIndex, indicating that it is currently selected. Everyime when the slot is pressed , only that slots isSelected proprty will bocome true and other remains false. bcz selectedIndex== tappedIndex
                                              // onTap: () => onTimeSlotTap(
                                              //     index, times[index]),
                                            );
                                          });
                                        }),
                                      )),
                                    ],
                                  )
                                ],
                                onExpansionChanged: (bool expanded) {
                                  setState(() {
                                    customIcon = expanded;
                                  });
                                },
                              ),
                  );
                }),
              ),

              const SizedBox(
                height: 20,
              ),

              Container(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Reviews',
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.white),
                ),
              ),

              //Reviews

              const Review(),

              Divider(
                color: CustomColors.charcoal,
              ),

              const Review(),

              Divider(
                color: CustomColors.charcoal,
              ),
              const Review(),

              Divider(
                color: CustomColors.charcoal,
              ),
              //for space

              Container(
                height: 110,
                width: 200,
                color: CustomColors.transparent,
              ),
            ]),
          ),
          // Fixed position container

          Consumer<SampleProvider>(builder: (context, provider, child) {
            return Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: CustomColors.gunmetal,
                height: 70,
                child: InkWell(
                  onTap: () async {
                    // Check if all three fields are null
                    // if (provider.selectedSlot == {} ||

                    //     selectedDate == null ||
                    //     selectedtime == null) {
                    // Show alert box: Kindly provide complete info

                    print('\n Booking Data ---------->');
                    print(
                        '\n Booking Date ----------> ${provider.selectedDate.toIso8601String()}');
                    print(
                        '\n Booking service ----------> ${provider.selectedService}');
                    print(
                        '\n Booking Slot ----------> ${provider.selectedSlot}');

                    if (provider.selectedSlot.isEmpty ||
                        provider.selectedService == '') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Alert'),
                            content: Text(provider.selectedService == ''
                                ? 'Kindly select service.'
                                : 'Kindly select time slot.'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                    // }
                    else {
                      print('in else block');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AppointmentSummary()),
                      );

                      // provider.setCreateBookingCIP(true);

                      //  bool isSlotAvailable =  await checkBookingSlotIsAvailableInFirestore(
                      //       barberId: provider.selectedBarber['uid'],
                      //       slotId: provider.selectedSlot['slotId'],
                      //       selectedDate:
                      //           provider.selectedDate.toIso8601String()
                      //   );

                      // await createBookingInFirestore(
                      //     barberId: provider.selectedBarber['uid'],
                      //     clientId: provider.userData['uid'],
                      //     serviceId: provider.selectedService,
                      //     slot: provider.selectedSlot,
                      //     selectedDate:
                      //         provider.selectedDate.toIso8601String());

                      // provider.createBooking(
                      //     barberId: provider.selectedBarber['uid'],
                      //     serviceId: provider.selectedService,
                      //     slotId: provider.selectedSlot['slotId'],
                      //     date: provider.selectedDate);

                      // provider.setCreateBookingCIP(false);

                      // showDialog(
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return AlertDialog(
                      //       title: const Text('Alert'),
                      //       content: Text(
                      //           'successful booking made on ${provider.selectedSlot}.'),
                      //       actions: <Widget>[
                      //         TextButton(
                      //           child: const Text('OK'),
                      //           onPressed: () {
                      //             Navigator.of(context).pop();
                      //           },
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // );
                    }
                    // } else {
                    // Show alert box: Successful booking
                    // showDialog(
                    //   context: context,
                    //   builder: (BuildContext context) {
                    //     return AlertDialog(
                    //       title: const Text('Success'),
                    //       content: Text(
                    //           'Successful booking made on $selectedDate between $selectedtime.'),
                    //       actions: <Widget>[
                    //         TextButton(
                    //           child: const Text('Next'),
                    //           onPressed: () {
                    //             // Redirect to next screen
                    //             Navigator.of(context).pop();
                    //             Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => const NextScreen()),
                    //             );
                    //           },
                    //         ),
                    //       ],
                    //     );
                    //   },
                    // );
                    // }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 30, right: 30),
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                        color: CustomColors.peelOrange,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50))),
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

                      // Text(
                      //   'Book Now',
                      //   style: TextStyle(
                      //       color: Colors.white,
                      //       fontSize: 15,
                      //       fontWeight: FontWeight.bold),
                      // ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
