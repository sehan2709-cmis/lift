import 'package:flutter/material.dart';

class PoseDetectionPage extends StatefulWidget {
  const PoseDetectionPage({super.key});

  @override
  State<PoseDetectionPage> createState() => _PoseDetectionPageState();
}

class _PoseDetectionPageState extends State<PoseDetectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title"),
      ),
      body: SafeArea(
        child: Text("body"),
      ),
      // floatingActionButton:
    );
  }
}
