import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/controller/local_storage.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/barberScreens/barber_bookings.dart';
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

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Barber Home Page'),
        actions: [
          IconButton(
            onPressed: () async {
              await appProvider.handleLogoutByProvider();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SignIn()),
                  (Route route) => false);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: SpinKitFadingCircle(
              color: CustomColors.peelOrange,
              size: 50.0,
            ))
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome ${localData['userData']['name']}'),
                  Text('Email: ${localData['userData']['email']}'),
                  Text('Phone Number: ${localData['userData']['phoneNumber']}'),
                  Text('isClient: ${localData['isClient']}'),
                  ElevatedButton(
                    onPressed: () {
                      appProvider.uid = localData['userData']['uid'];
                      // appProvider.setUserData(localData['userData']);
                      appProvider.barberAvailability =
                          localData['userData']['availability'];
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ManageDays()),
                      );
                    },
                    child: const Text('Manage Slots'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BarberBookings()),
                      );
                    },
                    child: const Text('Bookings'),
                  ),
                ],
              ),
            ),
    );
  }
}
