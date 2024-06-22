import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/components/CustomAppBar.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/barber_listing/barber_listing.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    SampleProvider sampleProvider =
        Provider.of<SampleProvider>(context, listen: false);

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'Favourite Screen',
      //     style: TextStyle(color: CustomColors.white),
      //   ),
      //   backgroundColor: CustomColors.gunmetal,
      //   elevation: 0,
      // ),
      appBar: CustomAppBar(
        title: 'Your Favourite Barbers',
      ),
      body: Container(
        color: CustomColors.gunmetal,
        child: Consumer<SampleProvider>(
          builder: (context, provider, child) {
            return sampleProvider.inAppfavouriteList.isEmpty
                ? const Center(
                    child: Text(
                      'You have not Favorited any Barber yet.',
                      style: TextStyle(color: CustomColors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: provider.inAppfavouriteList.length,
                    itemBuilder: (context, index) {
                      final barber = provider.inAppfavouriteList[index];
                      return BarberCard(
                        barberId: barber['uid'],
                        barberName: barber['name'],
                        shopName: barber['shopName'],
                        stars: '5',
                        imageUrl: barber['photoURL'],
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
