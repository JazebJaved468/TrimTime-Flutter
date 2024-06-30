import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/views/splashSreen/splash_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Trim Time',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Urbanist',
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}


// DONT REMOVE IT : IT IS FOR LATER USE
// StreamBuilder(
        //     stream: FirebaseAuth.instance.authStateChanges(),
        //     builder: (context, snapshot) {
        //       if (snapshot.hasError) {
        //         return ErrorPage(error: snapshot.error);
        //       }

        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return const Center(
        //           child: CircularProgressIndicator(),
        //         );
        //       }
        //       if (snapshot.hasData) {
        //         return ClientHomePage();
        //       }

        //       return const Signup();
        //     }),