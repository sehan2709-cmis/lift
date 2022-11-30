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

  Map<String, List<String>> volumeRanking = {};
  int volumeRankingSize = 0;
  void resetVolumeRanking() {
    volumeRanking.clear();
    volumeRanking.addAll({"user": [], "totalVolume": []});
    volumeRankingSize = 0;
  }

  /// uid used here must be continuously updated when user changes
  /// however, listening to FirebaseAuth user change is duplicated if it is also called here
  /// Therefore, when user uid is needed, let the function get it as parameter
  /// or get the current uesr's uid inside the function
  late CollectionReference<Map<String, dynamic>> userCollectionRef;
  late Query<Map<String, dynamic>> totalVolumeQuery;

  /// initializer
  WorkoutState() {
    log("Creating WorkoutState");

    /// FirebaseFirestore instance can only be use after initialization
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    userCollectionRef = FirebaseFirestore.instance.collection("User");
    totalVolumeQuery =
        userCollectionRef.orderBy('totalVolume', descending: true);
  }

  /// Demo of adding workout data to firebase
  void addSampleWorkout() {
    for (int i = 0; i < 1; i++) {
      Workout workout = Workout();
      workout.exercises
          .add(Exercise("Squat").addSet(100, 10).addSet(110, 8).addSet(120, 5));
      workout.exercises.add(
          Exercise("Bench Press").addSet(80, 10).addSet(70, 12).addSet(60, 16));
      addWorkout(workout);
    }
  }

  /// This method searches for all workouts done at the given date
  /// and calculates the total volume done at that date
  /// if there is no workout at the provided date, it returns 0
  double getTotalVolumeAtDate(String date) {
    double totalVolume = 0.0;
    DateTime now = DateTime.parse(date);
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);

    for (final workout in workouts) {
      DateTime workoutDay = DateTime.parse(workout.createDate);
      if (workoutDay.isAfter(today) && workoutDay.isBefore(tomorrow)) {
        // log("${today}");
        for (final exercise in workout.exercises) {
          for (final set in exercise.Sets) {
            totalVolume += set['weight']! * set['reps']!;
            // log("${totalVolume} += ${set['weight']! * set['reps']!} (${set['weight']} * ${set['reps']})");
          }
        }
      }
    }
    return totalVolume;
  }

  void downloadVolumeRanking() {
    // reset the outdated ranking
    resetVolumeRanking();
    totalVolumeQuery.get().then((res) {
      if (res.size == 0) {
        log("no volume rankings");
        return;
      }
      for (DocumentSnapshot doc in res.docs) {
        // document id is user uid
        // each document contains "totalVolume" field
        /*
                currently the ranking system will display user uid instead of nickname
                however for security reasons this must be fixed if it is going to be released
                 */
        var data = doc.data() as Map<String, dynamic>;
        data.entries.where((element) => element.key == "totalVolume");
        volumeRanking["user"]?.add(doc.id);
        volumeRanking["totalVolume"]?.add(data["totalVolume"].toString());
        volumeRankingSize++;
      }
      log("Ranks :: ${volumeRanking.toString()}");
      notifyListeners(); // after successfully updating, need to notify listening widgets
    });
    // since above operation is asynchronous, notifyListeners() must be called inside
  }

  /// Upload a workout to Firestore
  /// It creates document of a workout with random id
  /// Checks ranking data and updates it too
  void addWorkout(Workout workout) {
    final data = workout.data();

    data["CreateDate"] = FieldValue.serverTimestamp(); // set to server timestamp
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference<Map<String, dynamic>> userDocRef = userCollectionRef.doc(uid);
    userDocRef.collection("Workout").add(data);

    // calculate total volume of the day and add it to Rankings collection
    // update ranking data when adding workout
    // for now assume that data added cannot be modified
    int totalVolume = 0;
    for (final exercise in workout.exercises) {
      for (final set in exercise.Sets) {
        totalVolume += set['weight']! * set['reps']!;
      }
    }

    /// Also need to add Streak and 1RM data
    /// Update totalVolume
    userDocRef.get().then((DocumentSnapshot doc) {
      // At this point, user document(with uid) must exist in User collection
      // because when the user logs in for the first time, user document is created
      try{
        // log("******:${doc.get("totalVolume")}:******");
        totalVolume += doc.get('totalVolume') as int;
      }catch(e){
        // log("there is no field");
      }finally{
        userDocRef.set({"totalVolume": totalVolume});
      }
    });

    /// Update Workout Dates List

    /// Update Streak

    /// Update SBD-Max

    /// Update last workout

  }

  /// Get workout data of a user once
  /// it downloads all of the user's workout data
  void workoutQueryOnce() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    if (uid == null) return;
    log("Trying to get collection of user id: ${uid}");
    userCollectionRef
        .doc(uid)
        .collection("Workout")
        .orderBy('CreateDate', descending: true)
        .get()
        .then(
      (res) {
        // res will contain all of the documents of user collection
        // final data = doc.data() as Map<String, dynamic>;
        /* Fields:
             *      1. <Ex 1>
             *      2. <Ex 2>
             *      3. CreateDate
             */
        _workouts = []; // reset _workouts
        for (DocumentSnapshot doc in res.docs) {
          final data = doc.data() as Map<String, dynamic>;
          List<Exercise> exercises = []; // create exercise list for a workout
          for (final exerciseName in data.keys) {
            if (exerciseName == 'CreateDate') continue;
            // otherwise assume the field is an exercise data
            Exercise exercise = Exercise(exerciseName); // create an exercise
            for (final set in data[exerciseName]) {
              exercise.addSet(set['weight'], set['reps']);
            }
            exercises.add(exercise);
          }
          final createDate = DateTime.fromMillisecondsSinceEpoch(
                  data['CreateDate'].millisecondsSinceEpoch)
              .toLocal()
              .toString();
          final workout = Workout(createDate: createDate, exercises: exercises,);
          _workouts.add(workout);
        }
        log(_workouts.toString());
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      workoutQueryStream() {
    log("Downloading user's workout data from firebase");
    String uid = FirebaseAuth.instance.currentUser!.uid;
    if (uid == null) return null;
    String workoutCollectionName = "Workout_${uid}";
    return userCollectionRef
        .doc(uid)
        .collection("Workout")
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
