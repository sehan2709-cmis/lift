import 'package:flutter/cupertino.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }


  User? _user;
  User? get user => _user;


  Future<void> init() async {

  }
}