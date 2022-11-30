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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 실시간 업데이트 하지 말고 그냥 페이지가 새로 만들어질 때 자료 받아오기
  // 페이지가 새로 만들어질 때 마다 gallery는 아래 코드로 인해 reset된다
  List<Map<String, dynamic>> gallery = [];

  List<StatelessWidget> _buildGridCards(
      BuildContext context, List<Map<String, dynamic>> gallery) {
    final ThemeData theme = Theme.of(context);

    if (gallery.isEmpty) {
      log("HOME :: Gallery is empty");
      return const <StatelessWidget>[];
    }
    return gallery.map((Map<String, dynamic> item) {
      final imgUrl = item["imageUrl"].toString();
      final memo = item["memo"].toString();
      final timeCreated = item["timeCreated"].toString();
      final timeModified = item["timeModified"].toString();

      return Card(
        clipBehavior: Clip.antiAlias,
        // TODO: Adjust card heights (103)
        child: InkWell(
          onTap: (){log("HOME :: Image tapped!");},
          // splashColor: Colors.blue, // only works if the child is Ink.image ???
          child: Image.network(
            imgUrl,
            fit: BoxFit.cover,
          ),
        ),
        // Stack(
        //   children: [
        //     Column(
        //       // TODO: Center items on the card (103)
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: <Widget>[
        //         // AspectRatio(
        //         //   aspectRatio: 15 / 15,
        //         //   child: Image.network(
        //         //     imgUrl,
        //         //     fit: BoxFit.cover,
        //         //   ),
        //         // ),
        //         // Expanded(
        //         //   child: Padding(
        //         //     padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
        //         //     child: Column(
        //         //       // TODO: Align labels to the bottom and center (103)
        //         //       crossAxisAlignment: CrossAxisAlignment.start,
        //         //       // TODO: Change innermost Column (103)
        //         //       children: <Widget>[
        //         //         // TODO: Handle overflowing labels (103)
        //         //         Text(
        //         //           timeCreated,
        //         //           style: theme.textTheme.headline6,
        //         //           maxLines: 1,
        //         //         ),
        //         //         const SizedBox(height: 8.0),
        //         //         Text(
        //         //           "hi",
        //         //           style: theme.textTheme.subtitle2,
        //         //         ),
        //         //       ],
        //         //     ),
        //         //   ),
        //         // ),
        //       ],
        //     ),
        //     // Container(
        //     //   alignment: Alignment.bottomRight,
        //     //   child: TextButton(
        //     //     onPressed: () {
        //     //       // simpleAppState.currentProduct = product;
        //     //       // Navigator.of(context).pushNamed('/detail');
        //     //     },
        //     //     child: const Text("more"),
        //     //   ),
        //     // ),
        //     // Visibility(
        //     //   visible: true,
        //     //   child: Container(
        //     //     alignment: Alignment.topRight,
        //     //     child: const Padding(
        //     //       padding: EdgeInsets.all(5),
        //     //       child: Icon(
        //     //         Icons.check_circle,
        //     //         color: Colors.blueAccent,
        //     //       ),
        //     //     ),
        //     //   ),
        //     // ),
        //   ],
        // ),
      );
    }).toList();

    // Collection: User -> Document: <uid> -> Field: key: gallery
    // value: { imgurl, memo, timeCreated, timeModified }
  }

  @override
  Widget build(BuildContext context) {
    /// 패이지가 로드 될 때마다 Firebase에서 데이터를 읽어 온다
    /// 이렇게 하면 Firebase를 사용해 값이 없데이트 되었을 때에도 build를 다시 하기 때문에
    /// build가 무한 반복으로 실행된다
    /// 따라서 결국 Gallery는 외부로 빼주는게 좋다는 결론
    final uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection("Gallery")
        .get()
        .then((res) {
          log("HOME :: Reading Gallery data from firebase");
      res.docs; // list of all the documents
      if (res.docs.isEmpty) {
        setState(() {
          gallery = const <StatelessWidget>[].cast<Map<String, dynamic>>();
        });
      } else {
        log("HOME :: Gallery item(s) found!");
        // gallery.clear(); // Cannot change the length of an unmodifiable list ???
        gallery = []; /// initialize gallery
          for (final doc in res.docs) {
            gallery.add(doc.data());
          }

      }
    });

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
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Workout Streak", style: TextStyle(fontSize: 30),),
              Text("23", style: TextStyle(fontSize: 30),),
            ],
          ),
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
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Gallery", style: TextStyle(fontSize: 30),),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/addImagePage');
                },
                child: Text("addImage"),
              ),
            ],
          ),
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
