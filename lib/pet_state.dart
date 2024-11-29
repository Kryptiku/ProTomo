import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class PetState {
  static const int MAX_HEALTH = 100;
  static const int MAX_TANK_LEVEL = 3;

  int _health = MAX_HEALTH;
  int _tankLevel = 0;
  late Timer _timer;

  final _healthController = StreamController<Map<String, int>>.broadcast();

  Stream<Map<String, int>> get stateStream => _healthController.stream;

  PetState() {
    _health = MAX_HEALTH;
    _tankLevel = 0;
    _startTimer();
    _loadState();
  }

  int get health => _health;
  int get tankLevel => _tankLevel;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _updateState();
    });
  }

  void _updateState() {
    if (_health > 0) {
      _health -= (_tankLevel == MAX_TANK_LEVEL ? 2 : 1);
      _health = _health.clamp(0, MAX_HEALTH); // Prevent negative health
    }

    if (_tankLevel < MAX_TANK_LEVEL) {
      _tankLevel++;
    }

    _saveState();
    _emitState();
  }

  void _emitState() {
    print("Emitting State -> Health: $_health, Tank Level: $_tankLevel");
    _healthController.add({'health': _health, 'tankLevel': _tankLevel});
  }


  void feed(int amount) {
    _timer.cancel(); // Pause timer during updates
    _health = (_health + amount).clamp(0, MAX_HEALTH);
    _saveState();
    _emitState();
    print('Feeding pet -> New Health: $_health, Tank Level: $_tankLevel');

    // Restart the timer after a delay
    Future.delayed(Duration(seconds: 1), () => _startTimer());
  }




  void cleanTank() {
    if (_tankLevel > 0) {
      _tankLevel--;
    }

    print("Cleaning Tank -> Health: $_health, Tank Level: $_tankLevel");

    _saveState();
    _emitState(); // Ensure state emission is consistent
  }


  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    _health = prefs.getInt('health') ?? MAX_HEALTH;
    _tankLevel = prefs.getInt('tankLevel') ?? 0;

    // Clamp loaded values to avoid invalid data
    _health = _health.clamp(0, MAX_HEALTH);
    _tankLevel = _tankLevel.clamp(0, MAX_TANK_LEVEL);

    print("Loaded State -> Health: $_health, Tank Level: $_tankLevel");
    _emitState(); // Emit loaded state
  }


  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    print("Saving State -> Health: $_health, Tank Level: $_tankLevel");
    await prefs.setInt('health', _health);
    await prefs.setInt('tankLevel', _tankLevel);
  }


  void dispose() {
    _timer.cancel();
    _healthController.close();
  }
}
