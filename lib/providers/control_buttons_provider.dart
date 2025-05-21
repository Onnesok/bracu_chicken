import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ControlButtonsProvider extends ChangeNotifier {
  bool jumpEnabled = true;
  bool leftEnabled = true;
  bool rightEnabled = true;
  bool downEnabled = true;

  // Default positions (as fractions of screen width/height)
  Offset jumpPosition = const Offset(0.88, 0.60);
  Offset leftPosition = const Offset(0.08, 0.82);
  Offset rightPosition = const Offset(0.18, 0.82);
  Offset downPosition = const Offset(0.88, 0.82);

  ControlButtonsProvider() {
    loadPositions();
  }

  Future<void> loadPositions() async {
    final prefs = await SharedPreferences.getInstance();
    jumpPosition = _getOffset(prefs, 'jumpPosition', jumpPosition);
    leftPosition = _getOffset(prefs, 'leftPosition', leftPosition);
    rightPosition = _getOffset(prefs, 'rightPosition', rightPosition);
    downPosition = _getOffset(prefs, 'downPosition', downPosition);
    notifyListeners();
  }

  Future<void> savePositions() async {
    final prefs = await SharedPreferences.getInstance();
    await _setOffset(prefs, 'jumpPosition', jumpPosition);
    await _setOffset(prefs, 'leftPosition', leftPosition);
    await _setOffset(prefs, 'rightPosition', rightPosition);
    await _setOffset(prefs, 'downPosition', downPosition);
  }

  Offset _getOffset(SharedPreferences prefs, String key, Offset fallback) {
    final dx = prefs.getDouble('${key}_dx');
    final dy = prefs.getDouble('${key}_dy');
    if (dx != null && dy != null) {
      return Offset(dx, dy);
    }
    return fallback;
  }

  Future<void> _setOffset(SharedPreferences prefs, String key, Offset value) async {
    await prefs.setDouble('${key}_dx', value.dx);
    await prefs.setDouble('${key}_dy', value.dy);
  }

  void setJumpEnabled(bool value) {
    jumpEnabled = value;
    notifyListeners();
  }

  void setLeftEnabled(bool value) {
    leftEnabled = value;
    notifyListeners();
  }

  void setRightEnabled(bool value) {
    rightEnabled = value;
    notifyListeners();
  }

  void setDownEnabled(bool value) {
    downEnabled = value;
    notifyListeners();
  }

  void setJumpPosition(Offset pos) {
    jumpPosition = pos;
    notifyListeners();
    savePositions();
  }

  void setLeftPosition(Offset pos) {
    leftPosition = pos;
    notifyListeners();
    savePositions();
  }

  void setRightPosition(Offset pos) {
    rightPosition = pos;
    notifyListeners();
    savePositions();
  }

  void setDownPosition(Offset pos) {
    downPosition = pos;
    notifyListeners();
    savePositions();
  }
} 