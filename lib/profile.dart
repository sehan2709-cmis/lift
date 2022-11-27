import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lift/state_management/NavigationState.dart';
import 'package:provider/provider.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class Profile extends StatelessWidget {
  late NavigationState _navigationState;

  @override
  Widget build(BuildContext context) {

    // Provider를 호출해 접근
    _navigationState = Provider.of<NavigationState>(context);

    return ProfileScreen(
      actions: [
        SignedOutAction((context) {
          Navigator.of(context).popAndPushNamed('/login');
        }),
      ],
      showMFATile: true,
    );
  }
}