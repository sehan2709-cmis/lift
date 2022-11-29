import 'dart:collection';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lift/navigation_bar/bottom_navigation_bar.dart';
import 'package:lift/state_management/NavigationState.dart';
import 'package:lift/state_management/WorkoutState.dart';
import 'package:provider/provider.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class Ranking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 여기에 넣는 코드는 페이지가 로드 될 때마다 새로 실행된다
    Future.delayed(Duration.zero, () async {
      Provider.of<WorkoutState>(context, listen: false).downloadRanking();
      log("downloaded");
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Ranking"),
      ),
      body: Consumer<WorkoutState>(
        builder: (context, workoutState, _) => ListView(
          children: [
            // variable i need to keep increasing, so can't use final keyword here
            for (var i=0; i<workoutState.rankingSize; i++)
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      SizedBox(width: 50, child: Center(child: Text("${i+1}"),)),
                      Expanded(
                        flex: 5,
                        child: Text("${workoutState.ranks["user"]?.elementAt(i)}"),
                      ),
                      Flexible(
                        child: Text("${workoutState.ranks["totalVolume"]?.elementAt(i)}"),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BNavigationBar(),
    );
  }
}