import 'dart:developer';

import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';

class UserGlobalProfilePage extends StatefulWidget {
  const UserGlobalProfilePage({super.key});

  @override
  State<UserGlobalProfilePage> createState() => _UserGlobalProfilePageState();
}

class _UserGlobalProfilePageState extends State<UserGlobalProfilePage> {
  @override
  Widget build(BuildContext context) {
    final String uid = ModalRoute.of(context)!.settings.arguments as String;
    log("UGP :: $uid");
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
              child: Container(
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
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(uid),
              ),
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
