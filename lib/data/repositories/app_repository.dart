import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/foundation.dart';

import '../models/exercise_session.dart';
import '../models/feeding_entry.dart';
import '../models/meal_entry.dart';
import '../models/mood_entry.dart';
import '../models/profile.dart';
import '../models/reminder_config.dart';
import '../models/sleep_entry.dart';
import '../models/user_role.dart';
import '../models/water_entry.dart';
import '../models/weight_entry.dart';
import '../services/cloud_sync_service.dart';
import '../services/home_widget_service.dart';
import '../services/storage_service.dart';

/// Single source of truth for app-wide state, backed by SharedPreferences.
/// Extends [ChangeNotifier] so views can rebuild reactively.
class AppRepository extends ChangeNotifier {
  AppRepository(this._storage) {
    _hydrate();
  }

  final StorageService _storage;

  Profile? _profile;
  Profile? get profile => _profile;

  UserRole? _role;
  UserRole? get role => _role;

  String _pairCode = '';
  String get pairCode => _pairCode;

  String? _pairedMomUid;
  String? get pairedMomUid => _pairedMomUid;

  bool _pro = false;
  bool get pro => _pro;

  String _language = 'tr';
  String get language => _language;

  bool _dark = false;
  bool get isDark => _dark;

  List<FeedingEntry> _feedings = [];
  List<FeedingEntry> get feedings => List.unmodifiable(_feedings);

  List<MoodEntry> _moods = [];
  List<MoodEntry> get moods => List.unmodifiable(_moods);

  List<SleepEntry> _sleeps = [];
  List<SleepEntry> get sleeps => List.unmodifiable(_sleeps);

  List<ExerciseSession> _exercises = [];
  List<ExerciseSession> get exercises => List.unmodifiable(_exercises);

  List<WaterEntry> _waters = [];
  List<WaterEntry> get waters => List.unmodifiable(_waters);

  List<MealEntry> _meals = [];
  List<MealEntry> get meals => List.unmodifiable(_meals);

  List<WeightEntry> _weights = [];
  List<WeightEntry> get weights => List.unmodifiable(_weights);

  List<ReminderConfig> _reminders = [];
  List<ReminderConfig> get reminders => List.unmodifiable(_reminders);

  Set<String> _milestones = {};
  Set<String> get milestones => Set.unmodifiable(_milestones);

  void _hydrate() {
    _profile = _storage.readJson(
      StorageKeys.profile,
      (dyn) => Profile.fromJson(dyn as Map<String, dynamic>),
    );
    _role = userRoleFromString(_storage.readString(StorageKeys.role));
    _pairCode = _storage.readString(StorageKeys.pairCode) ?? '';
    _pairedMomUid = _storage.readString('paired_mom_uid');
    _pro = _storage.readBool(StorageKeys.pro);
    _language = _storage.readString(StorageKeys.language) ?? 'tr';
    _dark = _storage.readString(StorageKeys.theme) == 'dark';

    _feedings = _readList(StorageKeys.feeding, FeedingEntry.fromJson);
    _moods = _readList(StorageKeys.mood, MoodEntry.fromJson);
    _sleeps = _readList(StorageKeys.sleep, SleepEntry.fromJson);
    _exercises = _readList(StorageKeys.exercise, ExerciseSession.fromJson);
    _waters = _readList(StorageKeys.water, WaterEntry.fromJson);
    _meals = _readList(StorageKeys.meals, MealEntry.fromJson);
    _weights = _readList(StorageKeys.weight, WeightEntry.fromJson);
    _reminders = _readList(StorageKeys.reminders, ReminderConfig.fromJson);

    if (_reminders.isEmpty) {
      _reminders = defaultReminders();
      _persistReminders();
    }

    final milestonesRaw = _storage.readJson<List<dynamic>>(
      StorageKeys.milestones,
      (dyn) => (dyn as List<dynamic>),
    );
    _milestones = milestonesRaw == null
        ? <String>{}
        : milestonesRaw.cast<String>().toSet();
  }

  List<T> _readList<T>(
    String key,
    T Function(Map<String, dynamic>) decoder,
  ) {
    final raw = _storage.readJson<List<dynamic>>(
      key,
      (dyn) => (dyn as List<dynamic>),
    );
    if (raw == null) return <T>[];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(decoder)
        .toList();
  }

  // ----- Profile -----
  Future<void> saveProfile(Profile p) async {
    _profile = p;
    await _storage.writeJson(StorageKeys.profile, p.toJson());
    _cloudFire((uid) => CloudSyncService.instance.pushProfile(uid, p));
    notifyListeners();
  }

