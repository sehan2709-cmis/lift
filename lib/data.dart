import 'dart:math' as math;
import 'dart:developer';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
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

/// should I move this to a provider?
List<DateTime?> dateRange = [];

/// for expansion pannel
// stores ExpansionPanel state information
class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}

class _DataPageState extends State<DataPage> {
  final List<Item> _data = generateItems(8);

  // to build expansion panel items
  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: ListTile(
              title: Text(item.expandedValue),
              subtitle:
              const Text('To delete this panel, tap the trash can icon'),
              trailing: const Icon(Icons.delete),
              onTap: () {
                setState(() {
                  _data.removeWhere((Item currentItem) => item == currentItem);
                });
              }),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }

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
          // 1. Calendar
          CalendarDatePicker2(
            config: CalendarDatePicker2Config(
              calendarType: CalendarDatePicker2Type.range,
            ),
            onValueChanged: (dates){
              // Selecting date will trigger screen rebuild
              // re-building screen will cause the selected date to disappear
              // therefore can't use setState() in here
              // setState(() {});
              dateRange = dates;
              log("DATA :: ${dateRange.toString()}");
            },
            /// initial value should be past 7 days from today
            initialValue: [],
          ),

          // 2. Graph
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
                for (int i = range - 1; i >= 0; i--) {
                  DateTime date = DateTime(now.year, now.month, now.day - i);
                  final dateString = DateFormat("yyyy-MM-dd").format(date);
                  labelX.add(
                      DateFormat('M/d').format(date).replaceAll('/', '/\n'));
                  double volumeAtDate =
                      workoutState.getTotalVolumeAtDate(dateString);
                  data.add(volumeAtDate);
                  maxVolume = math.max(volumeAtDate, maxVolume);
                }
                for (int i = 1; i <= data.length; i++) {
                  double number = (maxVolume * (0.2 * i));
                  if (number >= 1000) {
                    number /= 1000;
                    /**
                       * totalVolume은 뒤에 K를 붙여 1000단위로 보여준다
                       */
                    labelY.add("${number.toStringAsPrecision(2)}K");
                  } else {
                    labelY.add("${number.toInt()}");
                  }
                }
                // normalize data
                for (int i = 0; i < data.length; i++) {
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
          // 3. Exercise
          _buildPanel(),
        ],
      )),
      bottomNavigationBar: BNavigationBar(),
    );
  }
}
