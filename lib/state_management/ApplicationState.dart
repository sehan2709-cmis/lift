import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  // User class is in firebase_auth package
  User? _user;
  User? get user => _user;

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        log('User is currently signed out!');
      } else {
        log('User is signed in!');
        log('     --> ${user.uid}');
      }
      notifyListeners();
    });
  }
}
