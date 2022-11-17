import 'package:flutter/material.dart';
import 'package:lift/login.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'model/ApplicationState.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final simpleAppState = Provider.of<ApplicationState>(
      context,
      listen: false,
    );

    return MaterialApp(
        title: 'Lift',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: const HomePage(title: 'Lift'),

        initialRoute: '/login', // this one is selected
        routes: {
          '/': (context) => const HomePage(title: "HOME"),
          '/login': (context) => const LoginPage(),
        });
  }
}
