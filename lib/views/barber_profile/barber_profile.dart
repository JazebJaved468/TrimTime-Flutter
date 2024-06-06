import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/components/carousel.dart';
import 'package:trim_time/components/reviewBox.dart';
import 'package:trim_time/components/servicesContainer.dart';
import 'package:trim_time/components/timeSlotBox.dart';
import 'package:trim_time/views/appointment_summary/appointment_summary.dart';

class BarberProfile extends StatefulWidget {
  const BarberProfile({super.key});

  @override
  State<BarberProfile> createState() => _BarberProfileState();
}

class _BarberProfileState extends State<BarberProfile> {
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

  List<String> services = [
    'Hair Cut',
    'Beard Trim',
    'Hair Coloring',
    'Face Treatment',
  ];

  void onTimeSlotTap(int index, String time) {
    setState(() {
      selectedtime = time;
      selectedIndex = index; //tapped index
      print(time);
    });
  }

  void onServiceTap(String service) {
    setState(() {
      if (selectedServices.contains(service)) {
        selectedServices.remove(service);
      } else {
        selectedServices.add(service);
      }
      print(selectedServices); // For debugging purposes
    });
  }

  Future<void> selectDate() async {
    DateTime? selected = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 7)));

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
                      'Barbarella Inova',
                      style: TextStyle(
                          fontSize: 30,
                          color: CustomColors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          fontFamily: 'Raleway'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: () {
                          if (clicked) {
                            clicked = false;
                            setState(() {});
                          } else {
                            clicked = true;
                            setState(() {});
                          }
                        },
                        child: Icon(
                          clicked ? Icons.favorite : Icons.favorite_border,
                          color: clicked ? Colors.red : Colors.white,
                        ),
                      ),
                    ),
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
                      'British Hair Salon',
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
                        '6993 Meadow Valley Terrace, New York',
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
                      '1234 5667 8907',
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

              Container(
                  padding: const EdgeInsets.only(left: 15),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        // Services(),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        // Services(),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        // Services(),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        // Services(),

                        ///he spread operator ... takes each Services from the generated list and inserts it into the  list of row children.
                        ...List.generate(services.length, (index) {
                          return Services(
                            service: services[index],
                            clicked: selectedServices.contains(services[index]),
                            onTap: () => onServiceTap(services[index]),
                          );
                        }),
                      ]))),

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
                    InkWell(
                      onTap: () {
                        selectDate();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.calendar_month_outlined,
                          color: CustomColors.white,
                        ),
                      ),
                    ),
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
                      child: Text(
                        selectedDate == null
                            ? 'No Day Selected'
                            : 'Schedule Appointment on $selectedDate',
                        style: TextStyle(
                          color: CustomColors.white,
                          fontFamily: 'Poppins',
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: selectedDay == null
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
                      : ExpansionTile(
                          shape:
                              const Border(), //to remove divider lines when expanded
                          title: Text(
                            '$selectedDay',
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
                                  children:
                                      List.generate(times.length, (index) {
                                    return TimeSlot(
                                      time: times[index],
                                      isSelected: selectedIndex == index,

                                      ///We set the isSelected property of each TimeSlot widget to true if its index matches the selectedIndex, indicating that it is currently selected. Everyime when the slot is pressed , only that slots isSelected proprty will bocome true and other remains false. bcz selectedIndex== tappedIndex
                                      onTap: () =>
                                          onTimeSlotTap(index, times[index]),
                                    );
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
                ),
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
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: CustomColors.gunmetal,
              height: 70,
              child: InkWell(
                onTap: () {
                  // Check if all three fields are null
                  if (selectedServices.isEmpty ||
                      selectedDate == null ||
                      selectedtime == null) {
                    // Show alert box: Kindly provide complete info
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Alert'),
                          content: const Text('Kindly provide complete info.'),
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
                  } else {
                    // Show alert box: Successful booking
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Success'),
                          content: Text(
                              'Successful booking made on $selectedDate between $selectedtime.'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Next'),
                              onPressed: () {
                                // Redirect to next screen
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AppointmentSummary()),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
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
                  child: const Center(
                    child: Text(
                      'Book Now',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
