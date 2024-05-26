import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      body: Center(
        child: Consumer<SampleProvider>(
          builder: (context, provider, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'No. of barbers available:',
              ),
              Text(
                '${sampleProvider.activeBarbers}',
              ),
              // Container(
              //   width: 200,
              //   height: 200,
              //   child: Image.asset(
              //     'assets/images/testpic.jpg',
              //     fit: BoxFit.cover,
              //   ),
              // ),
            ],
          ),
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
