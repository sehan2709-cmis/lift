import 'dart:developer';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lift/state_management/ApplicationState.dart';
import 'package:lift/state_management/GalleryState.dart';
import 'package:lift/state_management/WorkoutState.dart';
import 'package:provider/provider.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final colorizeColors = [
    Colors.black,
    Colors.black45,
    Colors.black12,
    Colors.grey,
    // Colors.purple,
    // Colors.blue,
    // Colors.yellow,
    // Colors.red,
  ];

  final colorizeTextStyle = TextStyle(
    fontSize: 100.0,
    fontFamily: 'Monoton',
  );

  @override
  Widget build(BuildContext context) {
    final simpleAppState =
        Provider.of<ApplicationState>(context, listen: false);
    final simpleGalleryState = Provider.of<GalleryState>(
      context,
      listen: false,
    );

    return Scaffold(
      // appBar: AppBar(
      //   title: Text("LOGIN"),
      // ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    'LIFT',
                    textStyle: colorizeTextStyle,
                    colors: colorizeColors,
                    speed: Duration(seconds: 3),
                  ),
                ],
                pause: Duration(seconds: 3),
                stopPauseOnTap: true,
                isRepeatingAnimation: true,
                onTap: () {
                  // Tap event
                },
              ),
              ElevatedButton(
                child: Text("Google Login"),
                onPressed: () async {
                  final login_sucess = signInWithGoogle();
                  /// create user document if it is first login
                  /// Question, doing this kind of operation on client side is not very good
                  /// since any hacker can get the API link can abuse it (??? not sure)
                  if (await login_sucess) {
                    if(await checkFirstLogin()){
                      createUserDoc();
                    }
                    /// when login for the first time, download gallery data
                    simpleGalleryState.readGallery();
                    Navigator.of(context).pop();
                  }
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  final login_sucess = anonymousSignIn();
                  if (await login_sucess) {
                    if(await checkFirstLogin()){
                      createUserDoc();
                    }
                    Navigator.of(context).pop();
                  }
                },
                child: Text("Anonymous Login"),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
    // floatingActionButton: // floating button widget
  }

  Future<bool> anonymousSignIn() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      log("Signed in ANONYMOUS: ${userCredential.toString()}");
      return true;

      // if (!mounted) return;
      // Navigator.of(context).pop();

    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          log("Anonymous auth hasn't been enabled for this project.");
          return false;
          break;
        default:
          log("Unknown error.");
          return false;
      }
    }
  }

  Future<bool> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);

    log("Signed in GOOGLE: ${credential.toString()}");
    return true;

    // if (!mounted) return;
    // Navigator.of(context).pop();
  }

  Future<bool> checkFirstLogin() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final doc = await FirebaseFirestore.instance.collection("User").doc(uid).get();
    if(doc.exists){
      log("LOGIN :: User already exists");
      return false;
    }
    else {
      log("LOGIN :: User is first time");
      return true;
    }
  }

  Future<void> createUserDoc() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userRef = FirebaseFirestore.instance.collection("User").doc(uid);
    // set "firstLoginTime" as current server time
    userRef.set({"firstLoginTime":FieldValue.serverTimestamp()});
  }

}
