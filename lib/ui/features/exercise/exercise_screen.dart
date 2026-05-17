import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../data/models/exercise_session.dart';
import '../../../data/models/profile.dart';
import '../../../data/repositories/app_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../utils/date_utils.dart';
import '../../../utils/id.dart';
import '../../../utils/localized.dart';
import '../../core/widgets/momrise_card.dart';

enum ExCategory { yoga, stretch, breath, pelvic, walk, posture }

class _Move {
  const _Move({
    required this.id,
    required this.cat,
    required this.title,
    required this.desc,
    required this.durationMin,
    required this.csectionSafe,
    this.youtubeId,
  });
  final String id;
  final ExCategory cat;
  final L title;
  final L desc;
  final int durationMin;
  final bool csectionSafe;
  final String? youtubeId;
}

const _library = <_Move>[
  _Move(
      id: 'y2',
      cat: ExCategory.yoga,
      title: L('Çocuk pozu', "Child's pose", more: {
        'hi': "बाल मुद्रा",
        'pt': "Postura da criança",
        'es': "Postura del niño",
        'id': "Pose anak",
        'ur': "بچے کی پوز",
        'bn': "শিশুর ভঙ্গি",
        'ar': "وضع الطفل",
        'ru': "Поза ребёнка",
        'de': "Stellung des Kindes",
        'fr': "Posture de l'enfant",
        'it': "Posizione del bambino",
        'ja': "チャイルドポーズ",
        'ko': "아기 자세",
        'zh': "婴儿式",
        'fil': "Pose ng bata",
        'vi': "Tư thế em bé",
        'fa': "حالت کودک",
        'pl': "Pozycja dziecka",
      }),
      desc: L('Belin alt bölgesini rahatlatır.', 'Relaxes the lower back.',
          more: {
            'hi': 'पीठ के निचले हिस्से को आराम देता है।',
            'pt': 'Relaxa a parte inferior das costas.',
            'es': 'Relaja la zona lumbar.',
            'id': 'Merilekskan punggung bagian bawah.',
            'ur': 'کمر کے نچلے حصے کو آرام دیتا ہے۔',
            'bn': 'কোমরের নিচের অংশ শিথিল করে।',
            'ar': 'يريح أسفل الظهر.',
            'ru': 'Расслабляет поясницу.',
            'de': 'Entspannt den unteren Rücken.',
            'fr': 'Détend le bas du dos.',
            'it': 'Rilassa la parte bassa della schiena.',
            'ja': '腰をリラックスさせます。',
            'ko': '허리 아래를 이완시킵니다.',
            'zh': '放松下背部。',
            'fil': 'Nagpapahinga sa ibabang likod.',
            'vi': 'Thư giãn vùng lưng dưới.',
            'fa': 'کمر پایین را آرام می‌کند.',
            'pl': 'Rozluźnia dolną część pleców.',
          }),
      durationMin: 4,
      csectionSafe: true,
      youtubeId: 'd6dXwWlQ4xM'),
  _Move(
      id: 's1',
      cat: ExCategory.stretch,
      title: L('Boyun esneme', 'Neck stretch', more: {
        'hi': 'गर्दन का स्ट्रेच',
        'pt': 'Alongamento do pescoço',
        'es': 'Estiramiento de cuello',
        'id': 'Peregangan leher',
        'ur': 'گردن کا اسٹریچ',
        'bn': 'ঘাড় স্ট্রেচ',
        'ar': 'تمدد الرقبة',
        'ru': 'Растяжка шеи',
        'de': 'Nacken-Dehnung',
        'fr': 'Étirement du cou',
        'it': 'Stretching del collo',
        'ja': '首のストレッチ',
        'ko': '목 스트레칭',
        'zh': '颈部拉伸',
        'fil': 'Pag-unat ng leeg',
        'vi': 'Kéo giãn cổ',
        'fa': 'کشش گردن',
        'pl': 'Rozciąganie szyi',
      }),
      desc: L('Emzirme sonrası sertliği geçirir.',
          'Eases nursing-related stiffness.', more: {
            'hi': 'स्तनपान के बाद की जकड़न को कम करता है।',
            'pt': 'Alivia a rigidez pós-amamentação.',
            'es': 'Alivia la rigidez tras la lactancia.',
            'id': 'Meredakan kekakuan setelah menyusui.',
            'ur': 'دودھ پلانے کے بعد کی سختی کو دور کرتا ہے۔',
            'bn': 'স্তন্যপানের পরের শক্তভাব দূর করে।',
            'ar': 'يخفف التيبس بعد الرضاعة.',
            'ru': 'Снимает скованность после кормления.',
            'de': 'Lindert die Steifheit nach dem Stillen.',
            'fr': 'Soulage la raideur post-allaitement.',
            'it': 'Allevia la rigidità post-allattamento.',
            'ja': '授乳後のこわばりを和らげます。',
            'ko': '수유 후 뻣뻣함을 완화합니다.',
            'zh': '缓解哺乳后的僵硬感。',
            'fil': 'Nagpapagaan ng paninigas pagkatapos magpasuso.',
            'vi': 'Giảm cứng sau khi cho con bú.',
            'fa': 'سفتی پس از شیردهی را کاهش می‌دهد.',
            'pl': 'Łagodzi sztywność po karmieniu.',
          }),
      durationMin: 3,
      csectionSafe: true,
      youtubeId: '2NOsE-VPpkE'),
  _Move(
      id: 's2',
      cat: ExCategory.stretch,
      title: L('Omuz çember', 'Shoulder rolls', more: {
        'hi': 'कंधे के चक्र',
        'pt': 'Rotações de ombros',
        'es': 'Círculos de hombros',
        'id': 'Putaran bahu',
        'ur': 'کندھے کے چکر',
        'bn': 'কাঁধের চক্র',
        'ar': 'دوائر الكتف',
        'ru': 'Круговые движения плечами',
        'de': 'Schulterkreisen',
        'fr': "Cercles d'épaules",
        'it': 'Rotazioni delle spalle',
        'ja': '肩回し',
        'ko': '어깨 돌리기',
        'zh': '肩部环绕',
        'fil': 'Pag-ikot ng balikat',
        'vi': 'Xoay vai',
        'fa': 'چرخش شانه',
        'pl': 'Krążenia barków',
      }),
      desc: L('Üst sırt için ferahlatıcı.', 'Refreshing for the upper back.',
          more: {
            'hi': 'ऊपरी पीठ के लिए ताज़गी भरा।',
            'pt': 'Refrescante para a parte superior das costas.',
            'es': 'Refrescante para la parte superior de la espalda.',
            'id': 'Menyegarkan untuk punggung atas.',
            'ur': 'اوپری کمر کے لیے تازگی بخش۔',
            'bn': 'উপরের পিঠের জন্য সতেজকর।',
            'ar': 'منعش للجزء العلوي من الظهر.',
            'ru': 'Освежает верхнюю часть спины.',
            'de': 'Erfrischend für den oberen Rücken.',
            'fr': 'Rafraîchissant pour le haut du dos.',
            'it': 'Rinfrescante per la parte superiore della schiena.',
            'ja': '背中上部をリフレッシュ。',
            'ko': '윗등을 상쾌하게 합니다.',
            'zh': '让上背部清爽。',
            'fil': 'Nakapagpapresko para sa itaas na likod.',
            'vi': 'Làm tươi mát phần lưng trên.',
            'fa': 'با طراوت برای قسمت بالای کمر.',
            'pl': 'Orzeźwiający dla górnej części pleców.',
          }),
      durationMin: 3,
      csectionSafe: true,
      youtubeId: '862lqde0zOg'),
  _Move(
      id: 'b1',
      cat: ExCategory.breath,
      title: L('Diyafram nefesi', 'Diaphragmatic breathing', more: {
        'hi': 'डायाफ्रामिक श्वास',
        'pt': 'Respiração diafragmática',
        'es': 'Respiración diafragmática',
        'id': 'Pernapasan diafragma',
        'ur': 'ڈایافرامیٹک سانس',
        'bn': 'ডায়াফ্রাম্যাটিক শ্বাস',
        'ar': 'التنفس الحجابي',
        'ru': 'Диафрагмальное дыхание',
        'de': 'Zwerchfellatmung',
        'fr': 'Respiration diaphragmatique',
        'it': 'Respirazione diaframmatica',
        'ja': '横隔膜呼吸',
        'ko': '횡격막 호흡',
        'zh': '腹式呼吸',
        'fil': 'Paghinga ng diaphragm',
        'vi': 'Thở bằng cơ hoành',
        'fa': 'تنفس دیافراگمی',
        'pl': 'Oddychanie przeponowe',
      }),
      desc: L('Karın derinden nefes alma.', 'Deep belly breathing.', more: {
        'hi': 'पेट से गहरी साँस लेना।',
        'pt': 'Respiração profunda da barriga.',
        'es': 'Respiración profunda del vientre.',
        'id': 'Pernapasan perut dalam.',
        'ur': 'پیٹ سے گہری سانس لینا۔',
        'bn': 'পেট দিয়ে গভীর শ্বাস।',
        'ar': 'تنفس عميق من البطن.',
        'ru': 'Глубокое дыхание животом.',
        'de': 'Tiefe Bauchatmung.',
        'fr': 'Respiration profonde du ventre.',
        'it': 'Respirazione profonda della pancia.',
        'ja': '深い腹式呼吸。',
        'ko': '깊은 배 호흡.',
        'zh': '用腹部深呼吸。',
        'fil': 'Malalim na paghinga sa tiyan.',
        'vi': 'Thở sâu bằng bụng.',
        'fa': 'نفس عمیق شکمی.',
        'pl': 'Głębokie oddychanie brzuchem.',
      }),
      durationMin: 5,
      csectionSafe: true,
      youtubeId: 'ThKahimNQP0'),
  _Move(
      id: 'p1',
      cat: ExCategory.pelvic,
      title: L('Kegel egzersizi', 'Kegel exercise', more: {
        'hi': 'केगल व्यायाम',
        'pt': 'Exercício Kegel',
        'es': 'Ejercicio de Kegel',
        'id': 'Latihan Kegel',
        'ur': 'کیگل ورزش',
        'bn': 'কেগেল ব্যায়াম',
        'ar': 'تمرين كيغل',
        'ru': 'Упражнение Кегеля',
        'de': 'Kegel-Übung',
        'fr': 'Exercice de Kegel',
        'it': 'Esercizio di Kegel',
        'ja': 'ケーゲル体操',
        'ko': '케겔 운동',
        'zh': '凯格尔运动',
        'fil': 'Ehersisyo ng Kegel',
        'vi': 'Bài tập Kegel',
        'fa': 'تمرین کگل',
        'pl': 'Ćwiczenie Kegla',
      }),
      desc: L('Pelvik tabanı güçlendirir.', 'Strengthens the pelvic floor.',
          more: {
            'hi': 'पेल्विक फ्लोर को मजबूत करता है।',
            'pt': 'Fortalece o assoalho pélvico.',
            'es': 'Fortalece el suelo pélvico.',
            'id': 'Memperkuat dasar panggul.',
            'ur': 'پیلوک فلور کو مضبوط کرتا ہے۔',
            'bn': 'পেলভিক ফ্লোর শক্তিশালী করে।',
            'ar': 'يقوي قاع الحوض.',
            'ru': 'Укрепляет тазовое дно.',
            'de': 'Stärkt den Beckenboden.',
            'fr': 'Renforce le plancher pelvien.',
            'it': 'Rafforza il pavimento pelvico.',
            'ja': '骨盤底を強化します。',
            'ko': '골반저를 강화합니다.',
            'zh': '加强盆底肌。',
            'fil': 'Nagpapalakas ng pelvic floor.',
            'vi': 'Tăng cường sàn chậu.',
            'fa': 'کف لگن را تقویت می‌کند.',
            'pl': 'Wzmacnia dno miednicy.',
          }),
      durationMin: 5,
      csectionSafe: true,
      youtubeId: 'AfyIQu8nTcI'),
  _Move(
      id: 'p2',
      cat: ExCategory.pelvic,
      title: L('Köprü pozu (hafif)', 'Glute bridge (light)', more: {
        'hi': 'ग्लूट ब्रिज (हल्का)',
        'pt': 'Ponte de glúteo (leve)',
        'es': 'Puente de glúteos (suave)',
        'id': 'Jembatan glute (ringan)',
        'ur': 'گلوٹ برج (ہلکا)',
        'bn': 'গ্লুট ব্রিজ (হালকা)',
        'ar': 'جسر الألوية (خفيف)',
        'ru': 'Ягодичный мостик (лёгкий)',
        'de': 'Gesäßbrücke (leicht)',
        'fr': 'Pont fessier (léger)',
        'it': 'Ponte gluteo (leggero)',
        'ja': 'グライドブリッジ（軽度）',
        'ko': '글루트 브릿지 (가벼움)',
        'zh': '臀桥（轻度）',
        'fil': 'Glute bridge (magaan)',
        'vi': 'Cầu mông (nhẹ)',
        'fa': 'پل سرینی (سبک)',
        'pl': 'Mostek pośladkowy (lekki)',
      }),
      desc: L('Pelvik bölgeyi destekler.', 'Supports the pelvic region.',
          more: {
            'hi': 'पेल्विक क्षेत्र को सहारा देता है।',
            'pt': 'Apoia a região pélvica.',
            'es': 'Apoya la región pélvica.',
            'id': 'Mendukung daerah panggul.',
            'ur': 'پیلوک علاقے کی حمایت کرتا ہے۔',
            'bn': 'পেলভিক এলাকাকে সমর্থন করে।',
            'ar': 'يدعم منطقة الحوض.',
            'ru': 'Поддерживает область таза.',
            'de': 'Unterstützt die Beckenregion.',
            'fr': 'Soutient la région pelvienne.',
            'it': 'Supporta la regione pelvica.',
            'ja': '骨盤領域をサポートします。',
            'ko': '골반 부위를 지지합니다.',
            'zh': '支撑骨盆区域。',
            'fil': 'Sinusuportahan ang pelvic region.',
            'vi': 'Hỗ trợ vùng chậu.',
            'fa': 'ناحیه لگن را حمایت می‌کند.',
            'pl': 'Wspiera okolice miednicy.',
          }),
      durationMin: 6,
      csectionSafe: false,
      youtubeId: 'wPM8icPu6H8'),
  _Move(
      id: 'w1',
      cat: ExCategory.walk,
      title: L('Kısa yürüyüş', 'Short walk', more: {
        'hi': 'छोटी सैर',
        'pt': 'Caminhada curta',
        'es': 'Paseo corto',
        'id': 'Jalan kaki pendek',
        'ur': 'چھوٹی چہل قدمی',
        'bn': 'ছোট হাঁটা',
        'ar': 'مشي قصير',
        'ru': 'Короткая прогулка',
        'de': 'Kurzer Spaziergang',
        'fr': 'Courte marche',
        'it': 'Breve passeggiata',
        'ja': '短い散歩',
        'ko': '짧은 산책',
        'zh': '短距离散步',
        'fil': 'Maikling lakad',
        'vi': 'Đi bộ ngắn',
        'fa': 'پیاده‌روی کوتاه',
        'pl': 'Krótki spacer',
      }),
      desc: L('Açık havada 10 dakika.', '10 minutes outdoors.', more: {
        'hi': 'बाहर 10 मिनट।',
        'pt': '10 minutos ao ar livre.',
        'es': '10 minutos al aire libre.',
        'id': '10 menit di luar ruangan.',
        'ur': 'باہر 10 منٹ۔',
        'bn': 'বাইরে ১০ মিনিট।',
        'ar': '10 دقائق في الهواء الطلق.',
        'ru': '10 минут на свежем воздухе.',
        'de': '10 Minuten an der frischen Luft.',
        'fr': '10 minutes en plein air.',
        'it': "10 minuti all'aperto.",
        'ja': '屋外で10分。',
        'ko': '야외에서 10분.',
        'zh': '户外10分钟。',
        'fil': '10 minuto sa labas.',
        'vi': '10 phút ngoài trời.',
        'fa': '۱۰ دقیقه در فضای باز.',
        'pl': '10 minut na świeżym powietrzu.',
      }),
      durationMin: 10,
      csectionSafe: true,
      youtubeId: 'enYITYwvPAQ'),
  _Move(
      id: 'po1',
      cat: ExCategory.posture,
      title: L('Duvar postürü', 'Wall posture', more: {
        'hi': 'दीवार मुद्रा',
        'pt': 'Postura na parede',
        'es': 'Postura de pared',
        'id': 'Postur dinding',
        'ur': 'دیوار کی کرنسی',
        'bn': 'দেয়াল ভঙ্গি',
        'ar': 'وضعية الحائط',
        'ru': 'Стойка у стены',
        'de': 'Wandhaltung',
        'fr': 'Posture au mur',
        'it': 'Postura al muro',
        'ja': '壁での姿勢',
        'ko': '벽 자세',
        'zh': '靠墙姿势',
        'fil': 'Postura sa dingding',
        'vi': 'Tư thế dựa tường',
        'fa': 'حالت دیوار',
        'pl': 'Postawa przy ścianie',
      }),
      desc: L('Duruşunu düzeltir.', 'Improves your posture.', more: {
        'hi': 'आपकी मुद्रा सुधारता है।',
        'pt': 'Melhora sua postura.',
        'es': 'Mejora tu postura.',
        'id': 'Memperbaiki postur tubuh Anda.',
        'ur': 'آپ کی کرنسی بہتر کرتا ہے۔',
        'bn': 'আপনার ভঙ্গি উন্নত করে।',
        'ar': 'يحسن وضعيتك.',
        'ru': 'Улучшает вашу осанку.',
        'de': 'Verbessert deine Haltung.',
        'fr': 'Améliore ta posture.',
        'it': 'Migliora la tua postura.',
        'ja': '姿勢を改善します。',
        'ko': '자세를 개선합니다.',
        'zh': '改善你的体态。',
        'fil': 'Nagpapabuti ng iyong postura.',
        'vi': 'Cải thiện tư thế của bạn.',
        'fa': 'وضعیت بدن شما را بهبود می‌بخشد.',
        'pl': 'Poprawia twoją postawę.',
      }),
      durationMin: 3,
      csectionSafe: true,
      youtubeId: 'vHUjAx-smh8'),
];

