import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      appBar: AppBar(
        title: const Text('Favourite Screen'),
      ),
      body: Consumer<SampleProvider>(
        builder: (context, provider, child) {
          print('length ---- ${provider.inAppfavouriteList}');
          return sampleProvider.inAppfavouriteList.isEmpty
              ? const Center(
                  child: Text('No Favourite Barbers'),
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
    );
  }
}
