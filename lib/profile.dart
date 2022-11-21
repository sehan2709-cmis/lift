import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lift/state_management/NavigationState.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  late NavigationState _navigationState;

  // // 네비게이션바 UI Widget
  // Widget _navigationBody() {
  //   // switch를 통해 currentPage에 따라 네비게이션을 구동시킨다.
  //   switch (_navigationState.currentPage) {
  //     case 0:
  //       return CountHomeWidget();
  //     case 1:
  //       return ListWidget();
  //   }
  //   return Container();
  // }

  // 네비게이션바 Widget


  @override
  Widget build(BuildContext context) {

    // Provider를 호출해 접근
    _navigationState = Provider.of<NavigationState>(context);

    return Scaffold(
      body: _navigationBody(),
      bottomNavigationBar: _bottomNavigationBarWidget(),
    );
  }
}