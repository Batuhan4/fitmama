/// FitMama program catalog — every program has a list of levels, every level
/// a list of timed exercise steps. Used by the workout player to drive the
/// countdown and by the program detail screen to show level unlocks.
class ExerciseStep {
  const ExerciseStep({
    required this.name,
    required this.seconds,
    this.sets = 1,
    this.restSec = 15,
    this.sub,
  });

  final String name;
  final int seconds;
  final int sets;
  final int restSec;
  final String? sub;

  int get totalActiveSec => seconds * sets;
  int get totalRestSec => restSec * (sets > 0 ? sets - 1 : 0);
  int get totalSec => totalActiveSec + totalRestSec;
}

class ProgramLevelDef {
  const ProgramLevelDef({
    required this.index,
    required this.name,
    required this.tagline,
    required this.exercises,
  });

  final int index;
  final String name;
  final String tagline;
  final List<ExerciseStep> exercises;

  int get totalSec =>
      exercises.fold(0, (a, e) => a + e.totalSec) +
      (exercises.length > 1 ? (exercises.length - 1) * 20 : 0);

  int get estimatedMinutes => (totalSec / 60).ceil();

  int get xpReward => 60 + index * 40 + (estimatedMinutes * 4);
}

class ProgramDefinition {
  const ProgramDefinition({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.levels,
  });

  final String id;
  final String title;
  final String subtitle;
  final List<ProgramLevelDef> levels;
}

