import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:water_tracker/signup.dart';
import 'package:water_tracker/welcome.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // This is needed to initialize Firebase in our app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const WaterTrackerApp());
}

class WaterTrackerApp extends StatelessWidget {
  const WaterTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loggedInUser = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      title: 'Water Tracker',
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        // Welcome page
        '/': (context) => const WelcomePage(),
        // Signup
        '/signup': (context) => const SignUpPage(),
      },
      // For testing, you can set this to be the page you are working on.
      // home: WelcomePage(),
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
