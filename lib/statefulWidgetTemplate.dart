import 'package:flutter/material.dart';

class ClassName extends StatefulWidget {
  const ClassName({super.key, required this.title});
  final String title;

  @override
  State<ClassName> createState() => _ClassNameState();
}

class _ClassNameState extends State<ClassName> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Text("body"),
      ),
      // floatingActionButton:
    );
  }
}
