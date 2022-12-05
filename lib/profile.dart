import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lift/navigation_bar/bottom_navigation_bar.dart';
import 'package:lift/state_management/GalleryState.dart';
import 'package:lift/state_management/NavigationState.dart';
import 'package:lift/state_management/WorkoutState.dart';
import 'package:provider/provider.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class Profile extends StatelessWidget {
  late NavigationState _navigationState;

  @override
  Widget build(BuildContext context) {

    // Provider를 호출해 접근
    _navigationState = Provider.of<NavigationState>(context);
    GalleryState simpleGalleryState = Provider.of<GalleryState>(context);
    WorkoutState simpleWorkoutState = Provider.of<WorkoutState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: ProfileScreen(

        actions: [
          /// When signing out, need to clear out all the user data
          /// Currently signing out doesn't do that
          /// Gallery data and DataPage data are kept which is not good
          SignedOutAction((context) {
            GoogleSignIn().signOut();
            FirebaseAuth.instance.signOut();

            simpleGalleryState.resetGallery();
            simpleWorkoutState.resetAll();

            Navigator.of(context).popAndPushNamed('/login');
          }),
        ],
        // showMFATile: true,
      ),
    );
  }
}