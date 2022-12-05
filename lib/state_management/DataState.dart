import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

import '../data.dart';
import '../model/Exercise.dart';
import '../model/Workout.dart';

class DataState extends ChangeNotifier {
  DataState() {
    log("Creating DataState");
    init();
  }

  /// variables for drawing graph
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
    /// dates are initialized to today and today-7
    DateTime now = DateTime.now();
    DateTime date1 = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 7));
    DateTime date2 = DateTime(now.year, now.month, now.day);
    this.date1 = date1;
    this.date2 = date2;
    startDate = date1;  /// data.dart
    log("DATE IS INITIALIZED TO $date1 , $date2 ************");
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

  /// this is used to display dot mark on the calendar
  Future<void> updateWorkoutDays(DateTime date) async {
    /// download workout dates info for the given date's month
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

  Future<void> reloadDataAndWorkouts() async {
    if(date2 != null) {
      await updateData(date1, date2!);
      await updateWorkouts(date1, date2!);
    }
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
    log("Updating workouts... for data page");
    // date1 must be same or before date2
    String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference<Map<String, dynamic>> userCollectionRef = FirebaseFirestore.instance.collection("User");
    date2 = date2.add(Duration(days: 1));
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await userCollectionRef.doc(uid)
        .collection("Workout")
        .orderBy('CreateDate', descending: true)
        .where("CreateDate", isGreaterThanOrEqualTo: date1)
        .where("CreateDate", isLessThan: date2)
        .get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = querySnapshot.docs;
    // if some document exists

    if(docs.isNotEmpty) {
      log("\t\t Some workouts exists!");
      // reset workout before adding new ones
      workouts.clear();
      for(QueryDocumentSnapshot<Map<String, dynamic>> doc in docs){
        // for each document
        final data = doc.data() as Map<String, dynamic>;
        List<Exercise> exercises = []; // create Exercises

        for(final exerciseName in data.keys) {
          log("ex name $exerciseName");
          /// should change below logic to skip if exercise doesn't have "weight" and "reps" keys
          if(exerciseName == "CreateDate") continue; // skip if key name is CreateDate
          if(exerciseName == "todayVolume") continue; // skip if key name is todayVolume
          // otherwise assume that it is exercise
          // create a new exercise with exerciseName
          Exercise exercise = Exercise(exerciseName);
          for(final set in data[exerciseName]) {
            exercise.addSet(set["weight"], set["reps"]);
          }
          exercises.add(exercise);
        }
        Timestamp createDateStamp = data["CreateDate"];
        // log("hi ${createDateStamp.toString()}");
        DateTime createDate = createDateStamp.toDate();
        // log("bye ${createDate.toString()}");
        final workout = Workout(docId: doc.id, createDate: createDate, exercises: exercises,);

        workouts.add(workout);
        log("\t\t workout added!");
      }
    }
    else {
      log("\t\t No workouts found between selected dates");
      // There are no workout documents to add
      workouts.clear();
    }

    // now workouts member variable should have been updated
    // now update listening children

    // debug print
    log(workouts.toString());

    notifyListeners();
  }
}
