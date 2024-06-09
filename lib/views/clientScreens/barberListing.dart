import 'package:flutter/material.dart';
import 'package:trim_time/controller/firestore.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/views/sign_in.dart';

// remove this file

class BarberListing extends StatefulWidget {
  const BarberListing({super.key});

  @override
  State<BarberListing> createState() => _BarberListingState();
}

class _BarberListingState extends State<BarberListing> {
  final isClient = true;

  bool _isLoading = true;

  _loadData() async {
    await getAllBarbersFromFireStore();

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barber Listing'),
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
          : Text('Barber Listing'),

      //  ListView.builder(
      //     itemCount: localData.length,
      //     itemBuilder: (context, index) {
      //       return ListTile(
      //         title: Text(localData[index]['name']),
      //         subtitle: Text(localData[index]['address']),
      //         trailing: Text(localData[index]['rating']),
      //       );
      //     },
      //   ),
    );
  }
}
