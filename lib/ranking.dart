import 'dart:collection';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lift/navigation_bar/bottom_navigation_bar.dart';
import 'package:lift/state_management/NavigationState.dart';
import 'package:lift/state_management/WorkoutState.dart';
import 'package:provider/provider.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class Ranking extends StatefulWidget {
  const Ranking({super.key});

  @override
  State<Ranking> createState() => _RankingState();
}

class _RankingState extends State<Ranking>
    with AutomaticKeepAliveClientMixin<Ranking> {
  /// below preserves the state of the tabs
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // 여기에 넣는 코드는 페이지가 로드 될 때마다 새로 실행된다
    Future.delayed(Duration.zero, () async {
      /// 아직 context가 만들어 지지 않았는데 context의 provider를 접근하려고 하는게 문제가 생기는 것 같다
      /// delayed에 이렇게 넣으면 build가 끝난 다음에 실행되기 때문에 괜찮다
      Provider.of<WorkoutState>(context, listen: false).downloadVolumeRanking();
      log("downloaded");
    });

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ranking"),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(20),
            child: TabBar(
              // indicator: BoxDecoration(
              //     borderRadius: BorderRadius.circular(50), // Creates border
              //     color: Colors.greenAccent),
              indicatorWeight: 6,
              tabs: [
                Text("Volume"),
                Text("SBD-Max"),
                Text("Streak"),
              ],
            ),
          ),
        ),
        body: Consumer<WorkoutState>(
          builder: (context, workoutState, _) => TabBarView(
            children: [
              ListView(
                children: [
                  // variable i need to keep increasing, so can't use final keyword here
                  for (var i = 0; i < workoutState.volumeRankingSize; i++)
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 50,
                              child: Center(
                                child: Text("${i + 1}"),
                              )),
                          Expanded(
                            flex: 5,
                            child: Text(
                                "${workoutState.volumeRanking["user"]?.elementAt(i)}"),
                          ),
                          Flexible(
                            child: Text(
                                "${workoutState.volumeRanking["totalVolume"]?.elementAt(i)}"),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              Text("1"),
              Text("2"),
            ],
          ),
        ),
        bottomNavigationBar: BNavigationBar(),
      ),
    );
  }
}
