import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/providers/sample_provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final sampleProvider = Provider.of<SampleProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trim Time'),
      ),
      body: Consumer<SampleProvider>(
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
                      '${sampleProvider.activeBarbers}',
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
          sampleProvider.incrementActiveBarbers();
        },
        tooltip: 'Activate Barber',
        child: const Icon(Icons.person_add_alt_1_outlined),
      ),
    );
  }
}
