class Exercise {
  Exercise(
    this._Name,
  );
  final String _Name;
  final List<Map<String, int>> _Sets = [];
  // _Sets contains
  // [
  //  {"weight":10, "reps":10},
  //  {"weight":10, "reps":10},
  //   ...
  // ]

  String get Name => _Name;
  List<Map<String, int>> get Sets => _Sets;

  Exercise addSet(int weight, int reps) {
    Map<String, int> oneSet = {
      "weight": weight,
      "reps": reps,
    };
    _Sets.add(oneSet);
    return this;
  }

  @override
  String toString(){
    String string = "${Name}\n";
    for(final set in Sets){
      string += "\tweight: ${set["weight"]}";
      string += "\treps: ${set["reps"]}\n";
    }
    return string;
  }

}
