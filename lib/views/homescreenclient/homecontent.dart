import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/controller/local_storage.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/barber_listing/barber_listing.dart';
import 'package:trim_time/views/sign_in.dart';

class HomeContent extends StatefulWidget {
  HomeContent({Key? key}) : super(key: key);
  // final List<Map<String, dynamic>> allBarbers;
  // final List<Map<String, dynamic>> allBookings;

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  // late Map<String, dynamic> localData;

  final isClient = true;

  bool _isLoading = false;

  // _loadData() async {
  //   localData = await getDataFromLocalStorage();

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _loadData();
  }

  @override
  Widget build(BuildContext context) {
    SampleProvider sampleProvider =
        Provider.of<SampleProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Trim Time',
            style: TextStyle(color: CustomColors.white),
          ),
          backgroundColor: CustomColors.gunmetal,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () async {
                await sampleProvider.handleLogoutByProvider();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => SignIn()),
                    (Route route) => false);
              },
              icon: const Icon(
                Icons.logout,
                color: CustomColors.white,
              ),
            ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: SpinKitFadingCircle(
                color: CustomColors.peelOrange,
                size: 50.0,
              ))
            : Container(
                color: CustomColors.gunmetal,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<SampleProvider>(
                        builder: (context, provider, child) {
                          print('----------------------in home screen');
                          print(
                              '----------------------local data in provider in  home screen ${sampleProvider.localDataInProvider}');
                          return Text(
                            'Hello, ${provider.localDataInProvider['userData']['name']} 👋',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.white,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(
                              color: CustomColors.white.withOpacity(0.6)),
                          prefixIcon:
                              Icon(Icons.search, color: CustomColors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: CustomColors.charcoal,
                        ),
                        style: TextStyle(color: CustomColors.white),
                      ),
                      const SizedBox(height: 16),
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 150.0,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                        ),
                        items: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: CustomColors.peelOrange,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '30% OFF\nToday\'s Special',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Get a discount for every service order!\nOnly valid for today!',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: CustomColors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: CustomColors.peelOrange,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Special Offer!',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Enjoy exclusive discounts and deals!',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: CustomColors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          // Add more slides as needed
                        ],
                      ),
                      const SizedBox(height: 16),
                      const CategorySection(),
                      const SizedBox(height: 16),
                      const LocationSection(title: 'Most Popular'),
                    ],
                  ),
                ),
              ));
  }
}

class CategorySection extends StatelessWidget {
  const CategorySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CustomColors.white,
              ),
            ),
            Text(
              'See All',
              style: TextStyle(
                color: CustomColors.peelOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CategoryChip(label: 'Haircuts', icon: Icons.content_cut),
            CategoryChip(label: 'Make up', icon: Icons.brush),
            CategoryChip(label: 'Manicure', icon: Icons.handyman),
            CategoryChip(label: 'Massage', icon: Icons.spa),
          ],
        ),
      ],
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const CategoryChip({required this.label, required this.icon, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Color.fromRGBO(51, 41, 28, 1),
          child: Icon(icon, color: CustomColors.peelOrange),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: CustomColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class LocationSection extends StatelessWidget {
  final String title;

  const LocationSection({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SampleProvider sampleProvider =
        Provider.of<SampleProvider>(context, listen: false);
    // return Consumer<SampleProvider>(builder: (context, provider, child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: sampleProvider.popularBarbers.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return BarberCard(
                barberName: sampleProvider.popularBarbers[index]['name'],
                shopName: sampleProvider.popularBarbers[index]['shopName'],
                stars: sampleProvider.popularBarbers[index]['averageRating'],
                imageUrl: sampleProvider.popularBarbers[index]['photoURL'],
                barberId: sampleProvider.popularBarbers[index]['uid']);

            // Text(
            //   sampleProvider.popularBarbers[index]['name'],
            //   style: TextStyle(color: CustomColors.white),
            // );
          },
        )
      ],
    );

    // });
    ListView.builder(
      shrinkWrap: true,
      itemCount: sampleProvider.popularBarbers.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Text(
          sampleProvider.popularBarbers[index]['name'],
          style: TextStyle(color: CustomColors.white),
        );

        //  BarberCard(
        //     barberName: 'barberName',
        //     shopName: 'shopName',
        //     stars: 'stars',
        //     imageUrl:
        //         'https://www.google.com/url?sa=i&url=https%3A%2F%2Fpixlr.com%2Fimage-generator%2F&psig=AOvVaw1OcskarNNDOdfLJbvDRRhB&ust=1718831879725000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCNiH3u6J5oYDFQAAAAAdAAAAABAE',
        //     barberId: 'barberId');
      },
    );
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Text(
    //           title,
    //           style: const TextStyle(
    //             fontSize: 18,
    //             fontWeight: FontWeight.bold,
    //             color: Colors.white,
    //           ),
    //         ),
    //         const Text(
    //           'See All',
    //           style: TextStyle(
    //             color: Colors.orange,
    //           ),
    //         ),
    //       ],
    //     ),
    //     const SizedBox(height: 8),
    //     const Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         LocationCard(
    //           title: 'Belle Curls',
    //           address: '0996 Novick Parkway',
    //           rating: '4.8',
    //         ),
    //         LocationCard(
    //           title: 'Pretty Parlor',
    //           address: '42 Fardom Avenue',
    //           rating: '4.9',
    //         ),
    //         LocationCard(
    //           title: 'Mia Bella',
    //           address: '87 Superior Trail',
    //           rating: '4.7',
    //         ),
    //         LocationCard(
    //           title: 'Hair Force',
    //           address: '80 Village Drive',
    //           rating: '4.6',
    //         ),
    //         LocationCard(
    //           title: 'Serenity Salon',
    //           address: '88 Commercial Place',
    //           rating: '4.8',
    //         ),
    //         LocationCard(
    //           title: 'The Razor\'s Edge',
    //           address: '56 Artisan Avenue',
    //           rating: '4.6',
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }
}

class LocationCard extends StatefulWidget {
  final String title;
  final String address;
  final String rating;

  const LocationCard({
    required this.title,
    required this.address,
    required this.rating,
    Key? key,
  }) : super(key: key);

  @override
  _LocationCardState createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: CustomColors.charcoal,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: Image.asset(
                'assets/images/testpic.jpg',
                width: 60.0,
                height: 75.0,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              widget.title,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.address,
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    Text(
                      widget.rating,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: isBookmarked ? Colors.orange : Colors.white,
              ),
              onPressed: () {
                setState(() {
                  isBookmarked = !isBookmarked;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
