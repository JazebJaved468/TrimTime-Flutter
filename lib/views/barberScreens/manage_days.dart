import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/components/CustomAppBar.dart';
import 'package:trim_time/controller/firestore.dart';
import 'package:trim_time/controller/local_storage.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/barberScreens/manage_slots.dart';
import 'package:intl/intl.dart';
import 'package:trim_time/views/sign_in/sign_in.dart';

class ManageDays extends StatefulWidget {
  const ManageDays({super.key});

  // final barberAvailability;
  @override
  State<ManageDays> createState() => _ManageDaysState();
}

class _ManageDaysState extends State<ManageDays> {
  late Map<String, dynamic> localData;
  final isClient = false;
  bool _isLoading = true;

  _loadData() async {
    localData = await getDataFromLocalStorage();

    setState(() {
      _isLoading = false;
    });
  }

  _updateData(
      {required String uid,
      required Map<String, dynamic> barberAvailability}) async {
    await updateBarberAvailabilityInFirestore(
      barberId: uid,
      data: barberAvailability,
    );

    await updateUserDataInLocalStorage(
        data: await getUserDataFromFirestore(uid, isClient));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    var days = appProvider.barberAvailability.keys.toList();
    // Sorting days bcz firebase is not giving values in correct order
    days.sort((a, b) => DateTime.parse(a).compareTo(DateTime.parse(b)));

    return Scaffold(
      backgroundColor: CustomColors.gunmetal,
      floatingActionButton: FloatingActionButton(
          backgroundColor: CustomColors.peelOrange,
          onPressed: () async {
            appProvider.setUpdateDaysCIP(true);

            await _updateData(
                uid: appProvider.uid,
                barberAvailability: appProvider.barberAvailability);

            appProvider.setUpdateDaysCIP(false);

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Days updated successfully'),
                  duration: Duration(seconds: 1),
                ),
              );
            }
          },
          child: Consumer<AppProvider>(
            builder: (context, provider, child) {
              return provider.updateDaysCIP
                  ? const SpinKitFadingCircle(
                      color: CustomColors.charcoal,
                      size: 26.0,
                    )
                  : const Icon(
                      Icons.done_rounded,
                      size: 28,
                    );
            },
          )),
      appBar: CustomAppBar(
        title: 'Manage Days',
        // rightIcon: IconButton(
        //   onPressed: () async {
        //     await signOut();
        //     Navigator.of(context).pushAndRemoveUntil(
        //         MaterialPageRoute(builder: (context) => SignIn()),
        //         (Route route) => false);
        //   },
        //   icon: const Icon(Icons.logout),
        // ),
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: appProvider.barberAvailability.keys.length,
                      itemBuilder: (context, index) {
                        var day = days[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ManageSlots(
                                  day: day,
                                ),
                              ),
                            );
                          },
                          child: Consumer<AppProvider>(
                              builder: (context, provider, child) {
                            return Container(
                              padding:
                                  EdgeInsets.only(top: 10, bottom: 10, left: 4),
                              decoration: BoxDecoration(
                                color: CustomColors.charcoal,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.black38, // Border color
                                  width: 1, // Border width
                                ),
                              ),
                              margin: EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 8),
                              child: ListTile(
                                  title: Text(
                                    'Day : ${DateFormat('EEEE').format(DateTime.parse(day))}',
                                    style: TextStyle(color: CustomColors.white),
                                  ),
                                  subtitle:
                                      Wrap(direction: Axis.vertical, children: [
                                    Text(
                                      'Date : ${DateFormat('d MMM').format(DateTime.parse(day))}',
                                      style:
                                          TextStyle(color: CustomColors.white),
                                    ),
                                    Transform.scale(
                                      scale: 0.8,
                                      child: Switch(
                                        trackOutlineWidth:
                                            MaterialStatePropertyAll(1),
                                        trackOutlineColor:
                                            MaterialStatePropertyAll(
                                                CustomColors.peelOrange),
                                        activeColor: Colors.black,
                                        activeTrackColor:
                                            CustomColors.peelOrange,
                                        inactiveThumbColor:
                                            CustomColors.peelOrange,
                                        inactiveTrackColor:
                                            CustomColors.transparent,
                                        value:
                                            appProvider.barberAvailability[day]
                                                ['isAvailable'],
                                        onChanged:
                                            appProvider.barberAvailability[day]
                                                        ['hasBooking'] ??
                                                    false
                                                ? null
                                                : (value) {
                                                    provider
                                                        .updateBarberDaysAvailability(
                                                            day: day,
                                                            value: value);
                                                  },
                                      ),
                                    ),
                                  ]),
                                  trailing: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: CustomColors.white)),
                            );
                          }),
                        );
                      }),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
    );
  }
}
