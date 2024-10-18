import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/controller/firestore.dart';
import 'package:trim_time/controller/local_storage.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/barberScreens/manage_slots.dart';
import 'package:intl/intl.dart';
import 'package:trim_time/views/sign_in/sign_in.dart';

class ManageDays extends StatefulWidget {
  const ManageDays({super.key});

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
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    var days = appProvider.barberAvailability.keys.toList();
    days.sort((a, b) => DateTime.parse(a).compareTo(DateTime.parse(b)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Days'),
        actions: [
          IconButton(
            onPressed: () async {
              await signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => SignIn()),
                  (Route route) => false);
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
                    return ListTile(
                      title: Text(
                          'Day : ${DateFormat('EEEE').format(DateTime.parse(day))}'),
                      subtitle: Wrap(
                        direction: Axis.vertical,
                        children: [
                          Text(
                              'Date : ${DateFormat('d MMM').format(DateTime.parse(day))}'),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    );
                  }),
                );
              }),
    );
  }
}
