import 'dart:developer';
import 'package:lift/model/Exercise.dart';
import 'package:provider/provider.dart';

class Workout {
  Workout({docId, createDate, exercises}) {
    if(docId != null) {
      this.docId = docId;
    } /// optional
    /// when adding workout offline, this parameter is not required

    if(createDate != null) {
      this.createDate = createDate;
    }
    // if null just leave it as default value which is DateTime.now()

    if(exercises == null) {
      this.exercises = <Exercise>[];
    }
    else {
      this.exercises = exercises;
    }
  }

  DateTime? createDate = DateTime.now();
  String docId = "";
  List<Exercise> get exercises => _exercises;

  List<Exercise> _exercises = [];
  set exercises(List<Exercise> value) {
    _exercises = value;
  }



  Map<String, dynamic> data(){
    Map<String, dynamic> data = {};
    for(final exercise in exercises){
      data[exercise.Name] = exercise.Sets;
    }
    return data;
  }

  /*
  if (createDate is String) {
      _CreateDate = createDate;
    } else if (createDate is int) {
      _CreateDate =
          DateTime.fromMillisecondsSinceEpoch(createDate).toLocal().toString();
    } else {
      log("undefined type for CreateDate field in Workout model");
    }
  */
  @override
  String toString(){
    String string = "Date: ${createDate}\n";
    for(final exercise in exercises){
      string += "${exercise.toString()}";
    }
    return string;
  }

  String toWorkoutOnlyString(){
    String string = "";
    for(final exercise in exercises){
      string += "${exercise.toString()}";
    }
    return string;
  }
}
