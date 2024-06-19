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
import 'package:trim_time/views/searchPage/search_page.dart';
import '../../views/homescreenclient/homecontent.dart';
import 'package:trim_time/colors/custom_colors.dart';

class NavigationExample extends StatefulWidget {
  const NavigationExample({Key? key}) : super(key: key);

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  final isClient = true;

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
            selectedIcon:
                const Icon(Icons.home, color: CustomColors.peelOrange),
            icon: const Icon(Icons.home_outlined, color: Colors.white),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon:
                const Icon(Icons.content_cut, color: CustomColors.peelOrange),
            icon: const Icon(Icons.content_cut, color: Colors.white),
            label: 'Barber',
          ),
          NavigationDestination(
            selectedIcon:
                const Icon(Icons.book, color: CustomColors.peelOrange),
            icon: const Icon(Icons.book_outlined, color: Colors.white),
            label: 'My Booking',
          ),
          NavigationDestination(
            selectedIcon:
                const Icon(Icons.favorite, color: CustomColors.peelOrange),
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            label: 'Favorites',
          ),
          NavigationDestination(
            selectedIcon:
                Icon(Icons.search_rounded, color: CustomColors.peelOrange),
            icon: Icon(Icons.search_rounded, color: Colors.white),
            label: 'Search',
          ),
        ],
      ),
      body: [
        HomeContent(),
        const BarberListing(),
        BookingScreen(),
        const FavouriteScreen(),
        SearchPage(),
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
    super.key,
    required this.type,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.backgroundColor,
    this.indicatorColor,
    required this.destinations,
  });

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
