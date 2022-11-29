import 'dart:math' as math;
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/material.dart';
import 'package:lift/state_management/WorkoutState.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'navigation_bar/bottom_navigation_bar.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  @override
  Widget build(BuildContext context) {
    // WorkoutState workoutState = Provider.of<WorkoutState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Data"),
      ),
      body: SafeArea(
        child: ListView(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          children: [

            Padding(
              padding: EdgeInsets.all(10),
              child: Consumer<WorkoutState>(
                builder: (BuildContext context, workoutState, Widget? child) {
                  /**
                   * range는 오늘을 포함해서 가져올 최대 과거 날짜를 의미한다
                   */
                  int range = 7;
                  /**
                   * Graph와 관련된 List는 과거->현재 순으로 데이터가 들어가 있어야 한다
                   */
                  List<double> data = [];
                  List<String> labelX = []; // date
                  List<String> labelY = []; // volume
                  
                  DateTime now = DateTime.now();

                  double maxVolume = 0;
                  for(int i=range-1; i>=0; i--){
                    DateTime date = DateTime(now.year, now.month, now.day-i);
                    final dateString = DateFormat("yyyy-MM-dd").format(date);
                    labelX.add(DateFormat('M/d').format(date).replaceAll('/', '/\n'));
                    double volumeAtDate = workoutState.getTotalVolumeAtDate(dateString);
                    data.add(volumeAtDate);
                    maxVolume = math.max(volumeAtDate, maxVolume);
                  }
                  for(int i=1; i<=data.length; i++){
                    double number = (maxVolume*(0.2*i));
                    if(number >= 1000){
                      number /= 1000;
                      /**
                       * totalVolume은 뒤에 K를 붙여 1000단위로 보여준다
                       */
                      labelY.add("${number.toStringAsPrecision(2)}K");
                    }
                    else {
                      labelY.add("${number.toInt()}");
                    }

                  }
                  // normalize data
                  for(int i=0; i<data.length; i++){
                     data[i] /= maxVolume;
                  }
                  // log("length of labelY [] is ${data.length}");

                  // final totalVolumeOfDay = workoutState.workouts.
                  // Timestamp.now() < Timestamp.fromDate(DateTime.parse(formattedString))

                  return LineGraph(
                    features: [
                      Feature(
                        title: "Total Volume",
                        color: Colors.deepPurpleAccent,
                        data: data,
                      ),
                    ],
                    size: Size(400, 400),
                    labelX: labelX,
                    labelY: labelY,
                    showDescription: true,
                    graphColor: Colors.black,
                    graphOpacity: 0.2,
                    verticalFeatureDirection: true,
                    descriptionHeight: 130,
                  );
                },
              ),
            ),
            
          ],
        )
      ),
      bottomNavigationBar: BNavigationBar(),
    );
  }
}
