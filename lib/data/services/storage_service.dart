import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageKeys {
  static const profile = 'mama_profile';
  static const feeding = 'mama_feeding';
  static const mood = 'mama_mood';
  static const sleep = 'mama_sleep';
  static const exercise = 'mama_exercise';
  static const water = 'mama_water';
  static const meals = 'mama_meals';
  static const weight = 'mama_weight';
  static const reminders = 'mama_reminders';
  static const theme = 'mama_theme';
  static const role = 'mama_role';
  static const pairCode = 'mama_pair_code';
  static const pro = 'mama_pro';
  static const language = 'mama_lang';
  static const milestones = 'mama_milestones';

  static const all = <String>[
    profile,
    feeding,
    mood,
    sleep,
    exercise,
    water,
    meals,
    weight,
    reminders,
    theme,
    role,
    pairCode,
    pro,
    language,
    milestones,
  ];
}

class StorageService {
  StorageService(this._prefs);

  final SharedPreferences _prefs;

  static Future<StorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  String? readString(String key) => _prefs.getString(key);

  Future<void> writeString(String key, String value) =>
      _prefs.setString(key, value);

  Future<void> remove(String key) => _prefs.remove(key);

  T? readJson<T>(String key, T Function(dynamic) decoder) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      return decoder(jsonDecode(raw));
    } catch (_) {
      return null;
    }
  }

  Future<void> writeJson(String key, Object value) {
    return _prefs.setString(key, jsonEncode(value));
  }

  bool readBool(String key, {bool fallback = false}) =>
      _prefs.getBool(key) ?? fallback;

  Future<void> writeBool(String key, bool value) =>
      _prefs.setBool(key, value);

  Future<void> clearAllAppKeys() async {
    for (final k in StorageKeys.all) {
      await _prefs.remove(k);
    }
  }

  Future<void> importDump(Map<String, dynamic> dump) async {
    for (final entry in dump.entries) {
      if (!StorageKeys.all.contains(entry.key)) continue;
      final v = entry.value;
      if (v is String) {
        await _prefs.setString(entry.key, v);
      } else if (v is bool) {
        await _prefs.setBool(entry.key, v);
      } else {
        await _prefs.setString(entry.key, jsonEncode(v));
      }
    }
  }

  Map<String, dynamic> exportDump() {
    final out = <String, dynamic>{};
    for (final k in StorageKeys.all) {
      if (!_prefs.containsKey(k)) continue;
      final v = _prefs.get(k);
      if (v is String) {
        try {
          out[k] = jsonDecode(v);
        } catch (_) {
          out[k] = v;
        }
      } else if (v != null) {
        out[k] = v;
      }
    }
    return out;
  }
}
