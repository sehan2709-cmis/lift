import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lift/state_management/CameraState.dart';
import 'package:lift/state_management/DataState.dart';
import 'package:lift/state_management/GalleryState.dart';
import 'package:lift/state_management/NavigationState.dart';
import 'package:lift/state_management/WorkoutState.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'state_management/ApplicationState.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

List<CameraDescription> cameras = [];

Future<void> checkUserStreakState(User user) async {
  try{
    String uid = user!.uid;
    DocumentReference<Map<String, dynamic>> userDocRef = FirebaseFirestore.instance.collection("User").doc(uid);
    DocumentSnapshot<Map<String, dynamic>> doc = await userDocRef.get();
    Timestamp last_wd_ts = doc.data()!["lastWorkout"];
    DateTime last_wd = last_wd_ts.toDate();
    last_wd = DateTime(last_wd.year, last_wd.month, last_wd.day);
    DateTime last_login = user.metadata.lastSignInTime!;
    last_login = DateTime(last_login.year, last_login.month, last_login.day);
    log("Seems like there is a record of workout in the past: \n" +
        "  lastLogin   = ${last_login.toString()}\n" +
        "  lastWorkout = ${last_wd.toString()}\n" +
        "-------------------\n" +
        " difference = ${last_wd.difference(last_login).inDays}");
    if(last_wd.difference(last_login).inDays > 1) {
      // this means to reset streak
      log("Since there is too much difference, will reset user streak");
      await userDocRef.set(
        {"streak": 0},
        SetOptions(merge: true),
      );
    }
  }catch(e){
    log("No lastworkout to compare");
  }
}

Future<void> main() async {
  /// flutter pub run flutter_native_splash:create
  // to save splash screen detail
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  cameras = await availableCameras();
  /// camera 킬때 오류 생긴다
  User? user = FirebaseAuth.instance.currentUser;
  bool loggedIn = (user != null)?true:false;

  log("------------ INITIALIZATION ------------");
  log("MAIN :: ${user} and loggedIn is $loggedIn");

  /// if user is logged in check for streak reset
  if(user != null) {
    await checkUserStreakState(user);
  }

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
          ChangeNotifierProvider(
              create: (BuildContext context) => DataState()),
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