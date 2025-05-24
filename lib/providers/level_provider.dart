import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LevelProvider extends ChangeNotifier {
  String _selectedLevel = 'easy';

  String get selectedLevel => _selectedLevel;

  Future<void> loadLevel() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedLevel = prefs.getString('selectedLevel') ?? 'easy';
    notifyListeners();
  }

  Future<void> setLevel(String level) async {
    _selectedLevel = level;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLevel', level);
    notifyListeners();
  }
} 