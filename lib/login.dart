import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lift/state_management/ApplicationState.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final simpleAppState = Provider.of<ApplicationState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () async {
                final login_sucess = signInWithGoogle();
                if(await login_sucess){
                  Navigator.of(context).pop();
                }
              },
              child: Text("Google Login"),
            ),
            ElevatedButton(
              onPressed: () async {
                final login_sucess = anonymousSignIn();
                if(await login_sucess){
                  Navigator.of(context).pop();
                }
              },
              child: Text("Anonymous Login"),
            ),
          ],
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
