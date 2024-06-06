import 'package:flutter/material.dart';
import 'package:trim_time/controller/firestore.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/views/authentication/signup_page.dart';

class BarberListing extends StatefulWidget {
  const BarberListing({super.key});

  @override
  State<BarberListing> createState() => _BarberListingState();
}

class _BarberListingState extends State<BarberListing> {
  final isClient = true;

  bool _isLoading = true;

  _loadData() async {
    await getBarberListingFromFireStore();

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
