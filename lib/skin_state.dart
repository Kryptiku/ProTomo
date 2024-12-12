import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SkinState extends ChangeNotifier {
  String _defaultSkin = 'assets/axolotl/pinkfloating.png';
  late SharedPreferences _prefs;

  SkinState() {
    _loadSkin();
  }

  String get defaultSkin => _defaultSkin;

  Future<void> _loadSkin() async {
    _prefs = await SharedPreferences.getInstance();
    _defaultSkin = _prefs.getString('selectedSkin') ?? 'assets/axolotl/pinkfloating.png';
    notifyListeners();
  }

  Future<void> changeSkin(String newSkin) async {
    _defaultSkin = newSkin;
    await _prefs.setString('selectedSkin', newSkin);
    notifyListeners();
  }
}