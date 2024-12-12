import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:protomo/pages/focus_mode.dart';
import 'package:protomo/pages/home.dart';
import 'package:protomo/pages/login.dart';
import 'package:protomo/pages/register.dart';
import 'package:protomo/pages/start.dart';
import 'pet_state.dart';
import 'skin_state.dart'; // Import the new SkinState class
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case 'updatePetState':
        await _updatePetStateInBackground();
        break;
    }
    return Future.value(true);
  });
}

Future<void> _updatePetStateInBackground() async {
  final prefs = await SharedPreferences.getInstance();
  int health = prefs.getInt('health') ?? PetState.MAX_HEALTH;
  int tankLevel = prefs.getInt('tankLevel') ?? 0;

  // Update health
  if (health > 0) {
    health -= tankLevel == PetState.MAX_TANK_LEVEL ? 2 : 1;
  }

  // Update tank level
  if (tankLevel < PetState.MAX_TANK_LEVEL) {
    tankLevel++;
  }

  // Save updated values
  await prefs.setInt('health', health);
  await prefs.setInt('tankLevel', tankLevel);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Workmanager
  await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true
  );

  // Schedule periodic task
  await Workmanager().registerPeriodicTask(
    "1",
    "updatePetState",
    frequency: Duration(minutes: 15),
    constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PetState()),
        ChangeNotifierProvider(
          create: (context) => SkinState(),
          lazy: false,
        ), // Add SkinState provider
      ],
      child: MaterialApp(
        home: AuthCheck(),
        routes: {
          '/start': (context) => StartPage(),
          '/home': (context) => Home(),
          '/focus': (context) => TimerKnob(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterScreen(),
        },
      ),
    ),
  );
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return StartPage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}