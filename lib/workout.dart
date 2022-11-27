import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:lift/state_management/NavigationState.dart';
import 'package:provider/provider.dart';

import 'navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class Workout extends StatefulWidget {
  @override
  State<Workout> createState() => _Workout();
}

class _Workout extends State<Workout> {
  int _squatset = 1;
  int _benchset = 1;
  int _deadset = 1;

  @override

  Widget build(BuildContext context) {
    NavigationState _navigationState = Provider.of<NavigationState>(context);
    // BNavigationBar nevi =

    List<Widget> squatrow = new List.generate(_squatset, (int i) => new ContactRow());

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
                        IconButton(onPressed: (){}, icon: Icon(Icons.info_outline)),
                        Text("Leg | Squat"),
                        OutlinedButton(
                          onPressed: () {},
                          child: Text('Records'),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "add note",
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text("set"), Text("kg"), Text("reps"), Text("done"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: (){} ,
                            child: Text("1")),
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
                        IconButton(onPressed: (){}, icon: Icon(Icons.check_box)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          shape: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(12)
                          ),
                          onPressed: () {},
                          child: Text(
                            "--set",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),

                        ),
                        MaterialButton(
                          shape: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(12)
                          ),
                          onPressed: () {},
                          child: Text(
                            "++set",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
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
                        IconButton(onPressed: (){}, icon: Icon(Icons.info_outline)),
                        Text("Pecs | Bench Press"),
                        OutlinedButton(
                          onPressed: () {},
                          child: Text('Records'),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "add note",
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text("set"),
                        Text("kg"),
                        Text("reps"),
                        Text("done"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("1"),
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
                        IconButton(onPressed: (){}, icon: Icon(Icons.check_box)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          shape: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(12)
                          ),
                          onPressed: () {},
                          child: Text(
                            "--set",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),

                        ),
                        MaterialButton(
                          shape: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(12)
                          ),
                          onPressed: () {},
                          child: Text(
                            "++set",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
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
                        IconButton(onPressed: (){}, icon: Icon(Icons.info_outline)),
                        Text("Back | Dead Lift"),
                        OutlinedButton(
                          onPressed: () {},
                          child: Text('Records'),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "add note",
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text("set"),
                        Text("kg"),
                        Text("reps"),
                        Text("done"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("1"),
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
                        IconButton(onPressed: (){}, icon: Icon(Icons.check_box)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          shape: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(12)
                          ),
                          onPressed: () {},
                          child: Text(
                            "--set",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        MaterialButton(
                          shape: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(12)
                          ),
                          onPressed: () {},
                          child: Text(
                            "++set",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
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
                  onPressed: () {},
                  child: Text(
                    "START",
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
                  onPressed: () {},
                  child: Text(
                    "FINISH",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        ]
      ),
      bottomNavigationBar: BNavigationBar(),
    );
  }
}
