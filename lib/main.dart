import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/views/appointment_summary/appointment_summary.dart';
import 'package:trim_time/views/barber_listing/barber_listing.dart';
import 'package:trim_time/views/barber_profile/barber_profile.dart';
import 'package:trim_time/views/reviewsAndRating/reviews.dart';
import 'firebase/config/firebase_options.dart';
import 'providers/sample_provider.dart';
import 'views/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        // home: BarberProfile(),
        // home: BarberListing(),
        // home: AppointmentSummary(),
        home: ReviewsAndRating(),

        debugShowCheckedModeBanner: false,
        //        routes: {
        //   '/barberProfile': (context) => BarberProfile(),
        // },
      ),
    );
  }
}
