import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/barber_listing/barber_listing.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  TextEditingController searchFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SampleProvider sampleProvider =
        Provider.of<SampleProvider>(context, listen: false);
    sampleProvider.resetSearchedBarbers();
    return SafeArea(
      child: Scaffold(
          body: ColoredBox(
        color: CustomColors.gunmetal,
        child: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: (value) {
                  sampleProvider.updateSearchedBarbers(value);
                },
                controller: searchFieldController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle:
                      TextStyle(color: CustomColors.white.withOpacity(0.6)),
                  prefixIcon: Icon(Icons.search, color: CustomColors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: CustomColors.charcoal,
                  // focusedBorder: OutlineInputBorder(
                  //   borderSide:
                  //       BorderSide(color: Colors.white.withOpacity(0.1)),
                  //   borderRadius: BorderRadius.circular(10),
                  // ),
                  // enabledBorder: OutlineInputBorder(
                  //   // borderSide: const BorderSide(color: Color(0xffE4E7EB)),
                  //   borderRadius: BorderRadius.circular(15),
                  // ),
                ),
                style: TextStyle(color: CustomColors.white),
              ),
              Consumer<SampleProvider>(builder: (context, provider, child) {
                return Expanded(
                  child: searchFieldController.text.length == 0 &&
                          provider.searchedBarbers.isEmpty
                      ? Center(
                          child: Text(
                            'Your Search Results will appear here',
                            style: TextStyle(color: CustomColors.white),
                          ),
                        )
                      : searchFieldController.text.length != 0 &&
                              provider.searchedBarbers.isEmpty
                          ? Center(
                              child: Text(
                                'Sorry! No Barbers Found with this name',
                                style: TextStyle(color: CustomColors.white),
                              ),
                            )
                          : ListView.builder(
                              // shrinkWrap: true,
                              itemCount: provider.searchedBarbers.length,
                              itemBuilder: (context, index) {
                                var barber = provider.searchedBarbers[index];
                                return BarberCard(
                                  barberName: barber['name'],
                                  shopName: barber['shopName'],
                                  stars: barber['averageRating'],
                                  imageUrl: barber['photoURL'],
                                  barberId: barber['uid'],
                                );
                              }),
                );
              }),
            ],
          ),
        ),
      )),
    );
  }
}
