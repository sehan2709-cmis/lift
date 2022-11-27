import 'package:lift/model/Exercise.dart';

class Workout {
  Workout(
    this._CreateDate,
    this._Exercises,
  );
  final String _CreateDate;
  final List<Exercise> _Exercises;

  String get CreateDate => _CreateDate;
  List<Exercise> get Exercises => _Exercises;
}
