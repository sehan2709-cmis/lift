import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lift/state_management/NavigationState.dart';
import 'package:provider/provider.dart';

import 'model/Workout.dart';
import 'navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class _HomePageState extends State<HomePage> {
  // FirebaseFirestore.instance.collection("user");
  List<Map<String, dynamic>> gallery = [];
  // 실시간 업데이트 하지 말고 그냥 페이지가 새로 만들어질 때만 자료를 받아오는 식으로 하는게 좋을 것 같다
  // FirebaseFirestore.instance.
  // FirebaseFirestore.instance.collection("User").doc(FirebaseAuth.instance.currentUser!.uid);
  //     .get().then((DocumentSnapshot doc) {
  // // if gallery doesn't exists
  // if (!doc.exists || doc.get("gallery") == null) {
  // const <StatelessWidget>[];
  // }
  // doc.get("gallery")
  // });
  List<StatelessWidget> _buildGridCards(BuildContext context, List<dynamic> gallery) {
    if(gallery.isEmpty) {
      return const <StatelessWidget>[];
    }
    return gallery.map((item) {
      return Card(
      );
    }).toList();

    // Collection: User -> Document: <uid> -> Field: key: gallery
    // value: { imgurl, memo, timeCreated, timeModified }
  }

  @override
  Widget build(BuildContext context) {
    NavigationState _navigationState = Provider.of<NavigationState>(context);
    // BNavigationBar nevi = new BNavigationBar();
    return Scaffold(
      appBar: AppBar(
        title: Text("home"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/profile');
              },
              icon: Icon(Icons.person)),
        ],
      ),
      body: ListView(
        children: [
          Text("WELCOME HOME"),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/posedemo');
            },
            child: Text("Pose Detection"),
          ),
          Container(
            color: Colors.lightBlue,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
              child: HeatMap(
                // need to get the dataset from provider?
                // fixed fill color value
                datasets: {
                  DateTime(2022, 11, 6): 13,
                  DateTime(2022, 11, 7): 13,
                  DateTime(2022, 11, 8): 13,
                  DateTime(2022, 11, 9): 13,
                  DateTime(2022, 11, 13): 13,
                },
                colorMode: ColorMode.opacity,
                showText: false,
                scrollable: true,
                showColorTip: false, // don't show color range tip
                colorsets: {
                  1: Colors.blue,
                  3: Colors.orange,
                  5: Colors.yellow,
                  7: Colors.green,
                  9: Colors.blue,
                  11: Colors.indigo,
                  13: Colors.purple,
                },
                onClick: (value) {
                  // 날짜 클릭 했을 때
                  // ScaffoldMessenger.of(context)
                  //     .showSnackBar(SnackBar(content: Text(value.toString())));
                },
              ),
            ),
          ),
          Text("Gallery"),
          GridView.count(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            crossAxisCount: 2,
            padding: const EdgeInsets.all(16.0),
            childAspectRatio: 8.0 / 9.0,
            children: _buildGridCards(context, gallery),
          ),
        ],
      ),
      bottomNavigationBar: BNavigationBar(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}
