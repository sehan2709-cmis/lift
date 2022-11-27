import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lift/login.dart';
import 'package:lift/ranking.dart';
import 'package:lift/state_management/WorkoutState.dart';
import 'package:lift/profile.dart';
import 'package:lift/workout.dart';
import 'package:provider/provider.dart';
import 'data.dart';
import 'home.dart';
import 'state_management/ApplicationState.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final simpleAppState = Provider.of<ApplicationState>(
      context,
      listen: false,
    );

    final a = Provider.of<WorkoutState>(
      context,
      listen: false,
    );

    return MaterialApp(
        title: 'Lift',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: const HomePage(title: 'Lift'),

        // (FirebaseAuth.instance.currentUser == null)?'/login':'/'
        initialRoute: '/login',
        routes: {
          '/': (context) => const HomePage(title: "HOME"),
          '/login': (context) => const LoginPage(),
          '/profile': (context) => Profile(),
          '/datapage': (context) => DataPage(),
          '/ranking': (context) => Ranking(),
          '/workout': (context) => Workout(),
          // '/ranking': (context) => const RankingPage(),
        });
  }
}
