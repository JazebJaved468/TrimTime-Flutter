import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/onBoardingScreens/loading_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  // Provider.of<AppProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trim Time'),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                color: CustomColors.gunmetal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No. of barbers available:',
                      style: TextStyle(
                          fontSize: 20, color: CustomColors.peelOrange),
                    ),
                    Text(
                      '${appProvider.activeBarbers}',
                      style: TextStyle(
                          fontSize: 36, color: CustomColors.peelOrange),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoadingScreen()),
          );
        },
        tooltip: 'Activate Barber',
        child: const Icon(Icons.person_add_alt_1_outlined),
      ),
    );
  }
}
