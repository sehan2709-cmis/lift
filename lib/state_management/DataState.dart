import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

import '../data.dart';

class DataState extends ChangeNotifier {
  DataState() {
    log("Creating DataState");
    init();
  }

  List<FlSpot> data = <FlSpot>[];
  double maxY = 0;
  double maxX = 0;
  DateTime startDate = DateTime.now();

  DateTime date1 = DateTime(1);
  DateTime date2 = DateTime(1);


  List<bool> workoutDays = [true, true, false, true, true];


  void init() {
    DateTime now = DateTime.now();
    date1 = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 7));
    date2 = DateTime(now.year, now.month, now.day);
  }

  void initData() {
    // DateTime now = DateTime.now();
    // date1 = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 7));
    // date2 = DateTime(now.year, now.month, now.day);
    updateData(date1, date2);
  }

  Future<void> updateWorkoutDays(DateTime date) async {
    /// download workout dates info
    String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection("User")
        .doc(uid)
        .collection("WorkoutDates")
        .doc("${date.year}")
        .get();
    if(doc.exists) {
      if(doc.data()!.containsKey(date.month.toString())){
        log("workout days exist for month: ${date.month}");
        List<dynamic> days = doc.get(date.month.toString());
        log(days.toString());
        workoutDays = days.cast<bool>();
      }
      else{
        workoutDays = [false];
      }
    }
    else{
      workoutDays = [false];
    }

    notifyListeners();
  }

  Future<void> updateData(DateTime date1, DateTime date2) async {
    log("date 1 is : ${date1.toString()}");
    log("date 2 is : ${date2.toString()}");

    List<FlSpot> newData = await getDataBetweenDates(date1, date2);
    double newMaxY = 0;
    for(FlSpot d in newData) {
      if(newMaxY < d.y){
        newMaxY = d.y;
      }
    }
    double newMaxX = newData.length.toDouble();

    data = newData;
    maxY = newMaxY;
    maxX = newMaxX;
    startDate = date1;

    log("data : ${data.toString()}");
    log("maxX : $maxX");

    notifyListeners();
  }
}
