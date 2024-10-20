import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/controller/local_storage.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/barberScreens/barber_bookings.dart';
import 'package:trim_time/views/barberScreens/barber_reviews.dart';
import 'package:trim_time/views/barberScreens/manage_days.dart';
import 'package:trim_time/views/sign_in/sign_in.dart';

class BarberHomePage extends StatefulWidget {
  BarberHomePage({super.key});

  @override
  State<BarberHomePage> createState() => _BarberHomePageState();
}

class _BarberHomePageState extends State<BarberHomePage> {
  late Map<String, dynamic> localData;
  final isClient = false;
  bool _isLoading = true;

  List cardData = [
    {'name': 'Availability', 'icon': Icons.calendar_month_outlined},
    {'name': 'Bookings', 'icon': Icons.collections_bookmark_outlined},
    {'name': 'Reviews', 'icon': Icons.reviews_outlined},
    {'name': '', 'icon': Icons.calendar_month_outlined},
  ];

  _loadData() async {
    localData = await getDataFromLocalStorage();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    double mediaWidth = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      child: Scaffold(
          backgroundColor: CustomColors.gunmetal,
          key: scaffoldkey,
          drawerEnableOpenDragGesture: true,
          appBar: AppBar(
            leadingWidth: 70,
            leading: GestureDetector(
              onTap: () {
                scaffoldkey.currentState!.openDrawer();
              },
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: SvgPicture.asset(
                  'assets/images/svgs/logo2_timelytrim.svg',
                ),
              ),
            ),
            elevation: 0,
            centerTitle: true,
            titleTextStyle: const TextStyle(
                color: CustomColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500),
            backgroundColor: CustomColors.gunmetal,
            title: const Text(
              'Timely Trim',
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      titlePadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      backgroundColor: CustomColors.charcoal,
                      title: const Text(
                        "Are You Sure You Want To Logout?",
                        style: TextStyle(
                          color: CustomColors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.peelOrange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                )),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: CustomColors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await appProvider.handleLogoutByProvider();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const SignIn()),
                                  (Route route) => false);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.peelOrange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                )),
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                color: CustomColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.logout,
                  color: CustomColors.white,
                  size: 22,
                ),
              )
            ],
          ),
          body: _isLoading
              ? const Center(
                  child: SpinKitFadingCircle(
                  color: CustomColors.peelOrange,
                  size: 50.0,
                ))
              : Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 30),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(
                                    appProvider.localDataInProvider['userData']
                                        ['photoURL']),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        direction: Axis.horizontal,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          const Text(
                                            'Hello',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: CustomColors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SvgPicture.asset(
                                            'assets/images/svgs/waveHand.svg',
                                            color: CustomColors.peelOrange,
                                            width: 20,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        '${appProvider.localDataInProvider['userData']['name']}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: CustomColors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Container(
                                        child: Text(
                                          '${appProvider.localDataInProvider['userData']['email']}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300,
                                            color: CustomColors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: const Text(
                            'Dashboard',
                            style: TextStyle(
                                fontSize: 24, color: CustomColors.white),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: GridView.count(
                            crossAxisCount: 2, // 2 columns
                            crossAxisSpacing: 16, // Space between columns
                            mainAxisSpacing: 16, // Space between rows
                            shrinkWrap:
                                true, // Shrinks the grid to fit the content
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(3, (index) {
                              return GestureDetector(
                                onTap: () {
                                  if (index == 0) {
                                    appProvider.uid =
                                        localData['userData']['uid'];
                                    appProvider
                                        .setUserData(localData['userData']);
                                    appProvider.barberAvailability =
                                        localData['userData']['availability'];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ManageDays()),
                                    );
                                  } else if (index == 1) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BarberBookings()),
                                    );
                                  } else if (index == 2) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BarberReviews()),
                                    );
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    color: CustomColors.peelOrange
                                        .withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Icon(
                                          cardData[index]['icon'],
                                          size: 40,
                                          color: CustomColors.white
                                              .withOpacity(0.8),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        '${cardData[index]['name']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
    );
  }
}