  // ----- Role / pair code -----
  Future<void> setRole(UserRole? r) async {
    _role = r;
    if (r == null) {
      await _storage.remove(StorageKeys.role);
    } else {
      await _storage.writeString(StorageKeys.role, r.name);
    }
    notifyListeners();
  }

  /// Persists the pair code locally AND publishes it to Firestore so a
  /// partner on another device can resolve it.
  Future<void> setPairCode(String code) async {
    _pairCode = code;
    await _storage.writeString(StorageKeys.pairCode, code);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && code.isNotEmpty) {
      try {
        await CloudSyncService.instance.publishPairCode(code, uid);
      } catch (e) {
        debugPrint('publishPairCode failed: $e');
      }
    }
    notifyListeners();
  }

  // ----- Partner pairing -----
  Future<void> setPairedMomUid(String? momUid) async {
    _pairedMomUid = momUid;
    if (momUid == null) {
      await _storage.remove('paired_mom_uid');
    } else {
      await _storage.writeString('paired_mom_uid', momUid);
    }
    notifyListeners();
  }

  /// Pushes EVERY locally-stored entity to Firestore. Called once on mom's
  /// first cloud sign-in so a partner can see history that pre-dates pairing.
  Future<void> backfillToCloud() async {
    final uid = _uid;
    if (uid == null) return;
    final c = CloudSyncService.instance;
    try {
      if (_profile != null) await c.pushProfile(uid, _profile!);
      for (final e in _feedings) {
        await c.pushFeeding(uid, e);
      }
      for (final m in _moods) {
        await c.pushMood(uid, m);
      }
      for (final s in _sleeps) {
        await c.pushSleep(uid, s);
      }
      for (final w in _waters) {
        await c.pushWater(uid, w);
      }
      for (final m in _meals) {
        await c.pushMeal(uid, m);
      }
      for (final w in _weights) {
        await c.pushWeight(uid, w);
      }
    } catch (e) {
      debugPrint('backfillToCloud failed: $e');
    }
  }

  // ----- Theme / language / pro -----
  Future<void> setDark(bool dark) async {
    _dark = dark;
    await _storage.writeString(StorageKeys.theme, dark ? 'dark' : 'light');
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    _language = code;
    await _storage.writeString(StorageKeys.language, code);
    notifyListeners();
  }

  Future<void> setPro(bool value) async {
    _pro = value;
    await _storage.writeBool(StorageKeys.pro, value);
    notifyListeners();
  }

  // ----- Cloud sync helpers -----
  /// Returns the Firebase Auth UID, or null if user isn't signed in.
  String? get _uid => FirebaseAuth.instance.currentUser?.uid;
  CloudSyncService get _cloud => CloudSyncService.instance;

  void _cloudFire(Future<void> Function(String uid) op) {
    final uid = _uid;
    if (uid == null) return;
    op(uid).catchError((e) => debugPrint('cloud sync failed: $e'));
  }

  // ----- Feedings -----
  Future<void> addFeeding(FeedingEntry e) async {
    _feedings = [e, ..._feedings];
    await _persist(StorageKeys.feeding, _feedings);
    _cloudFire((uid) => _cloud.pushFeeding(uid, e));
    notifyListeners();
  }

  Future<void> removeFeeding(String id) async {
    _feedings = _feedings.where((e) => e.id != id).toList();
    await _persist(StorageKeys.feeding, _feedings);
    _cloudFire((uid) => _cloud.removeFeeding(uid, id));
    notifyListeners();
  }

  // ----- Moods -----
  Future<void> upsertMood(MoodEntry m) async {
    _moods = [m, ..._moods.where((e) => e.date != m.date)];
    await _persist(StorageKeys.mood, _moods);
    _cloudFire((uid) => _cloud.pushMood(uid, m));
    notifyListeners();
  }

  // ----- Sleep -----
  Future<void> addSleep(SleepEntry s) async {
    _sleeps = [s, ..._sleeps];
    await _persist(StorageKeys.sleep, _sleeps);
    _cloudFire((uid) => _cloud.pushSleep(uid, s));
    notifyListeners();
  }

  Future<void> removeSleep(String id) async {
    _sleeps = _sleeps.where((e) => e.id != id).toList();
    await _persist(StorageKeys.sleep, _sleeps);
    _cloudFire((uid) => _cloud.removeSleep(uid, id));
    notifyListeners();
  }

  // ----- Exercises -----
  Future<void> addExercise(ExerciseSession s) async {
    _exercises = [s, ..._exercises];
    await _persist(StorageKeys.exercise, _exercises);
    notifyListeners();
  }

  // ----- Water -----
  Future<void> setWaterCups(String date, int cups) async {
    final clamped = cups < 0 ? 0 : cups;
    final entry = WaterEntry(id: date, date: date, cups: clamped);
    _waters = [entry, ..._waters.where((w) => w.date != date)];
    await _persist(StorageKeys.water, _waters);
    await HomeWidgetService.pushWaterCups(clamped);
    _cloudFire((uid) => _cloud.pushWater(uid, entry));
    notifyListeners();
  }

  // ----- Meals -----
  Future<void> addMeal(MealEntry m) async {
    _meals = [m, ..._meals];
    await _persist(StorageKeys.meals, _meals);
    await _pushKcalToWidget();
    _cloudFire((uid) => _cloud.pushMeal(uid, m));
    notifyListeners();
  }

  Future<void> removeMeal(String id) async {
    _meals = _meals.where((m) => m.id != id).toList();
    await _persist(StorageKeys.meals, _meals);
    await _pushKcalToWidget();
    _cloudFire((uid) => _cloud.removeMeal(uid, id));
    notifyListeners();
  }

  int todayKcal() {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return _meals
        .where((m) => m.date == today)
        .fold<int>(0, (a, m) => a + (m.calories ?? 0));
  }

  Future<void> _pushKcalToWidget() {
    return HomeWidgetService.pushKcal(todayKcal());
  }

  // ----- Weights -----
  Future<void> addWeight(WeightEntry w) async {
    _weights = [
      w,
      ..._weights.where((x) => x.date != w.date),
    ];
    await _persist(StorageKeys.weight, _weights);
    notifyListeners();
  }

  Future<void> removeWeight(String id) async {
    _weights = _weights.where((w) => w.id != id).toList();
    await _persist(StorageKeys.weight, _weights);
    notifyListeners();
  }

  /// Wipes local state and seeds a sample profile + a few entries so the
  /// dashboard looks alive on demo runs. No Firebase calls.
  Future<void> loadDemoData() async {
    await _storage.clearAllAppKeys();
    _hydrate();
    final now = DateTime.now();
    final today = now.toIso8601String().substring(0, 10);
    final demoProfile = Profile(
      name: 'Demo Ayşe',
      babyBirthDate: now
          .subtract(const Duration(days: 70))
          .toIso8601String()
          .substring(0, 10),
      birthType: BirthType.normal,
      healthTags: const ['anemia'],
      allergens: const ['nuts'],
      dislikes: const ['fish'],
      feedingStyle: const ['mixed'],
      goals: const [Goal.sleep, Goal.mood, Goal.feed],
      createdAt: now.toIso8601String(),
    );
    _profile = demoProfile;
    await _storage.writeJson(StorageKeys.profile, demoProfile.toJson());
    _role = UserRole.mom;
    await _storage.writeString(StorageKeys.role, UserRole.mom.name);
    _pairCode = 'DEMO12';
    await _storage.writeString(StorageKeys.pairCode, _pairCode);

    // Feedings — 3 over the last 9 hours
    final feedings = [
      FeedingEntry(
        id: 'demo_f1',
        startedAt: now
            .subtract(const Duration(hours: 1, minutes: 15))
            .toIso8601String(),
        durationSec: 16 * 60,
        side: FeedingSide.left,
      ),
      FeedingEntry(
        id: 'demo_f2',
        startedAt: now
            .subtract(const Duration(hours: 4, minutes: 30))
            .toIso8601String(),
        durationSec: 0,
        side: FeedingSide.bottle,
        amountMl: 120,
      ),
      FeedingEntry(
        id: 'demo_f3',
        startedAt:
            now.subtract(const Duration(hours: 8)).toIso8601String(),
        durationSec: 12 * 60,
        side: FeedingSide.right,
      ),
    ];
    _feedings = feedings;
    await _persist(StorageKeys.feeding, _feedings);

    // Mood — happy today
    _moods = [
      MoodEntry(
        id: 'demo_m1',
        date: today,
        mood: MoodKind.happy,
        note: 'Bugün dinlenmiş hissediyorum',
        createdAt: now.toIso8601String(),
      ),
    ];
    await _persist(StorageKeys.mood, _moods);

    // Water — 6 of 10 cups (1.2 L)
    _waters = [WaterEntry(id: today, date: today, cups: 6)];
    await _persist(StorageKeys.water, _waters);
    await HomeWidgetService.pushWaterCups(6);

    // Sleep — last night 7h
    final yEnd = DateTime(now.year, now.month, now.day, 6, 30);
    final yStart = yEnd.subtract(const Duration(hours: 7));
    _sleeps = [
      SleepEntry(
        id: 'demo_s1',
        who: SleeperType.mom,
        start: yStart.toIso8601String(),
        end: yEnd.toIso8601String(),
        quality: 4,
      ),
    ];
    await _persist(StorageKeys.sleep, _sleeps);

    // Exercise — one yesterday
    _exercises = [
      ExerciseSession(
        id: 'demo_e1',
        exerciseId: 'b1',
        category: 'breath',
        durationMin: 5,
        doneAt: now
            .subtract(const Duration(hours: 20))
            .toIso8601String(),
      ),
    ];
    await _persist(StorageKeys.exercise, _exercises);

    // Meals
    _meals = [
      MealEntry(
        id: 'demo_meal1',
        date: today,
        name: 'Yulaflı kahvaltı + muz',
        calories: 380,
        createdAt: now.subtract(const Duration(hours: 5)).toIso8601String(),
      ),
      MealEntry(
        id: 'demo_meal2',
        date: today,
        name: 'Mercimek çorbası + ekmek',
        calories: 440,
        createdAt: now.subtract(const Duration(hours: 1)).toIso8601String(),
      ),
    ];
    await _persist(StorageKeys.meals, _meals);
    await HomeWidgetService.pushKcal(todayKcal());

    // Weight — 2 entries
    _weights = [
      WeightEntry(
        id: 'demo_w1',
        date: today,
        kg: 67.2,
      ),
      WeightEntry(
        id: 'demo_w2',
        date: now
            .subtract(const Duration(days: 7))
            .toIso8601String()
            .substring(0, 10),
        kg: 68.0,
      ),
    ];
    await _persist(StorageKeys.weight, _weights);

    // Mark a couple of milestones done
    _milestones = {'smile', 'head'};
    await _storage.writeJson(StorageKeys.milestones, _milestones.toList());

    // Enable Pro so the analytics tab shows charts
    _pro = true;
    await _storage.writeBool(StorageKeys.pro, true);

    notifyListeners();
  }

  // ----- Reminders -----
  Future<void> toggleReminder(String id, bool value) async {
    _reminders = _reminders
        .map((r) => r.id == id ? r.copyWith(enabled: value) : r)
        .toList();
    await _persistReminders();
    notifyListeners();
  }

  Future<void> setReminderInterval(String id, int mins) async {
    _reminders = _reminders
        .map((r) => r.id == id ? r.copyWith(intervalMin: mins) : r)
        .toList();
    await _persistReminders();
    notifyListeners();
  }

  Future<void> _persistReminders() {
    return _persist(StorageKeys.reminders, _reminders);
  }

  // ----- Milestones -----
  Future<void> toggleMilestone(String id, bool done) async {
    final next = Set<String>.from(_milestones);
    if (done) {
      next.add(id);
    } else {
      next.remove(id);
    }
    _milestones = next;
    await _storage.writeJson(StorageKeys.milestones, next.toList());
    notifyListeners();
  }

  // ----- Data import / reset -----
  Future<void> resetAll() async {
    await _storage.clearAllAppKeys();
    _hydrate();
    notifyListeners();
  }

  Future<void> importDump(Map<String, dynamic> dump) async {
    await _storage.importDump(dump);
    _hydrate();
    notifyListeners();
  }

  Map<String, dynamic> exportDump() => _storage.exportDump();

  Future<void> _persist(
    String key,
    List<Object> items,
  ) {
    final list = items
        .map((e) => (e as dynamic).toJson() as Map<String, dynamic>)
        .toList();
    return _storage.writeJson(key, list);
  }

  static List<ReminderConfig> defaultReminders() => const [
        ReminderConfig(
          id: 'r1',
          kind: ReminderKind.feeding,
          enabled: false,
          intervalMin: 180,
        ),
        ReminderConfig(
          id: 'r2',
          kind: ReminderKind.water,
          enabled: false,
          intervalMin: 90,
        ),
        ReminderConfig(
          id: 'r3',
          kind: ReminderKind.sleep,
          enabled: false,
          intervalMin: 240,
        ),
        ReminderConfig(
          id: 'r4',
          kind: ReminderKind.exercise,
          enabled: false,
          intervalMin: 720,
        ),
        ReminderConfig(
          id: 'r5',
          kind: ReminderKind.mood,
          enabled: false,
          intervalMin: 720,
        ),
      ];
}
