import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lift/state_management/NavigationState.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'state_management/ApplicationState.dart';


void main() {
  // runApp(const App());

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
   // ChangeNotifierProvider(
   //    create: (context) => ApplicationState(),
   //    // if App() is set to const, then ApplicationStete() init() is not passed on... why?
   //    builder: ((context, child) => App()),
   //  )

    MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (BuildContext context) => ApplicationState()),
          ChangeNotifierProvider(
              create: (BuildContext context) => NavigationState()),
        ],
        builder: ((context, child) => App()),
    )
  );
}