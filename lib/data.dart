import 'package:flutter/material.dart';

import 'navigation_bar/bottom_navigation_bar.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data"),
      ),
      body: SafeArea(
        child: Text("body"),
      ),
      bottomNavigationBar: BNavigationBar(),
    );
  }
}
