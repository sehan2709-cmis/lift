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


  /// {"total
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


  /// change this to download all rankings
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
        /// if nickName exsits, use nickName instead of uid
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
  /// Adding workout could take quite a long time
  void addWorkout(Workout workout) async {
    final data = workout.data();
    String uid = FirebaseAuth.instance.currentUser!.uid;
    // <Map<String, dynamic>>
    DocumentReference userDocRef = userCollectionRef.doc(uid);

    /// upload workout data
    data["CreateDate"] = FieldValue.serverTimestamp(); // set to server timestamp
    // <Map<String, dynamic>>
    DocumentReference addedDocRef = await userDocRef.collection("Workout").add(data);
    
    /// calculate total volume of the workout
    int totalVolume = 0;
    for (final exercise in workout.exercises) {
      for (final set in exercise.Sets) {
        totalVolume += set['weight']! * set['reps']!;
      }
    }

    /// Get timestamp of the added workout
    // <Map<String, dynamic>>
    DocumentSnapshot addedDoc = await userDocRef.collection("Workout").doc(addedDocRef.id).get();
    Timestamp uploadTimeStamp = addedDoc.get("CreateDate"); // this field must exist, since it is just added in the above code
    // DateTime uploadDateTime = DateTime.fromMicrosecondsSinceEpoch(uploadTimeStamp.microsecondsSinceEpoch);
    DateTime uploadDateTime = uploadTimeStamp.toDate();
    log("ADD :: ${uploadDateTime.toString()}");

    /// Update totalVolume
    DocumentSnapshot userDoc = await userDocRef.get();
    try{
      // log("******:${doc.get("totalVolume")}:******");
      totalVolume += userDoc.get('totalVolume') as int;
    }catch(e){
      // log("there is no field");
    }finally{
      /// maybe doesn't really need to wait for finish uploading
      await userDocRef.set({"totalVolume": totalVolume}, SetOptions(merge: true));
    }

    /// Update Workout Dates List
    // manage documents yearly in a WorkoutDays collection
    // add uploadDateTime to the WorkoutDays collection
    final year = uploadDateTime.year;
    final month = uploadDateTime.month;
    final day = uploadDateTime.day;
    // first get data in firestore
    DocumentSnapshot workoutYearDoc = await userDocRef.collection("WorkoutDates").doc("$year").get();
    List<bool> workoutMonth;
    if(!workoutYearDoc.exists) {
      workoutMonth = workoutYearDoc.get("$month");
    }
    else {
      workoutMonth = [];
    }
    while(workoutMonth.length < day){
      workoutMonth.add(false);
    }
    // set the last day (which is today) as true
    workoutMonth.last = true;
    // upload the new workoutDates data
    // merge allow other fields to remain as they are
    await userDocRef.collection("WorkoutDates").doc("$year").set({"$month":workoutMonth}, SetOptions(merge: true));

    /// just search for user workout? (SKIP THIS - this is just an idea)
    // userDocRef.collection("Workout")
    //     .where('CreatedDate', isLessThanOrEqualTo: now)
    //     .where('endDate', isGreaterThanOrEqualTo: now)
    // userDocRef.set({"workoutDates":});

    /// Update Streak
    /// Streak is not updated by adding workouts for the previous dates
    // create "streak" field under user doc
    // streak is added one if last workout date is only one day before today's date
    // else it is reset to zero
    // need to check if last workout date field exists
    Timestamp lastWorkoutTimeStamp;
    label: try{
      lastWorkoutTimeStamp = userDoc.get("lastWorkout");
      DateTime lastWorkoutDateTime = lastWorkoutTimeStamp.toDate();
      DateTime u = DateTime(uploadDateTime.year, uploadDateTime.month, uploadDateTime.day);
      DateTime p = DateTime(uploadDateTime.year, uploadDateTime.month, uploadDateTime.day-1);
      DateTime w = DateTime(lastWorkoutDateTime.year, lastWorkoutDateTime.month, lastWorkoutDateTime.day);
      if(u == w) {
        /// this means that the person workout out more than once at the same day
        /// this neither count nor reset workout streak
        break label;
      }

      if(p == w) {
        /// this means that this user worked out in a row, so add up streak
        // get streak data
        int streak = userDoc.get("streak") as int;
        streak++;
        // update streak data
        userDocRef.set({"streak":streak}, SetOptions(merge: true),);
      }
      /// !!!!!!!!!
      /// 처음에는 여기에서 streak를 초기화 하려고 했는데
      /// 생각해 보니 운동을 안하고 하루가 지나면 자동으로 reset 되도록 해야한다
      /// how to implement this...
      /// server side? (could use firebase functions but this requires upgrading pricing plan)
      // 일단 그래도 reset하기
      userDocRef.set({"streak":0}, SetOptions(merge: true),);
    }catch(e){
      /// lastWorkout field 가 없다는 것은 workout을 처음 등록 했다는 것이고,
      /// 당연히 Streak 값도 없을 것이다
      /// lastWorkout field는 마지막에 업데이트 되니 여기서는 그냥 streak를 1로 만들어준다
      userDocRef.set({"streak":1}, SetOptions(merge: true),);
    }

    /// Update SBD-Max
    // create "sbdMax" field under user doc
    // check if today's workout contains "squat", "bench press", "dead lift"
    // if any one of those exercise exist
    // compare with the server value
    // if it is greater than server value, update server value
    // else leave the value
    Map<String, dynamic> userDocData = userDoc.data() as Map<String, dynamic>;
    userDocData.containsKey("key");


    /// Update last workout date (only 1 workout counted per day)
    // create a field "lastWorkout" under user doc
    // after operating all other workout values, update this value to most recent workout date
    log("WS :: updating lastWorkout");
    userDocRef.set({"lastWorkout":uploadTimeStamp}, SetOptions(merge: true),);
  }

  /// Get workout data of a user once
  /// it downloads all of the user's workout data
  /// currently it download all of the workout data
  /// should modify it to load only the workouts in a given range
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

  /// below function should not be used
  /// not completed
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
