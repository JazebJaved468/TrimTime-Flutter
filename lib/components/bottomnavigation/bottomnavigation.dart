import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/controller/firestore.dart';
import 'package:trim_time/controller/local_storage.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/barber_listing/barber_listing.dart';
import 'package:trim_time/views/bookings/booking.dart';
import 'package:trim_time/views/clientScreens/registration_client.dart';
import 'package:trim_time/views/favouriteScreen/favourite_screen.dart';
import '../../views/homescreenclient/homecontent.dart';
import 'package:trim_time/colors/custom_colors.dart';

class NavigationExample extends StatefulWidget {
  const NavigationExample({Key? key}) : super(key: key);

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  late List<Map<String, dynamic>> allBarbers;
  late List<Map<String, dynamic>> allBookings;
  late Map<String, dynamic> localData;

  final isClient = true;

  bool _isLoading = true;

  _loadData() async {
    localData = await getDataFromLocalStorage();
    allBarbers = await getAllBarbersFromFireStore();
    allBookings = await getAllBookingsFromFireStore(clientId: localData['uid']);

    print('localData in ----> $localData');

    // print('BArber Listing: ${barbers}');

    // currentListing = allBarbers;

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
    SampleProvider sampleProvider =
        Provider.of<SampleProvider>(context, listen: false);

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        type: BottomNavigationBarType
            .fixed, // Ensure no background circle for selected icon
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: CustomColors.gunmetal,
        indicatorColor: Colors.amber, // Not necessary since type is fixed
        selectedIndex: currentPageIndex,
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: CustomColors.peelOrange),
            icon: Icon(Icons.home_outlined, color: Colors.white),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon:
                Icon(Icons.content_cut, color: CustomColors.peelOrange),
            icon: Icon(Icons.content_cut, color: Colors.white),
            label: 'Barber',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.favorite, color: CustomColors.peelOrange),
            icon: Icon(Icons.favorite_border, color: Colors.white),
            label: 'Favorites',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.book, color: CustomColors.peelOrange),
            icon: Icon(Icons.book_outlined, color: Colors.white),
            label: 'My Booking',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person, color: CustomColors.peelOrange),
            icon: Icon(Icons.person_outline, color: Colors.white),
            label: 'Profile',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: const SpinKitFadingCircle(
              color: CustomColors.peelOrange,
              size: 50.0,
            ))
          : [
              /// Home page
              HomeContent(
                allBarbers: allBarbers,
                allBookings: allBookings,
              ), // Call the HomeContent widget here

              /// Barber page (Placeholder)
              BarberListing(
                allBarbers: allBarbers,
              ),

              FavouriteScreen(),

              /// Favorite page (Placeholder)
              // const Center(
              //   child: Text(
              //     'Favorite Page',
              //     style: TextStyle(
              //         fontSize: 24,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.white),
              //   ),
              // ),

              BookingScreen(),

              /// My Booking page (Placeholder)
              // const Center(
              //   child: Text(
              //     'My Booking Page',
              //     style: TextStyle(
              //         fontSize: 24,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.white),
              //   ),
              // ),

              ClientRegistrationPage(
                photoURL: localData['userData']['photoURL'],
                fullName: localData['userData']['name'],
                email: localData['userData']['email'],
                phoneNumber: localData['userData']['phoneNumber'],
                gender: localData['userData']['gender'],
                shouldNavigate: false,
              ),

              /// Profile page (Placeholder)
              // const Center(
              //   child: Text(
              //     'Profile Page',
              //     style: TextStyle(
              //         fontSize: 24,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.white),
              //   ),
              // ),
            ][currentPageIndex],
    );
  }
}

class NavigationBar extends StatelessWidget {
  final BottomNavigationBarType type;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Color backgroundColor;
  final Color? indicatorColor;
  final List<NavigationDestination> destinations;

  const NavigationBar({
    Key? key,
    required this.type,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.backgroundColor,
    this.indicatorColor,
    required this.destinations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: type,
      currentIndex: selectedIndex,
      onTap: onDestinationSelected,
      backgroundColor: backgroundColor,
      selectedItemColor: CustomColors.peelOrange,
      unselectedItemColor: Colors.white,
      items: destinations
          .map((destination) => BottomNavigationBarItem(
                icon: destination.icon,
                activeIcon: destination.selectedIcon,
                label: destination.label,
              ))
          .toList(),
    );
  }
}

class NavigationDestination {
  final Icon icon;
  final Icon selectedIcon;
  final String label;

  NavigationDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
