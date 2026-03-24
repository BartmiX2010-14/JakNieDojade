import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static const String _historyKey = 'message_history';
  static const String _statsKey = 'user_stats';

  Future<void> saveMessageToHistory(String message) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_historyKey) ?? [];
    
    final newItem = jsonEncode({
      'msg': message,
      'date': DateTime.now().toIso8601String(),
    });
    
    history.insert(0, newItem);
    if(history.length > 50) history.removeLast(); // Keep last 50
    
    await prefs.setStringList(_historyKey, history);
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_historyKey) ?? [];
    return history.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  Future<void> deleteMessageFromHistory(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_historyKey) ?? [];
    if (index >= 0 && index < history.length) {
      history.removeAt(index);
      await prefs.setStringList(_historyKey, history);
    }
  }

  Future<void> incrementActionStat(String action) async {
    final prefs = await SharedPreferences.getInstance();
    String statsJson = prefs.getString(_statsKey) ?? '{}';
    Map<String, dynamic> stats = jsonDecode(statsJson);
    
    stats[action] = (stats[action] ?? 0) + 1;
    await prefs.setString(_statsKey, jsonEncode(stats));
  }
}
