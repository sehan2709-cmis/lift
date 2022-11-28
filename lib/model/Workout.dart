import 'dart:developer';
import 'package:lift/model/Exercise.dart';
import 'package:provider/provider.dart';

class Workout {
  Workout(this._CreateDate, this._exercises);

  final String _CreateDate;
  final List<Exercise> _exercises;

  String get CreateDate => _CreateDate;
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
    String string = "Date: ${CreateDate}\n";
    for(final exercise in exercises){
      string += "${exercise.toString()}";
    }
    return string;
  }
}
