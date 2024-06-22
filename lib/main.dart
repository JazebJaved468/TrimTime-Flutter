import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/views/appointment_summary/appointment_summary.dart';
import 'firebase/config/firebase_options.dart';
import 'providers/sample_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51NU517SBDQj9WtJX7yxeO2MqYiArmodGVKMQa1nzapCsMIEBNHYs1p1b4Abg9PNcSWXtRjQw34HEHKlFqRHOUu9Z00ePV0zZEO";
  await Stripe.instance.applySettings();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Add providers here
        ChangeNotifierProvider(
          create: (_) => SampleProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Trim Time',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: AppointmentSummary(),

        debugShowCheckedModeBanner: false,
        //        routes: {
        //   '/barberProfile': (context) => BarberProfile(),
        // },
      ),
    );
  }
}
