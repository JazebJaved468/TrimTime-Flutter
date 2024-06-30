import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/components/CustomAppBar.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/utilities/helpers/functions.dart';
import 'package:trim_time/views/barber_profile/barber_profile.dart';

class BarberListing extends StatefulWidget {
  const BarberListing({super.key});

  // final List<Map<String, dynamic>> allBarbers;

  @override
  State<BarberListing> createState() => _BarberListingState();
}

class _BarberListingState extends State<BarberListing> {
  final isClient = true;
  int selectedIndex = 0;

  late List currentListing;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    switch (selectedIndex) {
      case 1:
        currentListing = appProvider.haircutFilterBarbers;
        break;
      case 2:
        currentListing = appProvider.shaveFilterBarbers;
        break;
      case 3:
        currentListing = appProvider.beardTrimFilterBarbers;
        break;
      case 4:
        currentListing = appProvider.massageFilterBarbers;
        break;
      default:
        currentListing = appProvider.allBarbers;
    }

    return Scaffold(
      backgroundColor: CustomColors.gunmetal,
      appBar: CustomAppBar(
        title: 'Barbers',
      ),
      body: Column(
        children: [
          // Container(
          //   padding: const EdgeInsets.all(5),
          //   margin: const EdgeInsets.symmetric(horizontal: 10),
          //   child: TextFormField(
          //     style: const TextStyle(color: Colors.white),
          //     decoration: InputDecoration(
          //         hintText: 'Search',
          //         hintStyle: const TextStyle(
          //             color: Colors.grey, fontFamily: 'Raleway'),
          //         fillColor: CustomColors.charcoal,
          //         filled: true,
          //         prefixIcon: const Icon(
          //           Icons.search,
          //           color: Colors.grey,
          //         ),
          //         // suffixIcon: const Icon(
          //         //   Icons.visibility_off_outlined,
          //         // ),
          //         focusedBorder: OutlineInputBorder(
          //           borderSide: const BorderSide(color: Colors.white),
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         enabledBorder: OutlineInputBorder(
          //           // borderSide: const BorderSide(color: Color(0xffE4E7EB)),
          //           borderRadius: BorderRadius.circular(15),
          //         )),
          //   ),
          // ),
          // const SizedBox(height: 5),
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
                  buildChoiceChip('Shave', 2),
                  const SizedBox(
                    width: 10,
                  ),
                  buildChoiceChip('Beard Trim', 3),
                  const SizedBox(
                    width: 10,
                  ),
                  buildChoiceChip('Massage', 4),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              // color: Colors.pink,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                itemCount: currentListing.length,
                itemBuilder: (context, index) {
                  final barber = currentListing[index];

                  return BarberCard(
                    barberId: barber['uid'],
                    barberName: barber['name'],
                    shopName: barber['shopName'],
                    stars: barber['averageRating'],
                    imageUrl: barber['photoURL'],
                    // isFavourite: barber['isFavourite'],
                  );
                },
              ),
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
            // fontFamily: 'Raleway',
          ),
        ),
      ),
    );
  }
}

class BarberCard extends StatefulWidget {
  final String barberName;
  final String shopName;
  final String stars;
  final String imageUrl;
  final String barberId;
  // final bool isFavourite;

  const BarberCard({
    required this.barberName,
    required this.shopName,
    required this.stars,
    required this.imageUrl,
    Key? key,
    // required this.isFavourite,
    required this.barberId,
  }) : super(key: key);

  @override
  State<BarberCard> createState() => _BarberCardState();
}

class _BarberCardState extends State<BarberCard> {
  late bool isFavourite;

  @override
  void initState() {
    super.initState();
    // isFavourite = widget.isFavourite;
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        appProvider.setSelectedBarber(widget.barberId);
        appProvider.resetSelectedSlot();
        print('Selected Barber: ${appProvider.selectedBarber}}');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BarberProfile()),
        );
      },
      child: Card(
        color: Colors.grey[900],
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
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
                          '${capitalizeFirstLetterOfEachWord(widget.barberName)}',
                          style: TextStyle(
                              color: CustomColors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Consumer<AppProvider>(
                            builder: (context, provider, Widget? child) {
                          isFavourite = appProvider.allBarbers.firstWhere(
                              (element) =>
                                  element['uid'] ==
                                  widget.barberId)['isFavourite'];
                          return GestureDetector(
                            onTap: () async {
                              if (isFavourite) {
                                print('remove fav');
                                appProvider.removeBarberFromFavourites(
                                    widget.barberId);
                              } else {
                                print('add fav');
                                appProvider
                                    .addBarberToFavourites(widget.barberId);
                              }
                            },
                            child: Icon(
                              isFavourite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavourite ? Colors.red : Colors.white,
                            ),
                          );
                        }),
                        // GestureDetector(
                        //   onTap: () {
                        //     if (isFavourite) {
                        //       print('remove fav');
                        //       appProvider
                        //           .removeBarberFromFavourites(widget.barberId);
                        //       isFavourite = false;
                        //       setState(() {});
                        //     } else {
                        //       isFavourite = true;
                        //       setState(() {});
                        //     }
                        //   },
                        //   child: Icon(
                        //     isFavourite
                        //         ? Icons.favorite
                        //         : Icons.favorite_border,
                        //     color: isFavourite ? Colors.red : Colors.white,
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${capitalizeFirstLetterOfEachWord(widget.shopName)}',
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
