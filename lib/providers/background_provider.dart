import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundProvider extends ChangeNotifier {
  String _selectedBackground = 'PineForestParallax';

  String get selectedBackground => _selectedBackground;

  Future<void> loadBackground() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedBackground = prefs.getString('selectedBackground') ?? 'PineForestParallax';
    notifyListeners();
  }

  Future<void> setBackground(String background) async {
    _selectedBackground = background;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedBackground', background);
    notifyListeners();
  }
} 