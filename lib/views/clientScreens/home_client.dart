import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/controller/local_storage.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/clientScreens/barberListing.dart';
import 'package:trim_time/views/clientScreens/client_bookings.dart';
import 'package:trim_time/views/clientScreens/client_profile.dart';
import 'package:trim_time/views/clientScreens/favourites.dart';
import 'package:trim_time/views/sign_in.dart';

class ClientHomePage extends StatefulWidget {
  ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  late Map<String, dynamic> localData;

  final isClient = true;

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
        title: const Text('Client Home Page'),
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
                      // appProvider.uid = localData['userData']['uid'];
                      // appProvider.setUserData(localData['userData']);

                      // appProvider.barberAvailability =
                      //     localData['userData']['availability'];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BarberListing()),
                      );
                    },
                    child: const Text('Barbers Listing'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ClientBookings()),
                      );
                    },
                    child: const Text('Bookings'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Favourites()),
                      );
                    },
                    child: const Text('Favourites'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ClientProfile()),
                      );
                    },
                    child: const Text('Profile'),
                  ),
                ],
              ),
            ),
    );
  }
}
