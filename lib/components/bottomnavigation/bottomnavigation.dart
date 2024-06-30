import 'package:flutter/material.dart';
import 'package:trim_time/views/barber_listing/barber_listing.dart';
import 'package:trim_time/views/bookings/booking.dart';
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

  List destinations = [
    NavigationDestination(
      selectedIcon: Container(
          margin: const EdgeInsets.only(bottom: 2),
          child:
              const Icon(Icons.home_rounded, color: CustomColors.peelOrange)),
      icon: Container(
          margin: const EdgeInsets.only(bottom: 2),
          child: const Icon(Icons.home_rounded, color: Colors.white)),
      label: 'Home',
    ),
    NavigationDestination(
      selectedIcon: Container(
          margin: const EdgeInsets.only(bottom: 2),
          child: const Icon(Icons.content_cut_rounded,
              color: CustomColors.peelOrange)),
      icon: Container(
          margin: const EdgeInsets.only(bottom: 2),
          child: const Icon(Icons.content_cut_rounded, color: Colors.white)),
      label: 'Barbers',
    ),
    NavigationDestination(
      selectedIcon: Container(
          margin: const EdgeInsets.only(bottom: 2),
          child:
              const Icon(Icons.book_rounded, color: CustomColors.peelOrange)),
      icon: Container(
          margin: const EdgeInsets.only(bottom: 2),
          child: const Icon(Icons.book_rounded, color: Colors.white)),
      label: 'My Bookings',
    ),
    NavigationDestination(
      selectedIcon: Container(
          margin: const EdgeInsets.only(bottom: 2),
          child: const Icon(Icons.favorite_rounded,
              color: CustomColors.peelOrange)),
      icon: Container(
          margin: const EdgeInsets.only(bottom: 2),
          child: const Icon(Icons.favorite_rounded, color: Colors.white)),
      label: 'Favorites',
    ),
    NavigationDestination(
      selectedIcon: Container(
        margin: const EdgeInsets.only(bottom: 2),
        child: const Icon(
          Icons.person_search_rounded,
          color: CustomColors.peelOrange,
        ),
      ),
      icon: Container(
          margin: const EdgeInsets.only(bottom: 2),
          child: const Icon(Icons.person_search_rounded, color: Colors.white)),
      label: 'Search',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: CustomColors.transparent,
          highlightColor: CustomColors.transparent,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType
              .fixed, // Ensure no background circle for selected icon

          currentIndex: currentPageIndex,
          onTap: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          backgroundColor: CustomColors.gunmetal,
          selectedItemColor: CustomColors.peelOrange,
          iconSize: 22,

          unselectedItemColor: Colors.white,

          unselectedLabelStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w300,
          ),
          selectedLabelStyle:
              const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          items: destinations
              .map((destination) => BottomNavigationBarItem(
                    icon: destination.icon,
                    activeIcon: destination.selectedIcon,
                    label: destination.label,
                  ))
              .toList(),
        ),
      ),

      /// undo from here

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
 
class NavigationDestination {
  final Widget icon;
  final Widget selectedIcon;
  final String label;

  NavigationDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
