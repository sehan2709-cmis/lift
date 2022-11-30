

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class GalleryState extends ChangeNotifier {
  GalleryState() {
    log("Creating ApplicationState");
  }

  // variable to store gallery information
  List<Map<String, dynamic>> gallery = [];

  /// Read current user's Gallery data
  void readGallery() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> res = await FirebaseFirestore.instance
        .collection("User")
        .doc(uid)
        .collection("Gallery")
        .get();

    gallery.clear();

    /// initialize gallery list
    if (res.docs.isEmpty) {
      log("HOME :: No Gallery items found!");
    }
    else if (res.docs.isNotEmpty) {
      log("HOME :: Gallery item(s) found!");
      for (final doc in res.docs) {
        gallery.add(doc.data());
      }
    }
    notifyListeners();
  }
}