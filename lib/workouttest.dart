import 'dart:developer';

import 'package:collection/collection.dart';
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
Workout workout = Workout();
List<TextEditingController> weightControl = [];
List<TextEditingController> repsControl = [];

class _WorkoutTest extends State<WorkoutTest> {
  final addWorkout = TextEditingController();

  @override
  void dispose() {
    addWorkout.dispose();
    super.dispose();
  }
  List<Row> _buildSet(Exercise exercise, List<TextEditingController> weightControl, List<TextEditingController> repsControl){
    print("wieghtControl length = ${weightControl.length}, repsControl length = ${repsControl.length}");
    int count = 0;
    if (exercise.Sets.isEmpty) {
      return const <Row>[];
    }

    return exercise.Sets.map((set){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("${++count}"),
          SizedBox(
            width: 70,
            height: 30,
            child: TextFormField(
              controller: weightControl[count-1],
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
              controller: repsControl[count-1],
              decoration: InputDecoration(
                labelText: "reps",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(onPressed: (){
            try { //현제 count-1 을 해서 다른 check 버튼을 눌러도 마지막 값이 출력되는 상황.
              set['weight'] = int.parse(weightControl[count-1].text); //Exercise에 index 추가해야함
              set['reps'] = int.parse(repsControl[count-1].text);//Exercise에 index 추가해야함
              print("weight: ${weightControl[count-1].text}, reps: ${repsControl[count-1].text}");
            }
            catch(e) {
              print(e);
            }
          }, icon: Icon(Icons.check_box)),
        ],
      );
    }).toList();
  }//운동별 세트

  List<Widget> _buildCards(BuildContext context) {

    if (workout.exercises.isEmpty) {
      return const <Card>[];
    }

    return workout.exercises.map((exercise) {
      return Column(
        children: [
          Card(
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
                                  MaterialButton( //search on color
                                    shape: OutlineInputBorder(
                                        borderRadius: new BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Color(0xFF545454)),
                                    ),
                                    onPressed: () {},
                                    child: Container(
                                      child: RichText(
                                        text: const TextSpan(children:[
                                          TextSpan(
                                            text: 'Search on ',
                                            style: TextStyle(color: Color(0xFF9B9B9B)),
                                          ),
                                          TextSpan(
                                            text: 'G',
                                            style: TextStyle(color: Color(0xFF176BEF)),
                                          ),
                                          TextSpan(
                                            text: 'o',
                                            style: TextStyle(color: Color(0xFFFF3E30)),
                                          ),
                                          TextSpan(
                                            text: 'o',
                                            style: TextStyle(color: Color(0xFFF7B529)),
                                          ),
                                          TextSpan(
                                            text: 'g',
                                            style: TextStyle(color: Color(0xFF176BEF)),
                                          ),
                                          TextSpan(
                                            text: 'l',
                                            style: TextStyle(color: Color(0xFF129C52)),
                                          ),
                                          TextSpan(
                                            text: 'e',
                                            style: TextStyle(color: Color(0xFFFF3E30)),
                                          ),
                                        ]
                                        ),//google with color
                                      ),
                                    ), //search google pretty colors
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
                  ),//top part
                  Divider(thickness: 2,),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("set"), Text("kg"), Text("reps"), Text("done"),
                    ],
                  ), //number weight reps check buttons
                  Column(
                    children: _buildSet(exercise, weightControl, repsControl),
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
                            weightControl.removeLast();
                            repsControl.removeLast();
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
                            print("1");
                            exercise.addSet(0, 0);
                            weightControl.add(TextEditingController());
                            repsControl.add(TextEditingController());
                            print("2");
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
          ),
          SizedBox(height: 20,)
        ],
      );
    }).toList();
  }//운동 이름

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
