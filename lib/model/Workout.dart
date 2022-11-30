import 'dart:developer';
import 'package:lift/model/Exercise.dart';
import 'package:provider/provider.dart';

class Workout {
  Workout({createDate = "", exercises}) {
    this.createDate = createDate;
    if(exercises == null) {
      this.exercises = <Exercise>[];
    }
    else {
      this.exercises = exercises;
    }
  }

  String _createDate = "";
  set createDate(String value) {
    _createDate = value;
  }

  List<Exercise> _exercises = [];
  set exercises(List<Exercise> value) {
    _exercises = value;
  }

  String get createDate => _createDate;
  List<Exercise> get exercises => _exercises;

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
}
