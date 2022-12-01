import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lift/state_management/NavigationState.dart';
import 'package:provider/provider.dart';

import '../state_management/GalleryState.dart';

class BNavigationBar extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    NavigationState navigationState = Provider.of<NavigationState>(context);
    GalleryState simpleGalleryState = Provider.of<GalleryState>(context, listen: false);

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
            icon: Icon(Icons.fitness_center),
            label: "work out",
          ),
        ],
        currentIndex: navigationState.currentPage,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          log("navigation $index is pressed!");
          navigationState.updateCurrentPage(index);
          switch(index) {
            case 0: // home
              simpleGalleryState.readGallery();
              Navigator.of(context).popAndPushNamed('/');
              break;
            case 1: // data
              Navigator.of(context).popAndPushNamed('/datapage');
              break;
            case 2: // ranking
              Navigator.of(context).popAndPushNamed('/ranking');
              break;
            case 3: // profile
              Navigator.of(context).popAndPushNamed('/workout');
              break;
          }
        }
    );
  }
}