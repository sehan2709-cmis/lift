import 'dart:developer';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lift/state_management/ApplicationState.dart';
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
                  if (await login_sucess) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  final login_sucess = anonymousSignIn();
                  if (await login_sucess) {
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
}
