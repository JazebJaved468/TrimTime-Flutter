import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/components/CustomAppBar.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/barber_listing/barber_listing.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  TextEditingController searchFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.resetSearchedBarbers();
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Search Barbers',
        ),
        body: ColoredBox(
          color: CustomColors.gunmetal,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onChanged: (value) {
                    appProvider.updateSearchedBarbers(value);
                  },
                  controller: searchFieldController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    hintText: 'Search By Name...',
                    hintStyle: TextStyle(
                        color: CustomColors.white.withOpacity(0.6),
                        fontSize: 14),
                    prefixIcon:
                        const Icon(Icons.search, color: CustomColors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: CustomColors.charcoal,
                  ),
                  style: const TextStyle(color: CustomColors.white),
                ),
                Consumer<AppProvider>(builder: (context, provider, child) {
                  return Expanded(
                    child: searchFieldController.text.length == 0 &&
                            provider.searchedBarbers.isEmpty
                        ? const Center(
                            child: Text(
                              'Your Search Results will appear here',
                              style: TextStyle(color: CustomColors.white),
                            ),
                          )
                        : searchFieldController.text.length != 0 &&
                                provider.searchedBarbers.isEmpty
                            ? const Center(
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
        ));
  }
}
