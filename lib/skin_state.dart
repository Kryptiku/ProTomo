import 'package:flutter/material.dart';

class SkinState with ChangeNotifier {
  String _defaultSkin = 'assets/axolotl/pinkfloating.png'; // Initial value

  String get defaultSkin => _defaultSkin;

  void updateSkin(String newSkin) {
    _defaultSkin = newSkin;
    notifyListeners(); // Notify listeners to rebuild widgets
  }
}
