import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lift/state_management/NavigationState.dart';
import 'package:lift/state_management/WorkoutState.dart';
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
          ChangeNotifierProvider(
              create: (BuildContext context) => WorkoutState()),
        ],
        builder: ((context, child) => App()),
    )
  );
}

/**
 * Things to know...
 *
 * 1. camera plugin
 *    ios: The camera plugin compiles for any version of iOS, but its functionality requires iOS 10 or higher. If compiling for iOS 9, make sure to programmatically check the version of iOS running on the device before using any camera plugin features.
 *    android: Change the minimum Android sdk version to 21 (or higher)
 */