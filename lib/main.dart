import 'package:flutter/material.dart';
import 'package:protomo/dbtest.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart'; // Import firebase_core for initialization
import 'package:protomo/pages/focus_mode.dart';
import 'package:protomo/pages/home.dart';
import 'package:protomo/pages/loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // try {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  //   print("Firebase initialized successfully!");
  // } catch (e) {
  //   print("Firebase initialization error: $e");
  // }
  // final test = FirestoreTest();
  // test.testAddData();

  // final firestoreTest = FirestoreTest();
  // firestoreTest.testConnection();

  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/': (context) => Loading(),
      '/home': (context) => Home(),
      '/focus': (context) => FocusMode(),
    },
  ));
}
