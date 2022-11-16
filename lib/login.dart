import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text("Google Login"),
            ),
          ],
        ),
      ),
    );
    // floatingActionButton: // floating button widget
  }
}
