import 'dart:developer';

import 'package:lift/state_management/NavigationState.dart';
import 'package:provider/provider.dart';

import 'navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class Workout extends StatefulWidget {
  @override
  State<Workout> createState() => _Workout();
}

class _Workout extends State<Workout> {
  @override
  Widget build(BuildContext context) {
    NavigationState _navigationState = Provider.of<NavigationState>(context);
    // BNavigationBar nevi = new BNavigationBar();
    return Scaffold(
      appBar: AppBar(
        title: Text("work out"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                        Text("Leg | Barbell Back Squat"),
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
                          filled: true,
                          fillColor: Colors.grey[200],
                          labelText: "add note",
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
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
                            "--Delete set",
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
                            "++Add set",
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
          ],
        ),
      ),
      bottomNavigationBar: BNavigationBar(),
    );
  }
}
