import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class PetState extends ChangeNotifier {
  static const int MAX_HEALTH = 100;
  static const int MAX_TANK_LEVEL = 3;

  int _health = MAX_HEALTH;
  int _tankLevel = 0;
  // late Timer _timer;
  // Duration updateDuration = Duration(minutes: 1); // Adjustable duration

  PetState() {
    _health = MAX_HEALTH;
    _tankLevel = 0;
    // _startTimer();
    _loadState();
  }

  int get health => _health;
  int get tankLevel => _tankLevel;

  // void _startTimer() {
  //   _timer = Timer.periodic(updateDuration, (timer) {
  //     _updateState();
  //   });
  // }

  void _updateState() {
    _loadState(); // Load the latest state
    notifyListeners(); // Notify UI listeners of the change
  }

  void feed(int amount) {
    _health = (_health + amount).clamp(0, MAX_HEALTH);
    notifyListeners(); // Notify UI listeners of the change
    _saveState();
  }

  void cleanTank() {
    if (_tankLevel > 0) {
      _tankLevel--;
    }
    notifyListeners(); // Notify UI listeners of the change
    _saveState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    _health = prefs.getInt('health') ?? MAX_HEALTH;
    _tankLevel = prefs.getInt('tankLevel') ?? 0;
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('health', _health);
    await prefs.setInt('tankLevel', _tankLevel);
  }

// void dispose() {
//   _timer.cancel();
//   super.dispose();
// }
}

