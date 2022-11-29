import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:lift/state_management/NavigationState.dart';
import 'package:lift/state_management/WorkoutState.dart';
import 'package:provider/provider.dart';

import 'navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
                                title: Text('LEG | SQUAT'),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Equpment: Barbell, Rack, Plates'),
                                    SizedBox(height: 10,),
                                    Text('Muscles: Quadriceps, Adductors, Gluteus Maximus, Erector Spinae, Lower Back, Abdominals, Hamstrings, Calves(Gastrocnemius and Soleus)'),
                                    SizedBox(height: 15,),
                                    Image.network('https://cdn.shopify.com/s/files/1/1633/7705/files/what_muscles_do_squats_work_480x480.png?v=1630671679'),
                                    SizedBox(height: 15,),
                                    Text("Insturction: ", style: TextStyle(fontWeight: FontWeight.bold),),
                                    SizedBox(height: 5,),
                                    Text("01. Spread your legs shoulder-width apart and put a barbell over your shoulders behind your neck."),
                                    SizedBox(height: 5,),
                                    Text("02. Sit down while pulling your hips back and keep the tense on your core(abs) to prevent your upper body from leaning forward."),
                                    SizedBox(height: 5,),
                                    Text("03. Maintaining the upper body posture, push the ground with the feet and get up to return to the 1st position."),
                                    SizedBox(height: 10,),
                                    MaterialButton(
                                      shape: OutlineInputBorder(
                                          borderRadius: new BorderRadius.circular(12)
                                      ),
                                      onPressed: () {},
                                      child: Text(
                                        "Search on YouTube",
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
                        IconButton(
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                scrollable: true,
                                title: Text('Pecs | Bench Press'),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Equpment: Barbell, Rack, Plates'),
                                    SizedBox(height: 10,),
                                    Text('Muscles: Pectoralis Major, Sternal Pectoralis Major, Calvicular Deltoid, Anteroir, Triceps Brachii'),
                                    SizedBox(height: 15,),
                                    Image.network('https://www.workoutsprograms.com/media/cache/exercise_375/uploads/exercise/press-pectoral-en-banco-plano-con-barra-agarre-cerrado-muscle-6086%20.png'),
                                    SizedBox(height: 15,),
                                    Text("Insturction: ", style: TextStyle(fontWeight: FontWeight.bold),),
                                    SizedBox(height: 5,),
                                    Text("01. Lay your body on the bench and hold the barbell a little wider than your shoudlers."),
                                    SizedBox(height: 5,),
                                    Text("02. As you feel the relaxation of the chest muscle, lower the barbell toward your chest while bending your arms."),
                                    SizedBox(height: 5,),
                                    Text("03. Feel the chest muscle and push the barbell in the vertically from the floor."),
                                    SizedBox(height: 10,),
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
                        IconButton(
                            onPressed:() => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                scrollable: true,
                                title: Text('Back | Dead Lift'),
                                content: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Equpment: Barbell, Plates'),
                                      SizedBox(height: 10,),
                                      Text('Muscles: Erectors, Multifidus, Glute Maximus, Glute Med/Min(Abductors), Quads, Hamstrings, Adductors (Magnus), Trapezius, Rhomboids, Lats, Posterior Deltoids, Biceps, Forearm Flexors (Grip), Core (Abs, Obliques), Gastroc, Hip Flexors'),
                                      SizedBox(height: 15,),
                                      Image.network('https://e7.pngegg.com/pngimages/237/990/png-clipart-kettlebell-deadlift-muscle-exercise-human-body-pink-sofa-hand-people.png'),
                                      SizedBox(height: 15,),
                                      Text("Insturction: ", style: TextStyle(fontWeight: FontWeight.bold),),
                                      SizedBox(height: 5,),
                                      Text("01. Place both feet slightly narrower than the shoulder-wide, and grip the barbell a little wider than the shoulders. Make sure the knees and arms do not overlap each other."),
                                      SizedBox(height: 5,),
                                      Text("02. While maintanining the upper body position, do not bend your back and lift the barbell as if you are pushing the ground with your feet."),
                                      SizedBox(height: 5,),
                                      Text("03. While keeping your abs tight, attach a barbell to your body when lifing it."),
                                      SizedBox(height: 5,),
                                      Text("04. Fully stretch your body and contract your glute."),
                                      SizedBox(height: 5,),
                                      Text("05. Lower barbell to floor and return to the starting position."),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            ),
                            icon: Icon(Icons.info_outline)
                        ),
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
            )
          ],
        ),
        ]
      ),
      bottomNavigationBar: BNavigationBar(),
    );
  }
}
