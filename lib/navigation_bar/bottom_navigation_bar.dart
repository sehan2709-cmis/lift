import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lift/state_management/NavigationState.dart';
import 'package:provider/provider.dart';

class BNavigationBar extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    NavigationState navigationState = Provider.of<NavigationState>(context);
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
          switch(index) {
            case 0: // home
              Navigator.of(context).popAndPushNamed('/');
              break;
            case 1: // data
              Navigator.of(context).popAndPushNamed('/datapage');
              break;
            case 2: // ranking
              break;
            case 3: // profile
              Navigator.of(context).popAndPushNamed('/profile');
              break;
          }
        }
    );
  }
}