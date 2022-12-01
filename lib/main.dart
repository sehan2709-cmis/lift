import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lift/state_management/CameraState.dart';
import 'package:lift/state_management/GalleryState.dart';
import 'package:lift/state_management/NavigationState.dart';
import 'package:lift/state_management/WorkoutState.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'state_management/ApplicationState.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  /// flutter pub run flutter_native_splash:create
  // to save splash screen detail
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  cameras = await availableCameras();
  User? user = FirebaseAuth.instance.currentUser;
  bool loggedIn = (user != null)?true:false;
  log("MAIN :: ${user!}");

  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (BuildContext context) => ApplicationState()),
          ChangeNotifierProvider(
              create: (BuildContext context) => NavigationState()),
          ChangeNotifierProvider(
              create: (BuildContext context) => WorkoutState()),
          ChangeNotifierProvider(
              create: (BuildContext context) => CameraState()),
          ChangeNotifierProvider(
              create: (BuildContext context) => GalleryState()),
        ],
        builder: ((context, child) => App(loggedIn:loggedIn)),
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