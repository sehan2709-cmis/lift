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
      builder: ((context, child) => const App()),
    )
  );
}