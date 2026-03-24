import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfileProvider with ChangeNotifier {
  int _generatedCount = 0;
  int _lateCount = 0;
  int _cancelCount = 0;
  String _aiPersonality = 'Przyjazny kumpel';
  String _themeMode = 'Automatyczny';
  
  // Nowe pola v7.0
  String _gender = 'Nie wybrano';
  String _userBio = '';
  String _apiKey = ''; 

  int get generatedCount => _generatedCount;
  int get lateCount => _lateCount;
  int get cancelCount => _cancelCount;
  String get aiPersonality => _aiPersonality;
  String get themeMode => _themeMode;
  String get gender => _gender;
  String get userBio => _userBio;
  String get apiKey => _apiKey;

  static const String _statsKey = 'profile_stats';
  static const String _settingsKey = 'profile_settings';

  ProfileProvider() {
    _loadAll();
  }

  Future<void> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = prefs.getString(_statsKey);
    if (statsJson != null) {
      final stats = jsonDecode(statsJson);
      _generatedCount = stats['generated'] ?? 0;
      _lateCount = stats['late'] ?? 0;
      _cancelCount = stats['cancel'] ?? 0;
    }
    final settingsJson = prefs.getString(_settingsKey);
    if (settingsJson != null) {
      final settings = jsonDecode(settingsJson);
      _aiPersonality = settings['personality'] ?? 'Przyjazny kumpel';
      _themeMode = settings['theme'] ?? 'Automatyczny';
      _gender = settings['gender'] ?? 'Nie wybrano';
      _userBio = settings['userBio'] ?? '';
      _apiKey = settings['apiKey'] ?? '';
    }
    notifyListeners();
  }

  Future<void> _saveStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_statsKey, jsonEncode({
      'generated': _generatedCount,
      'late': _lateCount,
      'cancel': _cancelCount,
    }));
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode({
      'personality': _aiPersonality,
      'theme': _themeMode,
      'gender': _gender,
      'userBio': _userBio,
      'apiKey': _apiKey,
    }));
  }

  Future<void> incrementGenerated() async {
    _generatedCount++;
    await _saveStats();
    notifyListeners();
  }

  Future<void> incrementLate() async {
    _lateCount++;
    await _saveStats();
    notifyListeners();
  }

  Future<void> incrementCancel() async {
    _cancelCount++;
    await _saveStats();
    notifyListeners();
  }

  Future<void> setAiPersonality(String personality) async {
    _aiPersonality = personality;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setThemeMode(String mode) async {
    _themeMode = mode;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setGender(String gender) async {
    _gender = gender;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setUserBio(String bio) async {
    _userBio = bio;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setApiKey(String key) async {
    _apiKey = key;
    await _saveSettings();
    notifyListeners();
  }
}
