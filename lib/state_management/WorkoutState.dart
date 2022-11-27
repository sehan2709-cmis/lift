import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:lift/model/Exercise.dart';
import 'package:lift/model/Workout.dart';

import '../firebase_options.dart';

class WorkoutState extends ChangeNotifier {

  List<Workout> _workouts = [];
  List<Workout> get workouts => _workouts;

  var db;
  var uid;

  WorkoutState() {
    log("Creating WorkoutState");
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform);
    uid = FirebaseAuth.instance.currentUser?.uid;
    db = FirebaseFirestore.instance;
    workoutQuerySingle();
  }

  void workoutQuerySingle() {
    if(uid == null) return;
    _workouts = [];   // reset _workouts
    log("Trying to get collection of ${uid}");
    //uid!
    db.collection("<user-uid>").orderBy('CreateDate', descending: true).get().then(
          (res) {
            List<Exercise> exercises = [];
            for(final doc in res.docs){
              // 
              for(final field in doc.data().entries) {
                //
                if(field.key != 'CreateDate') {
                  // key = name of exercise
                  // value = list of {"weight", "rep"}
                  // List<Map<String, int>> categoriesList = List<Map<String, int>>.from(field.value);
                  // List<Map<String, int>> setsList = (field.value).map((Map<String, int> e) => e as Map<String, int>)?.toList();
                  List<Map<String, int>> setsList = [];
                  for(final sets in field.value) {
                    Map<String, int> m = {};
                    m['weight'] = int.parse(sets['weight']);
                    m['reps'] = int.parse(sets['reps']);
                    setsList.add(m);
                  }
                  exercises.add(Exercise(field.key, setsList));
                }
              }
              // final time = DateTime.fromMillisecondsSinceEpoch(doc['CreateDate']).toLocal().toString();
              final workout = Workout('time', exercises);
              _workouts.add(workout);
            }
            log(_workouts[0].Exercises[0].Name);
            log(_workouts[0].Exercises[0].Sets.toString());
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? workoutQueryStream() {
    log("Downloading user's workout data from firebase");


    if(uid == null) return null;

    return FirebaseFirestore.instance
        .collection(uid!)
        .orderBy('CreateDate', descending: true)
        .snapshots()
        .listen((snapshot) {
      _workouts = [];
      log("product change detected!.. there are ${snapshot.docs.length} documents");
      for (final document in snapshot.docs) {
        // _workouts.add();
      }
      notifyListeners();
    });
  }
}