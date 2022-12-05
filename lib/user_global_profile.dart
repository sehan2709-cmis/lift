import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

import 'home.dart';

class UserGlobalProfilePage extends StatefulWidget {
  const UserGlobalProfilePage({super.key});

  @override
  State<UserGlobalProfilePage> createState() => _UserGlobalProfilePageState();
}

class _UserGlobalProfilePageState extends State<UserGlobalProfilePage> {
  List<Map<String, dynamic>> gallery = [];
  Map<DateTime, int> currentYearWorkoutDates = {};

  List<StatelessWidget> _buildGridCards(
      BuildContext context, List<Map<String, dynamic>> gallery) {
    if (gallery.isEmpty) {
      return const <StatelessWidget>[];
    }

    return gallery.map((Map<String, dynamic> item) {
      final imgUrl = item["imageUrl"].toString();
      final memo = item["memo"].toString();
      final timeCreated = item["timeCreated"].toDate().toString();

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
            placeholder: (context, url) => const SizedBox(
              width: 10,
              height: 10,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final argv = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final String uid = argv[0] as String;
    final List<Map<String, dynamic>> gallery =
        argv[1] as List<Map<String, dynamic>>;
    final Map<DateTime, int> currentYearWorkoutDates =
        argv[2] as Map<DateTime, int>;
    final String? profileImage = argv[3];

    ImageProvider ip = AssetImage("assets/img/placeholder_image.png");
    final p = Center(
      child: ProfilePicture(
        name: uid,
        radius: 167/2,
        fontsize: 80,
        // random: true,
      ),
    );
    if (profileImage != null) {
      ip = NetworkImage(profileImage!);
    }
    final profileIsNull = (profileImage == null);

    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(
              height: 30,
            ),
            DropShadow(
              child: Container(
                height: 167,
                decoration: BoxDecoration(
                  image: DecorationImage(image: ip, fit: BoxFit.contain),
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                ),
                child: profileIsNull?p:null,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(uid),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.blueGrey,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: HeatMap(
                  startDate: DateTime(2022, 1, 1),
                  size: 16,
                  datasets: currentYearWorkoutDates,
                  colorMode: ColorMode.opacity,
                  textColor: Colors.white,
                  showText: false,
                  scrollable: true,
                  showColorTip: false,
                  colorsets: const {
                    1: Colors.lightGreenAccent,
                    3: Colors.orange,
                    5: Colors.yellow,
                    7: Colors.green,
                    9: Colors.blue,
                    11: Colors.indigo,
                    13: Colors.purple,
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              " Gallery",
              style: TextStyle(fontSize: 30),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              crossAxisCount: 3,
              padding: const EdgeInsets.all(16.0),
              childAspectRatio: 8.0 / 9.0,
              children: _buildGridCards(context, gallery),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileClip extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return const Rect.fromLTWH(0, 0, 200, 200);
  }

  @override
  bool shouldReclip(oldClipper) {
    return false;
  }
}
