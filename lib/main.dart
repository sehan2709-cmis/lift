import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'model/ApplicationState.dart';


void main() {
  // runApp(const App());

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
   ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      // if App() is set to const, then ApplicationStete() init() is not passed on... why?
      builder: ((context, child) => App()),
    )
  );
}