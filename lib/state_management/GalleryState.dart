

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

  /// this is for when logging out
  void resetGallery() {
    gallery.clear();
    log("GALLERY IS CLEARED AND IS NOW ${gallery}");
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getGallery(String uid) async {
    List<Map<String, dynamic>> g = [];
    QuerySnapshot<Map<String, dynamic>> res = await FirebaseFirestore.instance
        .collection("User")
        .doc(uid)
        .collection("Gallery")
        .get();

    if (res.docs.isEmpty) {
      log("getGallery :: No Gallery items found!");
    }
    else if (res.docs.isNotEmpty) {
      log("getGallery :: Gallery item(s) found!");
      for (final doc in res.docs) {
        final docA = doc.data();
        docA.addAll({"docId":doc.id});
        g.add(docA);
        // log("GALLERY :: ${docA}");
      }
    }
    return g;
  }

  /// Read current user's Gallery data
  Future<void> readGallery() async {
    if(FirebaseAuth.instance.currentUser == null) return;

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
        final docA = doc.data();
        docA.addAll({"docId":doc.id});
        gallery.add(docA);
        // log("GALLERY :: ${docA}");
      }
    }
    notifyListeners();
  }
}