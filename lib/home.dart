import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lift/state_management/NavigationState.dart';
import 'package:provider/provider.dart';

import 'navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    NavigationState _navigationState = Provider.of<NavigationState>(context);
    // BNavigationBar nevi = new BNavigationBar();
    return Scaffold(
      appBar: AppBar(
        title: Text("home"),
        actions: [
          IconButton(onPressed: (){Navigator.of(context).pushNamed('/profile');}, icon: Icon(Icons.person)),],
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("WELCOME HOME"),
          ],
        ),
      ),
      bottomNavigationBar: BNavigationBar(),
    );
  }
}
