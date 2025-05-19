import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicProvider extends ChangeNotifier {
  bool _isMusicMuted = false;
  bool _jumpSoundEnabled = true;

  bool get isMusicMuted => _isMusicMuted;
  bool get jumpSoundEnabled => _jumpSoundEnabled;

  Future<void> loadMusicSetting() async {
    final prefs = await SharedPreferences.getInstance();
    _isMusicMuted = prefs.getBool('isMusicMuted') ?? false;
    print('MusicProvider: loadMusicSetting, isMusicMuted=$_isMusicMuted');
    notifyListeners();
  }

  Future<void> setMusicMuted(bool value) async {
    print('MusicProvider: setMusicMuted called with value=$value');
    _isMusicMuted = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isMusicMuted', value);
    notifyListeners();
  }

  Future<void> loadJumpSoundSetting() async {
    final prefs = await SharedPreferences.getInstance();
    _jumpSoundEnabled = prefs.getBool('jumpSoundEnabled') ?? true;
    notifyListeners();
  }

  Future<void> setJumpSoundEnabled(bool value) async {
    _jumpSoundEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('jumpSoundEnabled', value);
    notifyListeners();
  }
} 