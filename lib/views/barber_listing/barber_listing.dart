import 'package:flutter/material.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/views/barber_profile/barber_profile.dart';

class BarberListing extends StatefulWidget {
  @override
  _BarberListingState createState() => _BarberListingState();
}

class _BarberListingState extends State<BarberListing> {
  bool clicked = false;
  int selectedIndex = 0;

  final List<Map<String, String>> haircut = [
    {
      'barberName': 'Barbarella Inova',
      'shopName': 'Belle Curls',
      'stars': '4.5',
      'imageUrl': 'assets/images/1.jpg',
    },
    {
      'barberName': 'Choppers',
      'shopName': 'Bella Curls',
      'stars': '4.5',
      'imageUrl': 'assets/images/4.jpg',
    },
    {
      'barberName': 'Barbarella',
      'shopName': 'Belle Curls',
      'stars': '4.6',
      'imageUrl': 'assets/images/5.jpg',
    },
  ];

  final List<Map<String, String>> beardTrim = [
    {
      'barberName': 'Jane Smith',
      'shopName': 'Pretty Parlor',
      'stars': "4.3",
      'imageUrl': 'assets/images/3.jpg',
    },
  ];

  final List<Map<String, String>> hairColoring = [
    {
      'barberName': 'Jane Smith',
      'shopName': 'Pretty Parlor',
      'stars': "4.3",
      'imageUrl': 'assets/images/testpic.jpg',
    },
    {
      'barberName': 'Jane Smith',
      'shopName': 'Pretty Parlor',
      'stars': "4.3",
      'imageUrl': 'assets/images/testpic.jpg',
    },
  ];

  final List<Map<String, String>> faceTreatment = [
    {
      'barberName': 'Jane Smith',
      'shopName': 'Pretty Parlor',
      'stars': "4.3",
      'imageUrl': 'assets/images/testpic.jpg',
    },
    {
      'barberName': 'Jane Smith',
      'shopName': 'Pretty Parlor',
      'stars': "4.3",
      'imageUrl': 'assets/images/testpic.jpg',
    },
    {
      'barberName': 'Jane Smith',
      'shopName': 'Pretty Parlor',
      'stars': "4.3",
      'imageUrl': 'assets/images/testpic.jpg',
    },
  ];

  // Combine all the lists into one
  List<Map<String, String>> combineServices() {
    return []
      ..addAll(haircut)
      ..addAll(beardTrim)
      ..addAll(hairColoring)
      ..addAll(faceTreatment);
    //The cascade operator (..) allows you to perform a sequence of operations on the same object. In this case, it's used to add all the elements from the haircut, beardTrim, hairColoring, and faceTreatment lists to the empty list.
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> currentBookings;

    switch (selectedIndex) {
      case 1:
        currentBookings = haircut;
        break;
      case 2:
        currentBookings = beardTrim;
        break;
      case 3:
        currentBookings = hairColoring;
        break;
      case 4:
        currentBookings = faceTreatment;
        break;
      default:
        currentBookings = combineServices();
    }

    return Scaffold(
      backgroundColor: CustomColors.gunmetal,
      appBar: AppBar(
        backgroundColor: CustomColors.gunmetal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Barbers',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                      color: Colors.grey, fontFamily: 'Raleway'),
                  fillColor: CustomColors.charcoal,
                  filled: true,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  // suffixIcon: const Icon(
                  //   Icons.visibility_off_outlined,
                  // ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    // borderSide: const BorderSide(color: Color(0xffE4E7EB)),
                    borderRadius: BorderRadius.circular(15),
                  )),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildChoiceChip('All', 0),
                  const SizedBox(
                    width: 10,
                  ),
                  buildChoiceChip('Haircut', 1),
                  const SizedBox(
                    width: 10,
                  ),
                  buildChoiceChip('Beard Trim', 2),
                  const SizedBox(
                    width: 10,
                  ),
                  buildChoiceChip('Hair Coloring', 3),
                  const SizedBox(
                    width: 10,
                  ),
                  buildChoiceChip('Face Treatment', 4),
                ],
              ),
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
                  stars: booking['stars']!,
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
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        // width: 100,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
            fontFamily: 'Raleway',
          ),
        ),
      ),
    );
  }
}

class BookingCard extends StatefulWidget {
  final String barberName;
  final String shopName;
  final String stars;
  final String imageUrl;

  const BookingCard({
    required this.barberName,
    required this.shopName,
    required this.stars,
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BarberProfile()),
        );
      },
      child: Card(
        color: Colors.grey[900],
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  widget.imageUrl,
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
                          widget.barberName,
                          style: TextStyle(
                              color: CustomColors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (clicked) {
                              clicked = false;
                              setState(() {});
                            } else {
                              clicked = true;
                              setState(() {});
                            }
                          },
                          child: Icon(
                            clicked ? Icons.favorite : Icons.favorite_border,
                            color: clicked ? Colors.red : Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.shopName,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 180, 178, 178)),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.star_half_sharp,
                          color: CustomColors.peelOrange,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          widget.stars,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 180, 178, 178),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
