import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/views/onBoardingScreens/get_started_screen.dart';
import 'package:trim_time/views/onBoardingScreens/loading_screen.dart';
import 'package:trim_time/views/onBoardingScreens/welcome_screen.dart';

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
        home: Home(),
        debugShowCheckedModeBanner: false,

      ),
    );
  }
}
