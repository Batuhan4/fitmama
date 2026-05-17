import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/exercise_session.dart';
import '../models/feeding_entry.dart';
import '../models/meal_entry.dart';
import '../models/mood_entry.dart';
import '../models/profile.dart';
import '../models/sleep_entry.dart';
import '../models/water_entry.dart';
import '../models/weight_entry.dart';
import '../services/cloud_sync_service.dart';

/// Read-only view of the paired mom's data, streamed from Firestore.
/// Partner UI binds to this instead of [AppRepository].
class PartnerRepository extends ChangeNotifier {
  PartnerRepository(this.momUid) {
    _subscribe();
  }

  final String momUid;
  final CloudSyncService _cloud = CloudSyncService.instance;

  Profile? profile;
  List<FeedingEntry> feedings = const [];
  List<MoodEntry> moods = const [];
  List<SleepEntry> sleeps = const [];
  List<WaterEntry> waters = const [];
  List<MealEntry> meals = const [];
  List<WeightEntry> weights = const [];
  List<ExerciseSession> exercises = const [];

  bool loading = true;
  final List<StreamSubscription<dynamic>> _subs = [];

  void _subscribe() {
    _subs.addAll([
      _cloud.profileStream(momUid).listen((p) {
        profile = p;
        loading = false;
        notifyListeners();
      }, onError: (e) => debugPrint('profile stream error: $e')),
      _cloud.feedingsStream(momUid).listen((l) {
        feedings = l;
        notifyListeners();
      }, onError: (e) => debugPrint('feedings stream error: $e')),
      _cloud.moodStream(momUid).listen((l) {
        moods = l;
        notifyListeners();
      }, onError: (e) => debugPrint('mood stream error: $e')),
      _cloud.sleepStream(momUid).listen((l) {
        sleeps = l;
        notifyListeners();
      }, onError: (e) => debugPrint('sleep stream error: $e')),
      _cloud.waterStream(momUid).listen((l) {
        waters = l;
        notifyListeners();
      }, onError: (e) => debugPrint('water stream error: $e')),
      _cloud.mealsStream(momUid).listen((l) {
        meals = l;
        notifyListeners();
      }, onError: (e) => debugPrint('meals stream error: $e')),
      _cloud.weightStream(momUid).listen((l) {
        weights = l;
        notifyListeners();
      }, onError: (e) => debugPrint('weight stream error: $e')),
    ]);
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    super.dispose();
  }
}
