class Exercise {
  Exercise(
    this._Name,
    this._Sets,
  );
  final String _Name;
  final List<Map<String, int>> _Sets;

  String get Name => _Name;
  List<Map<String, int>> get Sets => _Sets;
// weight, reps
}
