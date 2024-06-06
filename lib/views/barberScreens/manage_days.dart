import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/controller/firestore.dart';
import 'package:trim_time/controller/local_storage.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/authentication/signup_page.dart';
import 'package:trim_time/views/barberScreens/manage_slots.dart';
import 'package:intl/intl.dart';

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
    SampleProvider sampleProvider =
        Provider.of<SampleProvider>(context, listen: false);

    var days = sampleProvider.barberAvailability.keys.toList();
    // Sorting days bcz firebase is not giving values in correct order
    days.sort((a, b) => DateTime.parse(a).compareTo(DateTime.parse(b)));

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {
        sampleProvider.setUpdateDaysCIP(true);

        await _updateData(
            uid: sampleProvider.uid,
            barberAvailability: sampleProvider.barberAvailability);

        sampleProvider.setUpdateDaysCIP(false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Days updated successfully'),
            duration: Duration(seconds: 1),
          ),
        );
      }, child: Consumer<SampleProvider>(
        builder: (context, provider, child) {
          return provider.updateDaysCIP
              ? Container(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                  ),
                )
              : const Icon(Icons.done);
        },
      )),
      appBar: AppBar(
        title: const Text('Manage Days'),
        actions: [
          IconButton(
            onPressed: () async {
              await signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Signup()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: sampleProvider.barberAvailability.keys.length,
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
                  child: Consumer<SampleProvider>(
                      builder: (context, provider, child) {
                    return ListTile(
                        title: Text(
                            'Day : ${DateFormat('EEEE').format(DateTime.parse(day))}'),
                        subtitle: Wrap(direction: Axis.vertical, children: [
                          Text(
                              'Date : ${DateFormat('d MMM').format(DateTime.parse(day))}'),
                          Switch(
                            value: sampleProvider.barberAvailability[day]
                                ['isAvailable'],
                            onChanged: (value) {
                              provider.updateBarberDaysAvailability(
                                  day: day, value: value);
                            },
                          ),
                        ]),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                        ));
                  }),
                );
              }),
    );
  }
}