/// Hand-curated catalog mirroring the 8 entries in `kAllPrograms`.
/// Each program has 4 levels with gradually increasing volume / intensity.
const kProgramCatalog = <ProgramDefinition>[
  ProgramDefinition(
    id: 'core-recovery',
    title: 'Core Recovery',
    subtitle: 'Postpartum karın bölgesini güvenli adımlarla yeniden inşa et.',
    levels: [
      ProgramLevelDef(
        index: 0,
        name: 'Hafta 1 · Temel nefes',
        tagline: 'Diaphragmatic breathing + pelvik farkındalık.',
        exercises: [
          ExerciseStep(
              name: 'Diaphragmatic Breath',
              seconds: 60,
              sets: 2,
              restSec: 15,
              sub: 'Burnundan derin nefes, ağızdan yavaş bırak.'),
          ExerciseStep(
              name: 'Pelvik Tilt',
              seconds: 30,
              sets: 3,
              restSec: 15,
              sub: 'Sırt tamamen yere yapışsın.'),
          ExerciseStep(
              name: 'Dead Bug (yavaş)',
              seconds: 30,
              sets: 2,
              restSec: 20),
          ExerciseStep(
              name: 'Cat-Cow',
              seconds: 40,
              sets: 2,
              restSec: 15,
              sub: 'Omurganı segment segment hareket ettir.'),
          ExerciseStep(
              name: 'Glute Bridge (statik)',
              seconds: 30,
              sets: 3,
              restSec: 15),
        ],
      ),
      ProgramLevelDef(
        index: 1,
        name: 'Hafta 2 · Core aktivasyonu',
        tagline: 'TVA aktivasyon + diastasis safe hareketler.',
        exercises: [
          ExerciseStep(
              name: 'Diaphragmatic Breath',
              seconds: 45,
              sets: 2,
              restSec: 15),
          ExerciseStep(
              name: 'Dead Bug',
              seconds: 40,
              sets: 3,
              restSec: 20),
          ExerciseStep(
              name: 'Glute Bridge',
              seconds: 45,
              sets: 3,
              restSec: 20),
          ExerciseStep(
              name: 'Bird Dog',
              seconds: 40,
              sets: 3,
              restSec: 20),
          ExerciseStep(
              name: 'Side-Lying Leg Lift',
              seconds: 30,
              sets: 2,
              restSec: 15,
              sub: 'Her iki taraf için.'),
          ExerciseStep(
              name: 'Heel Slides',
              seconds: 40,
              sets: 2,
              restSec: 15),
        ],
      ),
      ProgramLevelDef(
        index: 2,
        name: 'Hafta 3 · Stabilite',
        tagline: 'Yük ve denge eklemeye başlıyoruz.',
        exercises: [
          ExerciseStep(
              name: 'Plank (knees)',
              seconds: 45,
              sets: 3,
              restSec: 25),
          ExerciseStep(
              name: 'Single-Leg Glute Bridge',
              seconds: 40,
              sets: 3,
              restSec: 20),
          ExerciseStep(
              name: 'Bird Dog Hold',
              seconds: 30,
              sets: 3,
              restSec: 20),
          ExerciseStep(
              name: 'Dead Bug (ağırlıklı)',
              seconds: 45,
              sets: 3,
              restSec: 20),
          ExerciseStep(
              name: 'Side Plank (knee)',
              seconds: 30,
              sets: 2,
              restSec: 20,
              sub: 'Her iki taraf.'),
          ExerciseStep(
              name: 'Cat-Cow flow',
              seconds: 40,
              sets: 2,
              restSec: 15),
        ],
      ),
      ProgramLevelDef(
        index: 3,
        name: 'Hafta 4 · Güç',
        tagline: 'Dinamik core: kontrollü, güçlü.',
        exercises: [
          ExerciseStep(
              name: 'Plank',
              seconds: 45,
              sets: 3,
              restSec: 25),
          ExerciseStep(
              name: 'Mountain Climber (yavaş)',
              seconds: 40,
              sets: 3,
              restSec: 25),
          ExerciseStep(
              name: 'Reverse Crunch',
              seconds: 40,
              sets: 3,
              restSec: 20),
          ExerciseStep(
              name: 'Side Plank',
              seconds: 30,
              sets: 3,
              restSec: 20,
              sub: 'Her iki taraf.'),
          ExerciseStep(
              name: 'Bird Dog (ağırlıklı)',
              seconds: 45,
              sets: 3,
              restSec: 20),
          ExerciseStep(
              name: 'Hollow Hold',
              seconds: 30,
              sets: 3,
              restSec: 25),
          ExerciseStep(
              name: 'Cool-down Breath',
              seconds: 90,
              sets: 1,
              restSec: 0),
        ],
      ),
    ],
  ),
  ProgramDefinition(
    id: 'kalca-gelistirme',
    title: 'Kalça Geliştirme',
    subtitle: 'Glute + kalça odaklı 4 haftalık güç programı.',
    levels: [
      ProgramLevelDef(
        index: 0,
        name: 'Hafta 1 · Aktivasyon',
        tagline: 'Mini band + glute aktivasyon hareketleri.',
        exercises: [
          ExerciseStep(name: 'Glute Bridge', seconds: 40, sets: 3, restSec: 20),
          ExerciseStep(
              name: 'Clamshell',
              seconds: 30,
              sets: 3,
              restSec: 15,
              sub: 'Her iki taraf.'),
          ExerciseStep(
              name: 'Donkey Kick',
              seconds: 30,
              sets: 3,
              restSec: 15,
              sub: 'Her iki taraf.'),
          ExerciseStep(
              name: 'Fire Hydrant',
              seconds: 30,
              sets: 2,
              restSec: 15),
          ExerciseStep(
              name: 'Bodyweight Squat',
              seconds: 40,
              sets: 3,
              restSec: 20),
        ],
      ),
      ProgramLevelDef(
        index: 1,
        name: 'Hafta 2 · Form',
        tagline: 'Tempo + tek bacak hareketler.',
        exercises: [
          ExerciseStep(name: 'Sumo Squat', seconds: 45, sets: 3, restSec: 25),
          ExerciseStep(
              name: 'Reverse Lunge',
              seconds: 40,
              sets: 3,
              restSec: 20,
              sub: 'Her iki bacak.'),
          ExerciseStep(
              name: 'Single Leg Glute Bridge',
              seconds: 40,
              sets: 3,
              restSec: 20),
          ExerciseStep(
              name: 'Curtsy Lunge',
              seconds: 40,
              sets: 3,
              restSec: 20),
          ExerciseStep(
              name: 'Donkey Kick (band)',
              seconds: 30,
              sets: 3,
              restSec: 15),
          ExerciseStep(
              name: 'Side-Lying Leg Lift',
              seconds: 30,
              sets: 2,
              restSec: 15),
        ],
      ),
      ProgramLevelDef(
        index: 2,
        name: 'Hafta 3 · Yük',
        tagline: 'Hip thrust + ağırlık tempo.',
        exercises: [
          ExerciseStep(name: 'Hip Thrust', seconds: 50, sets: 4, restSec: 30),
          ExerciseStep(
              name: 'Bulgarian Split Squat',
              seconds: 40,
              sets: 3,
              restSec: 25),
          ExerciseStep(
              name: 'Romanian Deadlift',
              seconds: 50,
              sets: 4,
              restSec: 30),
          ExerciseStep(
              name: 'Lateral Lunge',
              seconds: 40,
              sets: 3,
              restSec: 20),
          ExerciseStep(
              name: 'Glute Kickback (band)',
              seconds: 35,
              sets: 3,
              restSec: 15),
        ],
      ),
      ProgramLevelDef(
        index: 3,
        name: 'Hafta 4 · Güç',
        tagline: 'Glute pump + finisher.',
        exercises: [
          ExerciseStep(name: 'Barbell Hip Thrust', seconds: 50, sets: 4, restSec: 35),
          ExerciseStep(
              name: 'Bulgarian Split Squat (ağırlık)',
              seconds: 45,
              sets: 3,
              restSec: 30),
          ExerciseStep(name: 'Sumo Deadlift', seconds: 50, sets: 4, restSec: 30),
          ExerciseStep(
              name: 'Walking Lunge',
              seconds: 60,
              sets: 3,
              restSec: 30),
          ExerciseStep(
              name: 'Glute Bridge March',
              seconds: 45,
              sets: 3,
              restSec: 20),
          ExerciseStep(
              name: 'Cool-down Stretch',
              seconds: 120,
              sets: 1,
              restSec: 0),
        ],
      ),
    ],
  ),
  ProgramDefinition(
    id: 'bel-inceltme',
    title: 'Bel İnceltme',
    subtitle: 'Diastasis-safe core + nefes ile bel çevresini hedefle.',
    levels: [
      ProgramLevelDef(
        index: 0,
        name: 'Gün 1-5 · Temel',
        tagline: 'Nefes + pelvik tilt ile başla.',
        exercises: [
          ExerciseStep(name: 'TVA Breath', seconds: 60, sets: 2, restSec: 15),
          ExerciseStep(name: 'Pelvik Tilt', seconds: 40, sets: 3, restSec: 15),
          ExerciseStep(
              name: 'Heel Slide',
              seconds: 30,
              sets: 3,
              restSec: 15,
              sub: 'Her iki taraf.'),
          ExerciseStep(name: 'Glute Bridge', seconds: 30, sets: 3, restSec: 15),
        ],
      ),
      ProgramLevelDef(
        index: 1,
        name: 'Gün 6-10 · Kontrol',
        tagline: 'TVA aktivasyon + obliques.',
        exercises: [
          ExerciseStep(name: 'Dead Bug', seconds: 40, sets: 3, restSec: 20),
          ExerciseStep(name: 'Bird Dog', seconds: 40, sets: 3, restSec: 20),
          ExerciseStep(
              name: 'Side-Lying Oblique Lift',
              seconds: 30,
              sets: 2,
              restSec: 15),
          ExerciseStep(name: 'Heel Tap', seconds: 35, sets: 3, restSec: 15),
          ExerciseStep(
              name: 'Standing Side Bend',
              seconds: 30,
              sets: 2,
              restSec: 15),
        ],
      ),
      ProgramLevelDef(
        index: 2,
        name: 'Gün 11-16 · Tonla',
        tagline: 'Plank + obliques karışımı.',
        exercises: [
          ExerciseStep(name: 'Plank', seconds: 40, sets: 3, restSec: 25),
          ExerciseStep(
              name: 'Side Plank Hip Dip',
              seconds: 30,
              sets: 3,
              restSec: 20),
          ExerciseStep(name: 'Russian Twist (slow)', seconds: 40, sets: 3, restSec: 20),
          ExerciseStep(
              name: 'Bicycle Crunch (yavaş)',
              seconds: 40,
              sets: 3,
              restSec: 20),
          ExerciseStep(name: 'Glute Bridge', seconds: 40, sets: 3, restSec: 15),
        ],
      ),
      ProgramLevelDef(
        index: 3,
        name: 'Gün 17-21 · Form',
        tagline: 'Yoğunlaştır, finisher ekle.',
        exercises: [
          ExerciseStep(name: 'Plank Shoulder Tap', seconds: 45, sets: 3, restSec: 25),
          ExerciseStep(name: 'Mountain Climber', seconds: 35, sets: 3, restSec: 25),
          ExerciseStep(name: 'Russian Twist', seconds: 45, sets: 3, restSec: 20),
          ExerciseStep(name: 'Bicycle Crunch', seconds: 45, sets: 3, restSec: 20),
          ExerciseStep(name: 'Standing Knee-to-Elbow', seconds: 40, sets: 3, restSec: 20),
          ExerciseStep(name: 'Cool-down Breath', seconds: 90, sets: 1, restSec: 0),
        ],
      ),
    ],
  ),
  ProgramDefinition(
    id: 'guclu-anne',
    title: 'Güçlü Anne',
    subtitle: 'Full body kuvvet programı; haftada 3 seans.',
    levels: [
      ProgramLevelDef(
        index: 0,
        name: 'Faz 1 · Form öğren',
        tagline: 'Bodyweight bazlı temel kuvvet.',
        exercises: [
          ExerciseStep(name: 'Goblet Squat', seconds: 45, sets: 3, restSec: 30),
          ExerciseStep(name: 'Push Up (knee)', seconds: 40, sets: 3, restSec: 30),
          ExerciseStep(name: 'Bent-Over Row', seconds: 45, sets: 3, restSec: 30),
          ExerciseStep(name: 'Glute Bridge', seconds: 45, sets: 3, restSec: 20),
          ExerciseStep(name: 'Dead Bug', seconds: 40, sets: 3, restSec: 20),
        ],
      ),
      ProgramLevelDef(
        index: 1,
        name: 'Faz 2 · Yük artır',
        tagline: 'Daha ağır kettlebell + dumbbell.',
        exercises: [
          ExerciseStep(name: 'Kettlebell Goblet Squat', seconds: 50, sets: 4, restSec: 40),
          ExerciseStep(name: 'Dumbbell Row', seconds: 45, sets: 4, restSec: 30),
          ExerciseStep(name: 'Push Up', seconds: 40, sets: 4, restSec: 30),
          ExerciseStep(name: 'Romanian Deadlift', seconds: 50, sets: 4, restSec: 35),
          ExerciseStep(name: 'Plank', seconds: 45, sets: 3, restSec: 25),
        ],
      ),
      ProgramLevelDef(
        index: 2,
        name: 'Faz 3 · Hipertrofi',
        tagline: 'Volüm yüksek, hipertrofi odaklı.',
        exercises: [
          ExerciseStep(name: 'Back Squat', seconds: 50, sets: 4, restSec: 45),
          ExerciseStep(name: 'Overhead Press', seconds: 45, sets: 4, restSec: 40),
          ExerciseStep(name: 'Romanian Deadlift', seconds: 50, sets: 4, restSec: 40),
          ExerciseStep(name: 'Bench Press', seconds: 45, sets: 4, restSec: 40),
          ExerciseStep(name: 'Hanging Leg Raise', seconds: 40, sets: 3, restSec: 25),
        ],
      ),
      ProgramLevelDef(
        index: 3,
        name: 'Faz 4 · Güç',
        tagline: 'Compound + finisher.',
        exercises: [
          ExerciseStep(name: 'Back Squat (ağır)', seconds: 50, sets: 5, restSec: 60),
          ExerciseStep(name: 'Conventional Deadlift', seconds: 50, sets: 5, restSec: 60),
          ExerciseStep(name: 'Bench Press', seconds: 45, sets: 5, restSec: 45),
          ExerciseStep(name: 'Pull Up / Assisted', seconds: 40, sets: 4, restSec: 40),
          ExerciseStep(name: 'Farmer Carry', seconds: 60, sets: 3, restSec: 45),
          ExerciseStep(name: 'Plank', seconds: 60, sets: 3, restSec: 30),
        ],
      ),
    ],
  ),
  ProgramDefinition(
    id: 'pelvik-taban',
    title: 'Pelvik Taban Reset',
    subtitle: 'Günlük 10 dk pelvik farkındalık + nefes.',
    levels: [
      ProgramLevelDef(
        index: 0,
        name: 'Gün 1-3 · Tanış',
        tagline: 'Kasları tanımakla başla.',
        exercises: [
          ExerciseStep(name: 'TVA Breath', seconds: 60, sets: 2, restSec: 15),
          ExerciseStep(name: 'Kegel (yavaş)', seconds: 30, sets: 3, restSec: 15),
          ExerciseStep(name: 'Pelvik Tilt', seconds: 30, sets: 3, restSec: 15),
          ExerciseStep(name: 'Bridge Hold', seconds: 30, sets: 2, restSec: 15),
          ExerciseStep(
              name: 'Cat-Cow',
              seconds: 45,
              sets: 2,
              restSec: 15,
              sub: 'Omurgayı yumuşat.'),
          ExerciseStep(
              name: 'Diyafram Nefesi',
              seconds: 60,
              sets: 2,
              restSec: 10,
              sub: 'Burun → 4 sn, ağız → 6 sn.'),
        ],
      ),
      ProgramLevelDef(
        index: 1,
        name: 'Gün 4-7 · Aktive et',
        tagline: 'Kontrol + zamanlama.',
        exercises: [
          ExerciseStep(name: 'Kegel (tempo)', seconds: 40, sets: 3, restSec: 15),
          ExerciseStep(name: 'Quick Kegel', seconds: 20, sets: 3, restSec: 20),
          ExerciseStep(name: 'Glute Bridge + Kegel', seconds: 40, sets: 3, restSec: 15),
          ExerciseStep(name: 'Heel Slide + Breath', seconds: 35, sets: 2, restSec: 15),
          ExerciseStep(
              name: 'Dead Bug (yumuşak)',
              seconds: 35,
              sets: 3,
              restSec: 20),
          ExerciseStep(
              name: 'Standing Pelvic Tilt',
              seconds: 30,
              sets: 3,
              restSec: 15),
        ],
      ),
      ProgramLevelDef(
        index: 2,
        name: 'Gün 8-11 · Birleştir',
        tagline: 'Hareketli kombinasyonlar.',
        exercises: [
          ExerciseStep(name: 'Squat + Kegel', seconds: 40, sets: 3, restSec: 20),
          ExerciseStep(name: 'Bird Dog + Kegel', seconds: 40, sets: 3, restSec: 20),
          ExerciseStep(name: 'Side-Lying Clam', seconds: 30, sets: 3, restSec: 15),
          ExerciseStep(name: 'Pelvic Rocking', seconds: 40, sets: 2, restSec: 15),
          ExerciseStep(
              name: 'Standing Knee Drive',
              seconds: 35,
              sets: 3,
              restSec: 20),
          ExerciseStep(
              name: 'Wall Sit + Breath',
              seconds: 30,
              sets: 3,
              restSec: 25),
        ],
      ),
      ProgramLevelDef(
        index: 3,
        name: 'Gün 12-14 · Güçlen',
        tagline: 'Zorluk artıyor.',
        exercises: [
          ExerciseStep(name: 'Sumo Squat + Kegel', seconds: 45, sets: 3, restSec: 25),
          ExerciseStep(name: 'Single-Leg Bridge + Kegel', seconds: 40, sets: 3, restSec: 20),
          ExerciseStep(name: 'Step-Up + Kegel', seconds: 45, sets: 3, restSec: 25),
          ExerciseStep(name: 'Long Kegel Hold', seconds: 30, sets: 4, restSec: 20),
          ExerciseStep(
              name: 'Pulse Kegel',
              seconds: 25,
              sets: 4,
              restSec: 15,
              sub: '1 sn kasıl, 1 sn bırak.'),
          ExerciseStep(
              name: 'Bridge March',
              seconds: 40,
              sets: 3,
              restSec: 20),
          ExerciseStep(name: 'Cool-down Breath', seconds: 90, sets: 1, restSec: 0),
        ],
      ),
    ],
  ),
  ProgramDefinition(
    id: 'hiit-burn',
    title: 'HIIT Burn',
    subtitle: '15 dk yüksek yoğunluk; düşük etki versiyon dahil.',
    levels: [
      ProgramLevelDef(
        index: 0,
        name: 'Seviye 1 · Düşük etki',
        tagline: 'Eklem dostu giriş.',
        exercises: [
          ExerciseStep(name: 'March in Place', seconds: 30, sets: 3, restSec: 15),
          ExerciseStep(name: 'Step Touch', seconds: 30, sets: 3, restSec: 15),
          ExerciseStep(name: 'Squat (low impact)', seconds: 30, sets: 3, restSec: 20),
          ExerciseStep(name: 'Standing Knee Drive', seconds: 30, sets: 3, restSec: 15),
          ExerciseStep(name: 'Lateral Toe Tap', seconds: 30, sets: 3, restSec: 15),
        ],
      ),
      ProgramLevelDef(
        index: 1,
        name: 'Seviye 2 · Tempo',
        tagline: 'Nabız yükselen tempolar.',
        exercises: [
          ExerciseStep(name: 'Jumping Jack (alternatif)', seconds: 30, sets: 4, restSec: 20),
          ExerciseStep(name: 'Squat', seconds: 30, sets: 4, restSec: 20),
          ExerciseStep(name: 'Mountain Climber', seconds: 30, sets: 4, restSec: 20),
          ExerciseStep(name: 'High Knees', seconds: 30, sets: 4, restSec: 20),
          ExerciseStep(name: 'Reverse Lunge', seconds: 30, sets: 4, restSec: 20),
        ],
      ),
      ProgramLevelDef(
        index: 2,
        name: 'Seviye 3 · Power',
        tagline: 'Patlayıcı setler.',
        exercises: [
          ExerciseStep(name: 'Burpee (modifiye)', seconds: 30, sets: 4, restSec: 25),
          ExerciseStep(name: 'Jump Squat', seconds: 30, sets: 4, restSec: 25),
          ExerciseStep(name: 'Push Up', seconds: 30, sets: 4, restSec: 20),
          ExerciseStep(name: 'Skater Jump', seconds: 30, sets: 4, restSec: 20),
          ExerciseStep(name: 'Plank Jack', seconds: 30, sets: 4, restSec: 20),
        ],
      ),
      ProgramLevelDef(
        index: 3,
        name: 'Seviye 4 · Elite',
        tagline: 'Full burnout setleri.',
        exercises: [
          ExerciseStep(name: 'Burpee', seconds: 40, sets: 5, restSec: 25),
          ExerciseStep(name: 'Jump Lunge', seconds: 30, sets: 5, restSec: 25),
          ExerciseStep(name: 'Sprawl', seconds: 30, sets: 4, restSec: 25),
          ExerciseStep(name: 'Mountain Climber (hızlı)', seconds: 35, sets: 4, restSec: 25),
          ExerciseStep(name: 'Tuck Jump', seconds: 30, sets: 4, restSec: 25),
          ExerciseStep(name: 'Cool-down', seconds: 90, sets: 1, restSec: 0),
        ],
      ),
    ],
  ),
  ProgramDefinition(
    id: 'yoga-flow',
    title: 'Yoga & Mobilite',
    subtitle: 'Esneklik + zihinsel toparlanma için akıcı yoga.',
    levels: [
      ProgramLevelDef(
        index: 0,
        name: 'Hafta 1 · Yumuşa',
        tagline: 'Temel pozlar + nefes.',
        exercises: [
          ExerciseStep(name: 'Cat-Cow', seconds: 60, sets: 2, restSec: 10),
          ExerciseStep(name: 'Child Pose', seconds: 60, sets: 2, restSec: 10),
          ExerciseStep(name: 'Down Dog', seconds: 45, sets: 3, restSec: 15),
          ExerciseStep(name: 'Cobra', seconds: 40, sets: 2, restSec: 15),
          ExerciseStep(name: 'Seated Forward Fold', seconds: 60, sets: 2, restSec: 10),
        ],
      ),
      ProgramLevelDef(
        index: 1,
        name: 'Hafta 2 · Aç',
        tagline: 'Kalça açıcılar + omurga.',
        exercises: [
          ExerciseStep(name: 'Pigeon Pose', seconds: 60, sets: 2, restSec: 15, sub: 'Her iki taraf.'),
          ExerciseStep(name: 'Lizard Pose', seconds: 50, sets: 2, restSec: 15),
          ExerciseStep(name: 'Triangle Pose', seconds: 40, sets: 2, restSec: 15),
          ExerciseStep(name: 'Warrior II', seconds: 45, sets: 2, restSec: 15),
          ExerciseStep(name: 'Bridge Pose', seconds: 40, sets: 3, restSec: 15),
        ],
      ),
      ProgramLevelDef(
        index: 2,
        name: 'Hafta 3 · Akış',
        tagline: 'Sun Salutation flow.',
        exercises: [
          ExerciseStep(name: 'Sun Salutation A', seconds: 90, sets: 3, restSec: 20),
          ExerciseStep(name: 'Warrior I → II → Reverse', seconds: 60, sets: 2, restSec: 20),
          ExerciseStep(name: 'Half Moon', seconds: 40, sets: 2, restSec: 15),
          ExerciseStep(name: 'Tree Pose', seconds: 45, sets: 2, restSec: 15),
          ExerciseStep(name: 'Bound Angle', seconds: 60, sets: 2, restSec: 10),
        ],
      ),
      ProgramLevelDef(
        index: 3,
        name: 'Hafta 4 · Güç akışı',
        tagline: 'Kuvvet + esneklik kombinasyonu.',
        exercises: [
          ExerciseStep(name: 'Chaturanga Flow', seconds: 60, sets: 3, restSec: 25),
          ExerciseStep(name: 'Warrior III', seconds: 45, sets: 2, restSec: 20),
          ExerciseStep(name: 'Side Plank', seconds: 40, sets: 2, restSec: 20),
          ExerciseStep(name: 'Camel Pose', seconds: 40, sets: 2, restSec: 20),
          ExerciseStep(name: 'Wheel / Bridge', seconds: 30, sets: 3, restSec: 20),
          ExerciseStep(name: 'Savasana', seconds: 120, sets: 1, restSec: 0),
        ],
      ),
    ],
  ),
  ProgramDefinition(
    id: 'gunluk-yuruyus',
    title: 'Günlük Yürüyüş',
    subtitle: 'Aktif gün için 30 dk yapılandırılmış yürüyüş planı.',
    levels: [
      ProgramLevelDef(
        index: 0,
        name: 'Hafta 1 · Tempo bul',
        tagline: 'Aralıklı sakin yürüyüş.',
        exercises: [
          ExerciseStep(
              name: 'Isınma yürüyüş',
              seconds: 180,
              sets: 1,
              restSec: 0,
              sub: '3 dakika sakin tempo.'),
          ExerciseStep(
              name: 'Postür hizalama',
              seconds: 30,
              sets: 2,
              restSec: 15,
              sub: 'Karın aktif, kollar dik.'),
          ExerciseStep(
              name: 'Sakin tempo',
              seconds: 240,
              sets: 3,
              restSec: 30,
              sub: 'Nefes düzeni: 3 adım al, 3 adım ver.'),
          ExerciseStep(
              name: 'Dinamik esneme',
              seconds: 45,
              sets: 2,
              restSec: 15,
              sub: 'Diz çekme + topuk vurma.'),
          ExerciseStep(name: 'Soğuma yürüyüş', seconds: 180, sets: 1, restSec: 0),
          ExerciseStep(
              name: 'Statik baldır esnetme',
              seconds: 30,
              sets: 2,
              restSec: 10),
        ],
      ),
      ProgramLevelDef(
        index: 1,
        name: 'Hafta 2 · İnterval',
        tagline: 'Tempo artır, dinlen, tekrarla.',
        exercises: [
          ExerciseStep(name: 'Isınma', seconds: 180, sets: 1, restSec: 0),
          ExerciseStep(
              name: 'Hızlı tempo',
              seconds: 120,
              sets: 4,
              restSec: 60,
              sub: '2 dk hızlı, 1 dk sakin.'),
          ExerciseStep(
              name: 'Topuk-burun yürüyüş',
              seconds: 45,
              sets: 3,
              restSec: 20,
              sub: 'Denge için.'),
          ExerciseStep(
              name: 'Yan yürüyüş',
              seconds: 30,
              sets: 3,
              restSec: 15,
              sub: 'Glute aktivasyon.'),
          ExerciseStep(name: 'Düz tempo', seconds: 180, sets: 2, restSec: 30),
          ExerciseStep(name: 'Soğuma', seconds: 180, sets: 1, restSec: 0),
        ],
      ),
      ProgramLevelDef(
        index: 2,
        name: 'Hafta 3 · Eğim',
        tagline: 'Yokuş veya treadmill eğim.',
        exercises: [
          ExerciseStep(name: 'Isınma', seconds: 180, sets: 1, restSec: 0),
          ExerciseStep(
              name: 'Yokuş yukarı',
              seconds: 180,
              sets: 4,
              restSec: 60,
              sub: '%5-8 eğim hedefle.'),
          ExerciseStep(
              name: 'Düz tempo',
              seconds: 120,
              sets: 2,
              restSec: 30,
              sub: 'Nabızı düşürme arası.'),
          ExerciseStep(
              name: 'Yokuş aşağı kontrol',
              seconds: 90,
              sets: 2,
              restSec: 30,
              sub: 'Diz hafif bükük, küçük adımlar.'),
          ExerciseStep(
              name: 'Sürat yürüyüş',
              seconds: 60,
              sets: 3,
              restSec: 30),
          ExerciseStep(name: 'Soğuma', seconds: 180, sets: 1, restSec: 0),
        ],
      ),
      ProgramLevelDef(
        index: 3,
        name: 'Hafta 4 · Power Walk',
        tagline: 'Tempo + kol + nefes.',
        exercises: [
          ExerciseStep(name: 'Isınma', seconds: 180, sets: 1, restSec: 0),
          ExerciseStep(
              name: 'Power Walk + kol',
              seconds: 240,
              sets: 4,
              restSec: 60,
              sub: 'Kol salınımı 90 derece, karın aktif.'),
          ExerciseStep(
              name: 'Knee Lift Walk',
              seconds: 60,
              sets: 3,
              restSec: 30,
              sub: 'Dizi göğse doğru çek.'),
          ExerciseStep(
              name: 'Side Step',
              seconds: 45,
              sets: 3,
              restSec: 20,
              sub: 'Mini band varsa eklenir.'),
          ExerciseStep(
              name: 'Sprint sürüş',
              seconds: 30,
              sets: 4,
              restSec: 60,
              sub: 'Maksimumun %85\'i.'),
          ExerciseStep(
              name: 'Tempo finiş',
              seconds: 120,
              sets: 2,
              restSec: 30),
          ExerciseStep(name: 'Soğuma stretch', seconds: 180, sets: 1, restSec: 0),
        ],
      ),
    ],
  ),
];

ProgramDefinition? programById(String id) {
  for (final p in kProgramCatalog) {
    if (p.id == id) return p;
  }
  return null;
}
