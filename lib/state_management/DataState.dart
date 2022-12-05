import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

import '../data.dart';
import '../model/Workout.dart';

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
  DateTime? date2 = DateTime(1);

  // sample days added for testing
  // this hardcoded values are not used
  // they are re written by firebase values before actual use
  List<bool> workoutDays = [true, true, false, true, true];

  List<Workout> workouts = [];


  void init() {
    DateTime now = DateTime.now();
    DateTime date1 = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 7));
    DateTime date2 = DateTime(now.year, now.month, now.day);
    this.date1 = date1;
    this.date2 = date2;
    // dateRange.clear();
    // dateRange.add(date1);
    // dateRange.add(date2);
  }

  void initData() {
    log("Initializing DataPage");
    log("${date1}");
    if(date2 != null) {
      log("${date2!}");
      updateData(date1, date2!);
    }
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

  /// updates data for drawing graph
  Future<void> updateData(DateTime date1, DateTime date2) async {
    log("date 1 is : ${date1.toString()}");
    log("date 2 is : ${date2.toString()}");
    this.date1 = date1;
    this.date2 = date2;
    // dateRange.clear();
    // dateRange.add(date1);
    // dateRange.add(date2);


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

  /// download workouts between given dates
  Future<void> updateWorkouts(DateTime date1, DateTime date2) async {

  }
}
