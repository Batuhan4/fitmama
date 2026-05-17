import 'package:flutter_test/flutter_test.dart';
import 'package:fitmama/data/models/exercise_session.dart';
import 'package:fitmama/data/models/feeding_entry.dart';
import 'package:fitmama/data/models/meal_entry.dart';
import 'package:fitmama/data/models/mood_entry.dart';
import 'package:fitmama/data/models/profile.dart';
import 'package:fitmama/data/models/reminder_config.dart';
import 'package:fitmama/data/models/sleep_entry.dart';
import 'package:fitmama/data/models/user_role.dart';
import 'package:fitmama/data/models/weight_entry.dart';
import 'package:fitmama/data/repositories/app_repository.dart';
import 'package:fitmama/data/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AppRepository> _makeRepo([Map<String, Object>? seed]) async {
  SharedPreferences.setMockInitialValues(seed ?? <String, Object>{});
  final storage = await StorageService.create();
  return AppRepository(storage);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('hydrates default reminders when none stored', () async {
    final repo = await _makeRepo();
    expect(repo.reminders.length, 5);
    expect(
      repo.reminders.first.kind,
      ReminderKind.feeding,
    );
  });

  test('persists profile and notifies listeners', () async {
    final repo = await _makeRepo();
    var notified = 0;
    repo.addListener(() => notified += 1);
    await repo.saveProfile(
      const Profile(
        name: 'Ayşe',
        babyBirthDate: '2026-04-12',
        birthType: BirthType.normal,
        createdAt: '2026-04-12T00:00:00Z',
      ),
    );
    expect(repo.profile?.name, 'Ayşe');
    expect(notified, greaterThanOrEqualTo(1));
  });

  test('feeding add/remove updates list', () async {
    final repo = await _makeRepo();
    await repo.addFeeding(const FeedingEntry(
      id: 'f1',
      startedAt: '2026-04-12T10:00:00Z',
      durationSec: 120,
      side: FeedingSide.left,
    ));
    expect(repo.feedings, hasLength(1));
    await repo.removeFeeding('f1');
    expect(repo.feedings, isEmpty);
  });

  test('mood upsert replaces same-day entry', () async {
    final repo = await _makeRepo();
    await repo.upsertMood(const MoodEntry(
      id: 'm1',
      date: '2026-04-12',
      mood: MoodKind.happy,
      createdAt: '2026-04-12T08:00:00Z',
    ));
    await repo.upsertMood(const MoodEntry(
      id: 'm2',
      date: '2026-04-12',
      mood: MoodKind.tired,
      createdAt: '2026-04-12T22:00:00Z',
    ));
    expect(repo.moods, hasLength(1));
    expect(repo.moods.first.mood, MoodKind.tired);
  });

  test('water cups clamp to non-negative', () async {
    final repo = await _makeRepo();
    await repo.setWaterCups('2026-04-12', 5);
    expect(repo.waters.first.cups, 5);
    await repo.setWaterCups('2026-04-12', -2);
    expect(repo.waters.first.cups, 0);
    await repo.setWaterCups('2026-04-12', 3);
    expect(repo.waters, hasLength(1));
    expect(repo.waters.first.cups, 3);
  });

  test('reminder toggle and interval changes persist', () async {
    final repo = await _makeRepo();
    final first = repo.reminders.first;
    await repo.toggleReminder(first.id, true);
    await repo.setReminderInterval(first.id, 45);
    final updated = repo.reminders.firstWhere((r) => r.id == first.id);
    expect(updated.enabled, isTrue);
    expect(updated.intervalMin, 45);
  });

  test('addMeal / removeMeal cycle', () async {
    final repo = await _makeRepo();
    await repo.addMeal(const MealEntry(
      id: 'm1',
      date: '2026-04-12',
      name: 'Yulaf',
      createdAt: '2026-04-12T08:00:00Z',
    ));
    expect(repo.meals, hasLength(1));
    await repo.removeMeal('m1');
    expect(repo.meals, isEmpty);
  });

  test('addWeight replaces same-day entry and removeWeight works', () async {
    final repo = await _makeRepo();
    await repo.addWeight(const WeightEntry(
      id: 'w1',
      date: '2026-04-12',
      kg: 65,
    ));
    await repo.addWeight(const WeightEntry(
      id: 'w2',
      date: '2026-04-12',
      kg: 64.5,
    ));
    expect(repo.weights, hasLength(1));
    expect(repo.weights.first.kg, 64.5);
    await repo.removeWeight('w2');
    expect(repo.weights, isEmpty);
  });

  test('milestone toggle adds and removes id', () async {
    final repo = await _makeRepo();
    await repo.toggleMilestone('smile', true);
    expect(repo.milestones, contains('smile'));
    await repo.toggleMilestone('smile', false);
    expect(repo.milestones, isNot(contains('smile')));
  });

  test('setRole writes and clears the value', () async {
    final repo = await _makeRepo();
    await repo.setRole(UserRole.mom);
    expect(repo.role, UserRole.mom);
    await repo.setRole(null);
    expect(repo.role, isNull);
  });

  test('sleep add/remove cycle', () async {
    final repo = await _makeRepo();
    await repo.addSleep(const SleepEntry(
      id: 's1',
      who: SleeperType.mom,
      start: '2026-04-12T22:00:00Z',
      end: '2026-04-13T05:00:00Z',
      quality: 4,
    ));
    expect(repo.sleeps, hasLength(1));
    expect(repo.sleeps.first.durationMinutes, 7 * 60);
    await repo.removeSleep('s1');
    expect(repo.sleeps, isEmpty);
  });

  test('addExercise appends sessions in newest-first order', () async {
    final repo = await _makeRepo();
    await repo.addExercise(const ExerciseSession(
      id: 'e1',
      exerciseId: 'y1',
      category: 'yoga',
      durationMin: 5,
      doneAt: '2026-04-12T10:00:00Z',
    ));
    await repo.addExercise(const ExerciseSession(
      id: 'e2',
      exerciseId: 'p1',
      category: 'pelvic',
      durationMin: 8,
      doneAt: '2026-04-12T18:00:00Z',
    ));
    expect(repo.exercises.first.id, 'e2');
    expect(repo.exercises, hasLength(2));
  });

  test('resetAll clears tracked entries and restores defaults', () async {
    final repo = await _makeRepo();
    await repo.saveProfile(const Profile(
      name: 'X',
      babyBirthDate: '2026-04-12',
      birthType: BirthType.normal,
      createdAt: '2026-04-12T00:00:00Z',
    ));
    await repo.addFeeding(const FeedingEntry(
      id: 'f1',
      startedAt: '2026-04-12T10:00:00Z',
      durationSec: 120,
      side: FeedingSide.left,
    ));
    await repo.resetAll();
    expect(repo.profile, isNull);
    expect(repo.feedings, isEmpty);
    expect(repo.reminders, isNotEmpty);
  });

  test('export then import restores the same shape', () async {
    final repo = await _makeRepo();
    await repo.setPairCode('ABCDE2');
    await repo.setPro(true);
    await repo.saveProfile(const Profile(
      name: 'Ayşe',
      babyBirthDate: '2026-04-12',
      birthType: BirthType.csection,
      createdAt: '2026-04-12T00:00:00Z',
    ));
    final dump = repo.exportDump();
    await repo.resetAll();
    expect(repo.profile, isNull);
    await repo.importDump(dump);
    expect(repo.profile?.name, 'Ayşe');
    expect(repo.pairCode, 'ABCDE2');
    expect(repo.pro, isTrue);
  });
}
