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
    // Workout workout = Workout("", []);
    // workout.exercises.add(Exercise("Barbell Curl").addSet(20, 10).addSet(20, 11).addSet(20, 12));
    // workout.exercises.add(Exercise("Tricep Extension").addSet(30, 20).addSet(30, 20).addSet(25, 20));
    // addWorkout(workout);
    workoutQueryOnce();
  }

  void addWorkout(Workout workout) {
    final data = workout.data();
    data["CreateDate"] = FieldValue.serverTimestamp();  // override to server timestamp
    //TODO: change to uid
    log(data.toString());
    db.collection('<user-uid>')
        .add(data);
  }

  void workoutQueryOnce() {
    if(uid == null) return;
    log("Trying to get collection of user id: ${uid}");
    db.collection("<user-uid>").orderBy('CreateDate', descending: true).get().then(
          (res) {
            // res will contain all of the documents of user collection
            // final data = doc.data() as Map<String, dynamic>;
            /* Fields:
             *      1. <Ex 1>
             *      2. <Ex 2>
             *      3. CreateDate
             */
            _workouts = [];   // reset _workouts
            for(DocumentSnapshot doc in res.docs){
              final data = doc.data() as Map<String, dynamic>;
              List<Exercise> exercises = [];  // create exercise list for a workout
              for(final exerciseName in data.keys) {
                if(exerciseName == 'CreateDate') continue;
                // otherwise assume the field is an exercise data
                Exercise exercise = Exercise(exerciseName);   // create an exercise
                for(final set in data[exerciseName]) {
                  exercise.addSet(set['weight'], set['reps']);
                }
                exercises.add(exercise);
              }
              final createDate = DateTime.fromMillisecondsSinceEpoch(data['CreateDate'].millisecondsSinceEpoch).toLocal().toString();
              final workout = Workout(createDate, exercises);
              _workouts.add(workout);
            }
            log(_workouts.toString());
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