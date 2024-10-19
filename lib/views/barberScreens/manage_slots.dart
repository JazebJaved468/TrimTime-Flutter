import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/components/CustomAppBar.dart';
import 'package:trim_time/controller/firestore.dart';
import 'package:trim_time/controller/local_storage.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/sign_in/sign_in.dart';

class ManageSlots extends StatefulWidget {
  const ManageSlots({super.key, required this.day});

  final String day;

  @override
  State<ManageSlots> createState() => _ManageSlotsState();
}

class _ManageSlotsState extends State<ManageSlots> {
  final isClient = false;

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
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    return Scaffold(
        backgroundColor: CustomColors.gunmetal,
        floatingActionButton: FloatingActionButton(
            backgroundColor: CustomColors.peelOrange,
            onPressed: () async {
              appProvider.setUpdateSlotsCIP(true);

              await _updateData(
                  uid: appProvider.uid,
                  barberAvailability: appProvider.barberAvailability);

              appProvider.setUpdateSlotsCIP(false);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Slots updated successfully'),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
            child: Consumer<AppProvider>(
              builder: (context, provider, child) {
                return provider.updateSlotsCIP
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
          title: '${DateFormat('EEEE').format(DateTime.parse(widget.day))}',
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
        body: appProvider.barberAvailability[widget.day] == null
            ? const Center(
                child: Text('No slots available for this day'),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: appProvider
                            .barberAvailability[widget.day]['slots'].length,
                        itemBuilder: (context, index) {
                          var slot = appProvider.barberAvailability[widget.day]
                              ['slots'][index];
                          return Consumer<AppProvider>(
                              builder: (context, provider, child) {
                            return Container(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 16, right: 16),
                              decoration: BoxDecoration(
                                color: CustomColors.charcoal,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.black38, // Border color
                                  width: 1, // Border width
                                ),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: const Text(
                                          'Slot Time:',
                                          style: TextStyle(
                                              color: CustomColors.white),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          '${DateFormat('hh : mm').format(DateTime.parse(slot['start']))} - ${DateFormat('hh : mm').format(DateTime.parse(slot['end']))}',
                                          style: const TextStyle(
                                              color: CustomColors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                        }),
                    const SizedBox(
                      height: 70,
                    )
                  ],
                ),
              ));
  }
}
