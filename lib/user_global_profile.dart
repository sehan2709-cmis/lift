import 'package:flutter/material.dart';

class UserGlobalProfilePage extends StatefulWidget {
  const UserGlobalProfilePage({super.key});

  @override
  State<UserGlobalProfilePage> createState() => _UserGlobalProfilePageState();
}

class _UserGlobalProfilePageState extends State<UserGlobalProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
      ),
      body: SafeArea(
        child: Text("body"),
      ),
      // floatingActionButton:
    );
  }
}
