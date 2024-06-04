import 'package:flutter/material.dart';
import 'package:trim_time/colors/custom_colors.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int selectedIndex = 0;

  final List<Map<String, String>> upcomingBookings = [
    {
      'barberName': 'Rajja Farhan',
      'shopName': 'Belle Curls',
      'dateTime': 'Mon, 14 Jun 2023, 2:00 PM',
      'price': '\$30',
      'bookingId': '12345',
      'imageUrl': 'assets/images/testpic.jpg', 
    },
    {
      'barberName': 'John Loww',
      'shopName': 'Belle Curls',
      'dateTime': 'Mon, 14 Jun 2023, 2:00 PM',
      'price': '\$30',
      'bookingId': '12345',
      'imageUrl': 'assets/images/testpic.jpg', 
    },
    {
      'barberName': 'John Poee',
      'shopName': 'Belle Curls',
      'dateTime': 'Mon, 14 Jun 2023, 2:00 PM',
      'price': '\$30',
      'bookingId': '12345',
      'imageUrl': 'assets/images/testpic.jpg',
    },
  ];

  final List<Map<String, String>> cancelledBookings = [
    {
      'barberName': 'Jane Smith',
      'shopName': 'Pretty Parlor',
      'dateTime': 'Tue, 15 Jun 2023, 4:00 PM',
      'price': '\$40',
      'bookingId': '67890',
      'imageUrl': 'assets/images/testpic.jpg', 
    },
  ];

  final List<Map<String, String>> completedBookings = [
    {
      'barberName': 'Mike Johnson',
      'shopName': 'Serenity Salon',
      'dateTime': 'Wed, 16 Jun 2023, 10:00 AM',
      'price': '\$50',
      'bookingId': '11223',
      'imageUrl': 'assets/images/testpic.jpg', 
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> currentBookings;

    switch (selectedIndex) {
      case 1:
        currentBookings = cancelledBookings;
        break;
      case 2:
        currentBookings = completedBookings;
        break;
      default:
        currentBookings = upcomingBookings;
    }

    return Scaffold(
      backgroundColor: CustomColors.gunmetal,
      appBar: AppBar(
        backgroundColor: CustomColors.gunmetal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'My Bookings',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildChoiceChip('Upcoming', 0),
                buildChoiceChip('Cancelled', 1),
                buildChoiceChip('Completed', 2),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: currentBookings.length,
              itemBuilder: (context, index) {
                final booking = currentBookings[index];
                return BookingCard(
                  barberName: booking['barberName']!,
                  shopName: booking['shopName']!,
                  dateTime: booking['dateTime']!,
                  price: booking['price']!,
                  bookingId: booking['bookingId']!,
                  imageUrl: booking['imageUrl']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChoiceChip(String label, int index) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? CustomColors.peelOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: CustomColors.peelOrange,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : CustomColors.peelOrange,
          ),
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final String barberName;
  final String shopName;
  final String dateTime;
  final String price;
  final String bookingId;
  final String imageUrl;

  const BookingCard({
    required this.barberName,
    required this.shopName,
    required this.dateTime,
    required this.price,
    required this.bookingId,
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        barberName,
                        style: TextStyle(color: CustomColors.peelOrange, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        price,
                        style: TextStyle(color: CustomColors.peelOrange, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    shopName,
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dateTime,
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Booking ID: $bookingId',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}