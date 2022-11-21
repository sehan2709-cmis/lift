import 'dart:developer';

import 'package:flutter/material.dart';

Widget _bottomNavigationBarWidget(navigationState) {
  return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: "data",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.numbers),
          label: "ranking",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "profile",
        ),
      ],
      currentIndex: navigationState.currentPage,
      selectedItemColor: Colors.blue,
      onTap: (index) {
        log("navigation $index is pressed!");
        navigationState.updateCurrentPage(index);
      }
  );
}