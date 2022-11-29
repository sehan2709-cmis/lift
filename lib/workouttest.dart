import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:lift/model/Exercise.dart';
import 'package:lift/model/Workout.dart';
import 'package:lift/state_management/NavigationState.dart';
import 'package:lift/state_management/WorkoutState.dart';
import 'package:provider/provider.dart';

import 'navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkoutTest extends StatefulWidget {
  @override
  State<WorkoutTest> createState() => _WorkoutTest();
}

List<Exercise> todayWorkout = [];
Workout workout = Workout("", []);

class _WorkoutTest extends State<WorkoutTest> {
  final addWorkout = TextEditingController();

  @override
  void dispose() {
    addWorkout.dispose();
    super.dispose();
  }
  List<Row> _buildSet(Exercise exercise){
    int count = 1;
    if (exercise.Sets.isEmpty) {
      return const <Row>[];
    }

    return exercise.Sets.map((set){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("${count++}"),
          SizedBox(
            width: 70,
            height: 30,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "kg",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            width: 70,
            height: 30,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "reps",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(onPressed: (){
            set['weight'] = 23;
            set['reps'] = 30;
          }, icon: Icon(Icons.check_box)),
        ],
      );
    }).toList();
  }

  List<Card> _buildCards(BuildContext context) {
    if (workout.exercises.isEmpty) {
      return const <Card>[];
    }

    return workout.exercises.map((exercise) {
      return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)
        ),
        elevation: 6.0,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          scrollable: true,
                          title: Text('${exercise.Name}'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Work Out Name: ${exercise.Name}'),
                              SizedBox(height: 10,),
                              MaterialButton(
                                shape: OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(12)
                                ),
                                onPressed: () {},
                                child: Text(
                                  "Search on Google",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      ),
                      icon: Icon(Icons.info_outline)),
                  Text(exercise.Name),
                  IconButton(
                      onPressed: (){
                        setState(() {
                          workout.exercises.remove(exercise);
                        });
                      },
                      icon: Icon(CupertinoIcons.trash)),
                ],
              ),
              Divider(thickness: 2,),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("set"), Text("kg"), Text("reps"), Text("done"),
                ],
              ),
              Column(
                children: _buildSet(exercise),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    shape: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(12)
                    ),
                    onPressed: () {
                      setState(() {
                        exercise.Sets.removeLast();
                      });
                    },
                    child: Text(
                      "--set",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),

                  ),//--set
                  MaterialButton(
                    shape: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(12)
                    ),
                    onPressed: () {
                      setState(() {
                        exercise.addSet(0, 0);
                      });
                    },
                    child: Text(
                      "++set",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),//++set
                ],
              )//++set--
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget build(BuildContext context) {
    NavigationState _navigationState = Provider.of<NavigationState>(context);
    WorkoutState _workout = Provider.of<WorkoutState>(context);
    // BNavigationBar nevi =

    // List<Widget> squatrow = new List.generate(_squatset, (int i) => new ContactRow());

    return Scaffold(
      appBar: AppBar(
        title: Text("work out"),
        elevation: 6.0,
      ),
      body: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                Column(
                  children: _buildCards(context),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                        color: Colors.grey[200],
                        shape: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(12)
                        ),
                        onPressed: () {},
                        child: Icon(CupertinoIcons.timer)
                    ),
                    MaterialButton(
                      color: Colors.grey[200],
                      shape: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(12)
                      ),
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          scrollable: true,
                          title: Text('Add Workout'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Exercise Name: '),
                              SizedBox(height: 10,),
                              TextField(
                                controller: addWorkout,
                              )
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'CANCEL'),
                              child: const Text('CANCEL'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  workout.exercises.add(Exercise(addWorkout.text));
                                });
                                Navigator.pop(context, 'ADD');
                              },
                              child: const Text('ADD'),
                            ),
                          ],
                        ),
                      ),
                      child: Text(
                        "ADD WORKOUT",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text(" | ", style: TextStyle(fontSize: 25),),
                    MaterialButton(
                      color: Colors.blue,
                      shape: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(12)
                      ),
                      onPressed: () {
                        _workout.addSampleWorkout();
                      },
                      child: Text(
                        "FINISH",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                )//bottom buttons
              ],
            ),
          ]
      ),
      bottomNavigationBar: BNavigationBar(),
    );
  }
}
