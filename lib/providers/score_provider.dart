import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreProvider extends ChangeNotifier {
  int _score = 0;
  int _highScore = 0;

  int get score => _score;
  int get highScore => _highScore;

  Future<void> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    _highScore = prefs.getInt('highScore') ?? 0;
    notifyListeners();
  }

  Future<void> saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highScore', _highScore);
  }

  void setScore(int value) {
    _score = value;
    if (_score > _highScore) {
      _highScore = _score;
      saveHighScore();
    }
    notifyListeners();
  }

  void resetScore() {
    _score = 0;
    notifyListeners();
  }
} 