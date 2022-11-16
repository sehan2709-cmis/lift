import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'app.dart';


void main() {
  runApp(const App());

  /*WidgetsFlutterBinding.ensureInitialized();

  // runApp(const ShrineApp());

  runApp(
    // StateManagement using Provider class
    // ChangeNotifierProvider is initialized at the root(main) of this application
    // ApplicationState will be available for the entire application
    // Just need put the Widgets inside the Consumer<ApplicationState>'s builder parameter to make it listen to the state changes
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: ((context, child) => const FinalApp()),
    )
  );*/
}