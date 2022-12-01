import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:uuid/uuid.dart';

import 'home.dart';

class UserGlobalProfilePage extends StatefulWidget {
  const UserGlobalProfilePage({super.key});

  @override
  State<UserGlobalProfilePage> createState() => _UserGlobalProfilePageState();
}

class _UserGlobalProfilePageState extends State<UserGlobalProfilePage> {

  List<Map<String, dynamic>> gallery = [];
  Map<DateTime, int> currentYearWorkoutDates = {};

  List<StatelessWidget> _buildGridCards(BuildContext context, List<Map<String, dynamic>> gallery) {
    if (gallery.isEmpty) {
      log("HOME :: Gallery is empty");
      return const <StatelessWidget>[];
    }

    return gallery.map((Map<String, dynamic> item) {
      final imgUrl = item["imageUrl"].toString();
      final imgName = item["imageName"].toString();
      final author = item["author"].toString();
      final docId = item["docId"].toString();
      final memo = item["memo"].toString();
      final timeCreated = item["timeCreated"].toDate().toString();
      final timeModified = item["timeModified"].toDate().toString();

      return Card(
        clipBehavior: Clip.antiAlias,
        // TODO: Adjust card heights (103)
        child: InkWell(
          onTap: () async {
            await showDialog(
              context: context,
              builder: (_) => Hero(
                tag: imgUrl,
                child: ImageDialog(
                  imgUrl: imgUrl,
                  memo: memo,
                  createDate: timeCreated,
                ),
              ),
            );
          },
          splashColor: Colors.blue,
          child: CachedNetworkImage(
              imageUrl: imgUrl,
              imageBuilder: (context, imageProvider) {
                return Ink.image(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  onImageError: (object, stacktrace) {
                    log("HOME :: no image");
                  },
                );
              },
              placeholder: (context, url) => SizedBox(
                width: 10,
                height: 10,
                child: Center(child: CircularProgressIndicator()),
              ),
             errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final argv = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final String uid = argv[0] as String;
    final List<Map<String, dynamic>> gallery = argv[1] as List<Map<String, dynamic>>;
    final Map<DateTime, int> currentYearWorkoutDates = argv[2] as Map<DateTime, int>;
    log("UGP :: $uid");
    var uuid = Uuid();

    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: 30,
            ),
            DropShadow(
              // opacity: ,
              // blurRadius: 20.0,
              // borderRadius: 0.1,
              child:
                  // Hero(
                  // tag: ,
                  // child:
                  Container(
                height: 167,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/img/placeholder_image.png"),
                      fit: BoxFit.contain),
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                ),
              ),
              // ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(uid),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.blueGrey,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: HeatMap(
                  startDate: DateTime(2022, 1, 1),
                  size: 16,
                  // need to get the dataset from provider?
                  // fixed fill color value
                  datasets: currentYearWorkoutDates,
                  colorMode: ColorMode.opacity,
                  textColor: Colors.white,
                  showText: false,
                  scrollable: true,
                  showColorTip: false, // don't show color range tip
                  colorsets: {
                    1: Colors.teal,
                    3: Colors.orange,
                    5: Colors.yellow,
                    7: Colors.green,
                    9: Colors.blue,
                    11: Colors.indigo,
                    13: Colors.purple,
                  },
                  onClick: (value) {
                    // 날짜 클릭 했을 때
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              " Gallery",
              style: TextStyle(fontSize: 30),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              crossAxisCount: 3,
              padding: const EdgeInsets.all(16.0),
              childAspectRatio: 8.0 / 9.0,

              /// galleryState.gallery is automatically updated when notifyListeners() is called at the Provider side
              children: _buildGridCards(context, gallery),
            ),
          ],
        ),
      ),
      // floatingActionButton:
    );
  }
}

class ProfileClip extends CustomClipper<Rect> {
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, 200, 200);
  }

  bool shouldReclip(oldClipper) {
    return false;
  }
}