IconData _iconFor(ExCategory c) {
  switch (c) {
    case ExCategory.yoga:
      return Icons.self_improvement_rounded;
    case ExCategory.stretch:
      return Icons.accessibility_new_rounded;
    case ExCategory.breath:
      return Icons.air_rounded;
    case ExCategory.pelvic:
      return Icons.favorite_rounded;
    case ExCategory.walk:
      return Icons.directions_walk_rounded;
    case ExCategory.posture:
      return Icons.accessibility_rounded;
  }
}

String _catLabel(ExCategory c, AppLocalizations t) {
  switch (c) {
    case ExCategory.yoga:
      return t.exYoga;
    case ExCategory.stretch:
      return t.exStretch;
    case ExCategory.breath:
      return t.exBreath;
    case ExCategory.pelvic:
      return t.exPelvic;
    case ExCategory.walk:
      return t.exWalk;
    case ExCategory.posture:
      return t.exPosture;
  }
}

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key, required this.repository});

  final AppRepository repository;

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  ExCategory? _filter;
  YoutubePlayerController? _controller;
  String? _activeVideoId;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _playVideo(String youtubeId) {
    if (_activeVideoId == youtubeId) return;
    setState(() {
      _activeVideoId = youtubeId;
      _controller?.dispose();
      _controller = YoutubePlayerController(
        initialVideoId: youtubeId,
        flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
      );
    });
  }

  Future<void> _markDone(_Move m) async {
    await widget.repository.addExercise(
      ExerciseSession(
        id: uid(),
        exerciseId: m.id,
        category: m.cat.name,
        durationMin: m.durationMin,
        doneAt: DateTime.now().toIso8601String(),
      ),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✓ ${m.title.of(context)}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final profile = widget.repository.profile;
    final isC = profile?.birthType == BirthType.csection;

    var list = _library
        .where((m) => _filter == null || m.cat == _filter)
        .where((m) => !isC || m.csectionSafe)
        .toList();
    final quick = _library.where((m) => m.durationMin <= 5).toList();
    final weekStart = startOfWeekMonday(DateTime.now());
    final weekStartKey = dateKey(weekStart);
    final weekDone = widget.repository.exercises
        .where((s) => s.doneAt.substring(0, 10).compareTo(weekStartKey) >= 0)
        .toList();
    final weekMins = weekDone.fold<int>(0, (a, s) => a + s.durationMin);

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller ?? YoutubePlayerController(initialVideoId: ''),
      ),
      builder: (context, player) {
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            if (isC)
              MomriseCard(
                color: const Color(0xFFFEF3C7),
                padding: const EdgeInsets.all(12),
                child: Text(
                  '⚠ ${t.exCsectionNote}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF92400E),
                  ),
                ),
              ),
            if (isC) const SizedBox(height: 12),
            GradientCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.exWeeklyDone, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 6),
                  Text(t.exSummary(weekDone.length, weekMins),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: scheme.onPrimary)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            MomriseCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.timer_outlined,
                          size: 16, color: scheme.primary),
                      const SizedBox(width: 8),
                      Text(t.exQuickMode,
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 2.3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: quick.take(4).map((m) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => _markDone(m),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(_iconFor(m.cat),
                                  size: 16, color: scheme.primary),
                              Text(
                                m.title.of(context),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${m.durationMin} dk',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(t.exCategories,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _catChip(null, t.exAll),
                  for (final c in ExCategory.values)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _catChip(c, _catLabel(c, t)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ...list.map((m) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: MomriseCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (m.youtubeId != null)
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16)),
                              child: _activeVideoId == m.youtubeId &&
                                      _controller != null
                                  ? YoutubePlayer(
                                      controller: _controller!,
                                      showVideoProgressIndicator: true,
                                      progressIndicatorColor: scheme.primary,
                                    )
                                  : Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.network(
                                          'https://i.ytimg.com/vi/${m.youtubeId}/hqdefault.jpg',
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, a, b) =>
                                              Container(color: scheme.surface),
                                        ),
                                        Container(
                                            color: Colors.black38),
                                        Center(
                                          child: IconButton(
                                            icon: const Icon(
                                                Icons.play_circle_fill,
                                                size: 50,
                                                color: Colors.white),
                                            onPressed: () =>
                                                _playVideo(m.youtubeId!),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: scheme.primary.withValues(alpha: 0.12),
                                ),
                                child: Icon(_iconFor(m.cat),
                                    color: scheme.primary, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(m.title.of(context),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        )),
                                    Text(
                                      m.desc.of(context),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: scheme.onSurfaceVariant,
                                      ),
                                    ),
                                    Text(
                                      '${m.durationMin} dk',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: scheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () => _markDone(m),
                                child: const Icon(Icons.check_rounded, size: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 60),
          ],
        );
      },
    );
  }

  Widget _catChip(ExCategory? c, String label) {
    final scheme = Theme.of(context).colorScheme;
    final active = _filter == c;
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => setState(() => _filter = c),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? scheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active ? scheme.primary : scheme.outline,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: active ? scheme.onPrimary : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
