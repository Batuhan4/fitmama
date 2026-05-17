import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/feeding_entry.dart';
import '../models/meal_entry.dart';
import '../models/mood_entry.dart';
import '../models/profile.dart';
import '../models/sleep_entry.dart';
import '../models/water_entry.dart';
import '../models/weight_entry.dart';

/// Firestore data layout
///
///   users/{momUid}/
///     profile/current                 → Profile
///     feeding/{entryId}               → FeedingEntry
///     mood/{date}                     → MoodEntry  (one per day)
///     sleep/{entryId}                 → SleepEntry
///     water/{date}                    → WaterEntry (one per day)
///     meals/{entryId}                 → MealEntry
///     weight/{entryId}                → WeightEntry
///   pairCodes/{CODE}                  → { momUid, createdAt }
///   pairings/{momUid}/partners/{uid}  → { connectedAt }
class CloudSyncService {
  CloudSyncService._();
  static final instance = CloudSyncService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _u(String uid, String name) =>
      _db.collection('users').doc(uid).collection(name);

  // ───── Profile ─────
  Future<void> pushProfile(String uid, Profile p) =>
      _u(uid, 'profile').doc('current').set(p.toJson());

  Stream<Profile?> profileStream(String uid) =>
      _u(uid, 'profile').doc('current').snapshots().map(
            (s) => s.exists ? Profile.fromJson(s.data()!) : null,
          );

  // ───── Generic entry helpers ─────
  Future<void> _setEntry(String uid, String col, String id, Object json) =>
      _u(uid, col).doc(id).set(json as Map<String, dynamic>);

  Future<void> _deleteEntry(String uid, String col, String id) =>
      _u(uid, col).doc(id).delete();

  // ───── Feeding ─────
  Future<void> pushFeeding(String uid, FeedingEntry e) =>
      _setEntry(uid, 'feeding', e.id, e.toJson());
  Future<void> removeFeeding(String uid, String id) =>
      _deleteEntry(uid, 'feeding', id);
  Stream<List<FeedingEntry>> feedingsStream(String uid) =>
      _u(uid, 'feeding')
          .orderBy('startedAt', descending: true)
          .snapshots()
          .map((s) =>
              s.docs.map((d) => FeedingEntry.fromJson(d.data())).toList());

  // ───── Mood (one per date) ─────
  Future<void> pushMood(String uid, MoodEntry m) =>
      _u(uid, 'mood').doc(m.date).set(m.toJson());
  Stream<List<MoodEntry>> moodStream(String uid) => _u(uid, 'mood')
      .snapshots()
      .map((s) => s.docs.map((d) => MoodEntry.fromJson(d.data())).toList());

  // ───── Sleep ─────
  Future<void> pushSleep(String uid, SleepEntry e) =>
      _setEntry(uid, 'sleep', e.id, e.toJson());
  Future<void> removeSleep(String uid, String id) =>
      _deleteEntry(uid, 'sleep', id);
  Stream<List<SleepEntry>> sleepStream(String uid) => _u(uid, 'sleep')
      .snapshots()
      .map((s) => s.docs.map((d) => SleepEntry.fromJson(d.data())).toList());

  // ───── Water (one per date) ─────
  Future<void> pushWater(String uid, WaterEntry w) =>
      _u(uid, 'water').doc(w.date).set(w.toJson());
  Stream<List<WaterEntry>> waterStream(String uid) => _u(uid, 'water')
      .snapshots()
      .map((s) => s.docs.map((d) => WaterEntry.fromJson(d.data())).toList());

  // ───── Meals ─────
  Future<void> pushMeal(String uid, MealEntry m) =>
      _setEntry(uid, 'meals', m.id, m.toJson());
  Future<void> removeMeal(String uid, String id) =>
      _deleteEntry(uid, 'meals', id);
  Stream<List<MealEntry>> mealsStream(String uid) => _u(uid, 'meals')
      .snapshots()
      .map((s) => s.docs.map((d) => MealEntry.fromJson(d.data())).toList());

  // ───── Weight ─────
  Future<void> pushWeight(String uid, WeightEntry w) =>
      _setEntry(uid, 'weight', w.id, w.toJson());
  Future<void> removeWeight(String uid, String id) =>
      _deleteEntry(uid, 'weight', id);
  Stream<List<WeightEntry>> weightStream(String uid) => _u(uid, 'weight')
      .snapshots()
      .map((s) => s.docs.map((d) => WeightEntry.fromJson(d.data())).toList());

  // ───── Pairing ─────
  Future<void> publishPairCode(String code, String momUid) =>
      _db.collection('pairCodes').doc(code).set({
        'momUid': momUid,
        'createdAt': FieldValue.serverTimestamp(),
      });

  /// Returns momUid for the pair code, or null if not found.
  Future<String?> resolvePairCode(String code) async {
    try {
      final doc = await _db.collection('pairCodes').doc(code).get();
      return doc.data()?['momUid'] as String?;
    } catch (e) {
      debugPrint('resolvePairCode failed: $e');
      return null;
    }
  }

  Future<void> attachPartner(String momUid, String partnerUid) =>
      _db.doc('pairings/$momUid/partners/$partnerUid').set({
        'connectedAt': FieldValue.serverTimestamp(),
      });
}
