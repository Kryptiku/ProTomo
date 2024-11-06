import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import firebase_core for initialization
import 'package:protomo/pages/focus_mode.dart';
import 'package:protomo/pages/home.dart';
import 'package:protomo/pages/loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/': (context) => Loading(),
      '/home': (context) => Home(),
      '/focus': (context) => FocusMode(),
    },
  ));
}
