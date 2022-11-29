import 'dart:async';
import 'dart:collection';
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

  List<Map<String, int>> ranking = [];
  Map<String, List<String>> ranks = {};
  int rankingSize = 0;
  void resetRanks() {
    ranks.clear();
    ranks.addAll({"user":[], "totalVolume":[]});
    rankingSize = 0;
  }

  // LinkedHashMap<String, int> ranking = LinkedHashMap<String, int>();
  FirebaseFirestore? db;
  String? uid;

  WorkoutState() {
    log("Creating WorkoutState");
    init();
  }

  double getTotalVolumeAtDate(String date){
    double totalVolume = 0.0;
    DateTime now = DateTime.parse(date);
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = DateTime(now.year, now.month, now.day+1);

    for(final workout in workouts){
      DateTime workoutDay = DateTime.parse(workout.CreateDate);
      if(workoutDay.isAfter(today) && workoutDay.isBefore(tomorrow)) {
        // log("${today}");
        for(final exercise in workout.exercises){
          for(final set in exercise.Sets){
            totalVolume += set['weight']! * set['reps']!;
            // log("${totalVolume} += ${set['weight']! * set['reps']!} (${set['weight']} * ${set['reps']})");
          }
        }
      }
    }
    return totalVolume;
  }

  void downloadRanking() {
    // reset the outdated ranking
    ranking = [];
    resetRanks();
    db?.collection('Ranking').orderBy('totalVolume', descending: true).get().then(
            (res) {
              if(res.size == 0){
                log("no rankings"); return;
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
                ranks["user"]?.add(doc.id);
                ranks["totalVolume"]?.add(data["totalVolume"].toString());
                log("Ranks :: ${ranks.toString()}");
                rankingSize++;
              }
              notifyListeners();    // after successfully updating, need to notify listening widgets
            }
    );
    // since above operation is asynchronous, notifyListeners() must be called inside
  }

  Future<void> init() async {
    await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform);
    uid = FirebaseAuth.instance.currentUser?.uid;
    db = FirebaseFirestore.instance;
    workoutQueryOnce();
  }


  void addSampleWorkout(){
    for(int i=0; i<5; i++){
      Workout workout = Workout("", []);
      workout.exercises.add(Exercise("Squat").addSet(100, 10).addSet(110, 8).addSet(120, 5));
      workout.exercises.add(Exercise("Bench Press").addSet(80, 10).addSet(70, 12).addSet(60, 16));
      addWorkout(workout);
    }
  }

  void addWorkout(Workout workout) {
    final data = workout.data();
    data["CreateDate"] = FieldValue.serverTimestamp();  // override to server timestamp
    // log(data.toString());
    db?.collection(uid!).add(data);

    // calculate total volume of the day and add it to Rankings collection
    // update ranking data when adding workout
    // for now assume that data added cannot be modified
    int totalVolume = 0;
    for(final exercise in workout.exercises){
      for(final set in exercise.Sets){
        totalVolume += set['weight']! * set['reps']!;
      }
    }
    final rankingRef = db?.collection("Ranking").doc(uid!);
    rankingRef?.get().then(
            (DocumentSnapshot doc) {
              if(!doc.exists){
                // upload new value
                rankingRef.set({
                  "totalVolume": totalVolume
                });
              }
              else{
                totalVolume += doc.get('totalVolume') as int;
                rankingRef.set({
                  "totalVolume": totalVolume
                });
              }
            }
    );
  }

  void workoutQueryOnce() {
    if(uid == null) return;
    log("Trying to get collection of user id: ${uid}");
    db?.collection(uid!).orderBy('CreateDate', descending: true).get().then(
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