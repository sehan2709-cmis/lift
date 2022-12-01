import 'dart:collection';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lift/navigation_bar/bottom_navigation_bar.dart';
import 'package:lift/state_management/GalleryState.dart';
import 'package:lift/state_management/NavigationState.dart';
import 'package:lift/state_management/WorkoutState.dart';
import 'package:lift/user_global_profile.dart';
import 'package:provider/provider.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:uuid/uuid.dart';

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
    WorkoutState simpleWorkoutState = Provider.of<WorkoutState>(context, listen: false);
    GalleryState simpleGalleryState = Provider.of<GalleryState>(context, listen: false);

    Future.delayed(Duration.zero, () async {
      /// 아직 context가 만들어 지지 않았는데 context의 provider를 접근하려고 하는게 문제가 생기는 것 같다
      /// delayed에 이렇게 넣으면 build가 끝난 다음에 실행되기 때문에 괜찮다
      simpleWorkoutState.downloadVolumeRanking();
      simpleWorkoutState.downloadStreakRanking();
      simpleWorkoutState.downloadSBDSumRanking();
      log("RANK :: downloaded rankings");
    });

    List<Widget> _rankingBuilder(
        String name,
      Map<String, List<String>> rankData,
      int dataSize,
    ) {
      List<Widget> ranks = [];
      ranks.add(SizedBox(
        height: 15,
      ));

      var uuid = Uuid();
      //workoutState.volumeRankingSize
      for (var i = 0; i < dataSize; i++) {
        final String heroTag = uuid.v4();
        log(heroTag);
        Widget one = Padding(
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 20,
          ),
          child: InkWell(
            onTap: () async {
              /// go to global user profile page
              /// + Hero animation
              final String uid = FirebaseAuth.instance.currentUser!.uid;
              // 내 uid말고 클릭한 사용자의 uid
              log("RANKING -> GP :: ${rankData["user"]?.elementAt(i)}");
              final String targetUid = rankData["user"]!.elementAt(i);
              final g = await simpleGalleryState.getGallery(targetUid);
              final wd = await simpleWorkoutState.getWorkoutDates(targetUid);
              Navigator.of(context).pushNamed("/userGobalProfile", arguments: [targetUid, g, wd]);
            },
            // highlightColor: Colors.black,
            // splashColor: Colors.blue,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.5),
                border: Border.all(width: 1.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 50,
                      width: 30,
                      child: Center(
                        child: Text("${i + 1}"),
                      )),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: ClipOval(
                      /// need to change the image to display user image
                      child: Hero(
                        tag: uuid.v4(),
                        child: Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRFU7U2h0umyF0P6E_yhTX45sGgPEQAbGaJ4g&usqp=CAU',
                            fit: BoxFit.cover),
                      ),
                      clipper: MyClip(),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      "${rankData["user"]?.elementAt(i)}",
                      // "${workoutState.volumeRanking["user"]?.elementAt(i)}"
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: Text(
                      "${rankData["score"]?.elementAt(i)}",
                      // "${workoutState.volumeRanking["totalVolume"]?.elementAt(i)}"
                    ),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                ],
              ),
            ),
          ),
        );
        ranks.add(one);
      }
      return ranks;
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ranking"),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(20),
            child: TabBar(
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
                children:
                    // variable i need to keep increasing, so can't use final keyword here
                    _rankingBuilder(
                      "volume",
                  workoutState.volumeRanking,
                  workoutState.volumeRankingSize,
                ),
              ),
              ListView(
                children:
                    // variable i need to keep increasing, so can't use final keyword here
                    _rankingBuilder(
                      "sbdMax",
                  workoutState.sbdSumRanking,
                  workoutState.sbdSumRankingSize,
                ),
              ),
              ListView(
                children:
                    // variable i need to keep increasing, so can't use final keyword here
                    _rankingBuilder(
                      "streak",
                  workoutState.streakRanking,
                  workoutState.streakRankingSize,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BNavigationBar(),
      ),
    );
  }
}

class MyClip extends CustomClipper<Rect> {
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 7, 36, 36);
  }

  bool shouldReclip(oldClipper) {
    return false;
  }
}
