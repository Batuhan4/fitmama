import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../data/models/exercise_session.dart';
import '../../../data/models/profile.dart';
import '../../../data/repositories/app_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../utils/id.dart';
import '../../../utils/localized.dart';
import '../../core/widgets/momrise_card.dart';

class _VideoEx {
  const _VideoEx({
    required this.id,
    required this.level,
    required this.title,
    required this.desc,
    required this.durationMin,
    required this.category,
    required this.csectionSafe,
    required this.youtubeId,
  });
  final String id;
  final int level;
  final L title;
  final L desc;
  final int durationMin;
  final String category;
  final bool csectionSafe;
  final String youtubeId;
}

const _videos = <_VideoEx>[
  _VideoEx(
      id: 'v1',
      level: 1,
      title: L('Diyafram nefesi (5 dk)', 'Diaphragmatic breathing (5 min)',
          more: {
            'hi': 'डायाफ्रामिक श्वास (५ मिनट)',
            'pt': 'Respiração diafragmática (5 min)',
            'es': 'Respiración diafragmática (5 min)',
            'id': 'Pernapasan diafragma (5 mnt)',
            'ur': 'ڈایافرامیٹک سانس (۵ منٹ)',
            'bn': 'ডায়াফ্রাম্যাটিক শ্বাস (৫ মিনিট)',
            'ar': 'التنفس الحجابي (5 د)',
            'ru': 'Диафрагмальное дыхание (5 мин)',
            'de': 'Zwerchfellatmung (5 Min)',
            'fr': 'Respiration diaphragmatique (5 min)',
            'it': 'Respirazione diaframmatica (5 min)',
            'ja': '横隔膜呼吸（5分）',
            'ko': '횡격막 호흡 (5분)',
            'zh': '腹式呼吸（5分钟）',
            'fil': 'Paghinga ng diaphragm (5 min)',
            'vi': 'Thở bằng cơ hoành (5 phút)',
            'fa': 'تنفس دیافراگمی (۵ دقیقه)',
            'pl': 'Oddychanie przeponowe (5 min)',
          }),
      desc: L('Karın derinden yumuşak nefes.', 'Soft, deep belly breaths.',
          more: {
            'hi': 'पेट से गहरी, कोमल साँसें।',
            'pt': 'Respirações suaves e profundas da barriga.',
            'es': 'Respiraciones suaves y profundas del vientre.',
            'id': 'Napas perut dalam dan lembut.',
            'ur': 'پیٹ سے گہری، نرم سانسیں۔',
            'bn': 'পেট থেকে গভীর, নরম শ্বাস।',
            'ar': 'أنفاس عميقة ولطيفة من البطن.',
            'ru': 'Мягкие глубокие вдохи животом.',
            'de': 'Sanfte, tiefe Bauchatmung.',
            'fr': 'Respirations douces et profondes du ventre.',
            'it': 'Respiro profondo e morbido della pancia.',
            'ja': 'お腹からの柔らかく深い呼吸。',
            'ko': '부드럽고 깊은 배 호흡.',
            'zh': '柔和深长的腹式呼吸。',
            'fil': 'Malambot at malalim na paghinga sa tiyan.',
            'vi': 'Hơi thở bụng sâu và nhẹ nhàng.',
            'fa': 'نفس‌های نرم و عمیق شکمی.',
            'pl': 'Miękkie, głębokie oddechy brzuchem.',
          }),
      durationMin: 5,
      category: 'breath',
      csectionSafe: true,
      youtubeId: 'ThKahimNQP0'),
  _VideoEx(
      id: 'v2',
      level: 1,
      title: L('Yumuşak boyun-omuz esneme', 'Gentle neck & shoulder stretch',
          more: {
            'hi': 'कोमल गर्दन और कंधे का स्ट्रेच',
            'pt': 'Alongamento suave do pescoço e ombros',
            'es': 'Estiramiento suave de cuello y hombros',
            'id': 'Peregangan leher dan bahu yang lembut',
            'ur': 'نرم گردن اور کندھے کا اسٹریچ',
            'bn': 'মৃদু ঘাড় ও কাঁধের স্ট্রেচ',
            'ar': 'تمدد لطيف للرقبة والكتفين',
            'ru': 'Мягкая растяжка шеи и плеч',
            'de': 'Sanftes Nacken-Schulter-Dehnen',
            'fr': 'Étirement doux du cou et des épaules',
            'it': 'Stretching delicato di collo e spalle',
            'ja': '優しい首と肩のストレッチ',
            'ko': '부드러운 목과 어깨 스트레칭',
            'zh': '温和的颈肩拉伸',
            'fil': 'Mahinang pag-unat ng leeg at balikat',
            'vi': 'Kéo giãn nhẹ cổ và vai',
            'fa': 'کشش نرم گردن و شانه',
            'pl': 'Delikatne rozciąganie szyi i ramion',
          }),
      desc: L('Emzirme sonrası gerginlik için.', 'Helps post-nursing tension.',
          more: {
            'hi': 'स्तनपान के बाद के तनाव के लिए।',
            'pt': 'Ajuda a tensão pós-amamentação.',
            'es': 'Ayuda con la tensión post-lactancia.',
            'id': 'Membantu ketegangan setelah menyusui.',
            'ur': 'دودھ پلانے کے بعد کے تناؤ کے لیے۔',
            'bn': 'স্তন্যপানের পরের টান কমাতে।',
            'ar': 'يساعد في تخفيف التوتر بعد الرضاعة.',
            'ru': 'Помогает при напряжении после кормления.',
            'de': 'Hilft bei Verspannungen nach dem Stillen.',
            'fr': "Aide contre les tensions post-allaitement.",
            'it': "Aiuta contro la tensione post-allattamento.",
            'ja': '授乳後の緊張を和らげます。',
            'ko': '수유 후 긴장 완화에 도움.',
            'zh': '帮助缓解哺乳后的紧张。',
            'fil': 'Tumutulong sa tensyon pagkatapos magpasuso.',
            'vi': 'Giúp giảm căng thẳng sau khi cho bú.',
            'fa': 'کمک به تنش پس از شیردهی.',
            'pl': 'Pomaga na napięcie po karmieniu.',
          }),
      durationMin: 6,
      category: 'stretch',
      csectionSafe: true,
      youtubeId: '2NOsE-VPpkE'),
  _VideoEx(
      id: 'v3',
      level: 1,
      title: L('Kegel & pelvik taban', 'Kegel & pelvic floor', more: {
        'hi': 'केगल और पेल्विक फ्लोर',
        'pt': 'Kegel e assoalho pélvico',
        'es': 'Kegel y suelo pélvico',
        'id': 'Kegel & dasar panggul',
        'ur': 'کیگل اور پیلوک فلور',
        'bn': 'কেগেল ও পেলভিক ফ্লোর',
        'ar': 'كيغل وقاع الحوض',
        'ru': 'Кегель и тазовое дно',
        'de': 'Kegel & Beckenboden',
        'fr': 'Kegel et plancher pelvien',
        'it': 'Kegel e pavimento pelvico',
        'ja': 'ケーゲル＆骨盤底',
        'ko': '케겔 & 골반저',
        'zh': '凯格尔与盆底肌',
        'fil': 'Kegel at pelvic floor',
        'vi': 'Kegel & sàn chậu',
        'fa': 'کگل و کف لگن',
        'pl': 'Kegel i dno miednicy',
      }),
      desc: L('Temel pelvik taban farkındalığı.',
          'Basic pelvic-floor awareness.', more: {
            'hi': 'बुनियादी पेल्विक फ्लोर जागरूकता।',
            'pt': 'Consciência básica do assoalho pélvico.',
            'es': 'Conciencia básica del suelo pélvico.',
            'id': 'Kesadaran dasar panggul dasar.',
            'ur': 'بنیادی پیلوک فلور آگاہی۔',
            'bn': 'মৌলিক পেলভিক ফ্লোর সচেতনতা।',
            'ar': 'الوعي الأساسي بقاع الحوض.',
            'ru': 'Базовое осознание тазового дна.',
            'de': 'Grundlegendes Beckenboden-Bewusstsein.',
            'fr': 'Conscience de base du plancher pelvien.',
            'it': 'Consapevolezza di base del pavimento pelvico.',
            'ja': '基本的な骨盤底の意識。',
            'ko': '기본 골반저 인식.',
            'zh': '基本的盆底肌意识。',
            'fil': 'Pangunahing kamalayan sa pelvic floor.',
            'vi': 'Nhận thức cơ bản về sàn chậu.',
            'fa': 'آگاهی پایه از کف لگن.',
            'pl': 'Podstawowa świadomość dna miednicy.',
          }),
      durationMin: 7,
      category: 'pelvic',
      csectionSafe: true,
      youtubeId: 'AfyIQu8nTcI'),
  _VideoEx(
      id: 'v5',
      level: 2,
      title: L('Postpartum hafif yoga', 'Postpartum light yoga', more: {
        'hi': 'प्रसवोत्तर हल्का योग',
        'pt': 'Ioga leve pós-parto',
        'es': 'Yoga ligero posparto',
        'id': 'Yoga ringan pasca-melahirkan',
        'ur': 'زچگی کے بعد ہلکی یوگا',
        'bn': 'প্রসবোত্তর হালকা যোগ',
        'ar': 'يوغا خفيفة بعد الولادة',
        'ru': 'Лёгкая йога после родов',
        'de': 'Sanftes Yoga nach der Geburt',
        'fr': 'Yoga léger post-partum',
        'it': 'Yoga leggero post-parto',
        'ja': '産後ライトヨガ',
        'ko': '산후 가벼운 요가',
        'zh': '产后轻度瑜伽',
        'fil': 'Magaan na yoga pagkatapos ng panganganak',
        'vi': 'Yoga nhẹ sau sinh',
        'fa': 'یوگای سبک پس از زایمان',
        'pl': 'Lekka joga poporodowa',
      }),
      desc: L('Akış halinde nazik pozlar.', 'Gentle flow of soft poses.',
          more: {
            'hi': 'कोमल मुद्राओं का प्रवाह।',
            'pt': 'Fluxo suave de poses calmas.',
            'es': 'Flujo suave de posturas suaves.',
            'id': 'Aliran lembut dari pose-pose lunak.',
            'ur': 'نرم پوز کا ہلکا سلسلہ۔',
            'bn': 'নরম ভঙ্গির মৃদু প্রবাহ।',
            'ar': 'تدفق لطيف من الوضعيات الناعمة.',
            'ru': 'Мягкий поток нежных поз.',
            'de': 'Sanfter Fluss sanfter Haltungen.',
            'fr': 'Flux doux de poses souples.',
            'it': 'Flusso delicato di posizioni morbide.',
            'ja': 'ソフトなポーズの優しい流れ。',
            'ko': '부드러운 자세의 흐름.',
            'zh': '柔和体式的流畅序列。',
            'fil': 'Mahinang daloy ng malalambot na pose.',
            'vi': 'Dòng chảy nhẹ nhàng của các tư thế mềm mại.',
            'fa': 'جریان ملایمی از حالت‌های نرم.',
            'pl': 'Łagodny przepływ miękkich pozycji.',
          }),
      durationMin: 15,
      category: 'yoga',
      csectionSafe: true,
      youtubeId: 'uIQuVjOLPb8'),
  _VideoEx(
      id: 'v6',
      level: 2,
      title: L('Köprü & kalça köprüleme', 'Bridge & hip bridge', more: {
        'hi': 'ब्रिज और हिप ब्रिज',
        'pt': 'Ponte e ponte de quadril',
        'es': 'Puente y puente de cadera',
        'id': 'Jembatan & jembatan pinggul',
        'ur': 'برج اور کولہے کا برج',
        'bn': 'ব্রিজ ও হিপ ব্রিজ',
        'ar': 'الجسر وجسر الورك',
        'ru': 'Мостик и ягодичный мостик',
        'de': 'Brücke & Hüftbrücke',
        'fr': 'Pont et pont de hanche',
        'it': "Ponte e ponte dell'anca",
        'ja': 'ブリッジ＆ヒップブリッジ',
        'ko': '브릿지 & 힙 브릿지',
        'zh': '桥式和臀部桥式',
        'fil': 'Bridge at hip bridge',
        'vi': 'Cầu & cầu hông',
        'fa': 'پل و پل لگن',
        'pl': 'Mostek i mostek biodrowy',
      }),
      desc: L('Pelvik bölgeyi destekleyen güç.',
          'Strength that supports the pelvic region.', more: {
            'hi': 'पेल्विक क्षेत्र को सहारा देने वाली ताकत।',
            'pt': 'Força que apoia a região pélvica.',
            'es': 'Fuerza que apoya la región pélvica.',
            'id': 'Kekuatan yang mendukung daerah panggul.',
            'ur': 'طاقت جو پیلوک علاقے کی حمایت کرتی ہے۔',
            'bn': 'শক্তি যা পেলভিক এলাকাকে সমর্থন করে।',
            'ar': 'قوة تدعم منطقة الحوض.',
            'ru': 'Сила, поддерживающая область таза.',
            'de': 'Kraft, die die Beckenregion unterstützt.',
            'fr': 'Force qui soutient la région pelvienne.',
            'it': 'Forza che supporta la regione pelvica.',
            'ja': '骨盤領域を支える力。',
            'ko': '골반 부위를 지지하는 힘.',
            'zh': '支撑骨盆区域的力量。',
            'fil': 'Lakas na sumusuporta sa pelvic region.',
            'vi': 'Sức mạnh hỗ trợ vùng chậu.',
            'fa': 'قدرتی که ناحیه لگن را حمایت می‌کند.',
            'pl': 'Siła wspierająca okolice miednicy.',
          }),
      durationMin: 12,
      category: 'pelvic',
      csectionSafe: false,
      youtubeId: 'wPM8icPu6H8'),
  _VideoEx(
      id: 'v7',
      level: 2,
      title: L('Postür düzeltme rutini', 'Posture correction routine', more: {
        'hi': 'मुद्रा सुधार दिनचर्या',
        'pt': 'Rotina de correção de postura',
        'es': 'Rutina de corrección de postura',
        'id': 'Rutinitas koreksi postur',
        'ur': 'کرنسی درستی کا معمول',
        'bn': 'ভঙ্গি সংশোধনের রুটিন',
        'ar': 'روتين تصحيح الوضعية',
        'ru': 'Рутина коррекции осанки',
        'de': 'Haltungs-Korrektur-Routine',
        'fr': 'Routine de correction de posture',
        'it': 'Routine di correzione della postura',
        'ja': '姿勢矯正ルーティン',
        'ko': '자세 교정 루틴',
        'zh': '体态矫正训练',
        'fil': 'Routine ng pagwawasto ng postura',
        'vi': 'Thói quen điều chỉnh tư thế',
        'fa': 'روال اصلاح وضعیت بدن',
        'pl': 'Rutyna korekcji postawy',
      }),
      desc: L('Sırt-omuz kasları için.', 'For the back and shoulder muscles.',
          more: {
            'hi': 'पीठ और कंधे की मांसपेशियों के लिए।',
            'pt': 'Para os músculos das costas e ombros.',
            'es': 'Para los músculos de la espalda y hombros.',
            'id': 'Untuk otot punggung dan bahu.',
            'ur': 'کمر اور کندھے کے پٹھوں کے لیے۔',
            'bn': 'পিঠ ও কাঁধের পেশির জন্য।',
            'ar': 'لعضلات الظهر والكتفين.',
            'ru': 'Для мышц спины и плеч.',
            'de': 'Für die Rücken- und Schultermuskulatur.',
            'fr': 'Pour les muscles du dos et des épaules.',
            'it': 'Per i muscoli di schiena e spalle.',
            'ja': '背中と肩の筋肉のために。',
            'ko': '등과 어깨 근육을 위해.',
            'zh': '针对背部和肩部肌肉。',
            'fil': 'Para sa mga kalamnan ng likod at balikat.',
            'vi': 'Cho cơ lưng và vai.',
            'fa': 'برای عضلات پشت و شانه.',
            'pl': 'Dla mięśni pleców i ramion.',
          }),
      durationMin: 10,
      category: 'posture',
      csectionSafe: true,
      youtubeId: 'vHUjAx-smh8'),
  _VideoEx(
      id: 'v8',
      level: 2,
      title: L('20 dk düşük etkili kardiyo', '20-min low-impact cardio', more: {
        'hi': '२० मिनट कम प्रभाव कार्डियो',
        'pt': '20 min de cardio de baixo impacto',
        'es': '20 min de cardio de bajo impacto',
        'id': '20 mnt kardio berdampak rendah',
        'ur': '۲۰ منٹ کم اثر کارڈیو',
        'bn': '২০ মিনিট কম প্রভাবের কার্ডিও',
        'ar': '20 دقيقة كارديو منخفض التأثير',
        'ru': '20 мин низкоударного кардио',
        'de': '20 Min gelenkschonendes Cardio',
        'fr': '20 min de cardio à faible impact',
        'it': '20 min di cardio a basso impatto',
        'ja': '20分の低衝撃カーディオ',
        'ko': '20분 저충격 유산소',
        'zh': '20分钟低冲击有氧',
        'fil': '20 min low-impact cardio',
        'vi': '20 phút cardio tác động thấp',
        'fa': '۲۰ دقیقه کاردیو کم‌تأثیر',
        'pl': '20-minutowe cardio o niskim wpływie',
      }),
      desc: L('Eklem dostu, yürüyüş tarzı.', 'Joint-friendly, walking style.',
          more: {
            'hi': 'जोड़ों के अनुकूल, चलने की शैली।',
            'pt': 'Amigo das articulações, estilo caminhada.',
            'es': 'Amigable con las articulaciones, estilo caminata.',
            'id': 'Ramah sendi, gaya berjalan.',
            'ur': 'جوڑوں کے لیے دوستانہ، چلنے کا انداز۔',
            'bn': 'জয়েন্ট-বান্ধব, হাঁটার স্টাইল।',
            'ar': 'صديق للمفاصل، أسلوب المشي.',
            'ru': 'Бережный для суставов, стиль ходьбы.',
            'de': 'Gelenkschonend, im Gehstil.',
            'fr': 'Amical pour les articulations, style marche.',
            'it': "Amico delle articolazioni, stile camminata.",
            'ja': '関節に優しい、ウォーキングスタイル。',
            'ko': '관절에 부담 없는 걷기 스타일.',
            'zh': '关节友好型步行方式。',
            'fil': 'Friendly sa kasu-kasuan, estilo ng paglalakad.',
            'vi': 'Thân thiện với khớp, kiểu đi bộ.',
            'fa': 'مفصل‌دوست، سبک پیاده‌روی.',
            'pl': 'Przyjazny dla stawów, w stylu spaceru.',
          }),
      durationMin: 20,
      category: 'walk',
      csectionSafe: true,
      youtubeId: 'enYITYwvPAQ'),
  _VideoEx(
      id: 'v9',
      level: 3,
      title: L('Karın toparlama (diastasis dostu)',
          'Core recovery (diastasis-friendly)', more: {
            'hi': 'कोर रिकवरी (डायस्टेसिस-अनुकूल)',
            'pt': 'Recuperação do core (amiga da diástase)',
            'es': 'Recuperación del core (amiga de la diástasis)',
            'id': 'Pemulihan inti (ramah diastasis)',
            'ur': 'کور ریکوری (ڈائیسٹیسیس دوستانہ)',
            'bn': 'কোর রিকভারি (ডায়াস্টেসিস-বান্ধব)',
            'ar': 'استعادة الجذع (صديق للانبساط العضلي)',
            'ru': 'Восстановление кора (безопасно при диастазе)',
            'de': 'Core-Erholung (diastase-freundlich)',
            'fr': 'Récupération du tronc (diastase-friendly)',
            'it': 'Recupero del core (adatto alla diastasi)',
            'ja': '体幹回復（腹直筋離開対応）',
            'ko': '코어 회복 (이탈선 친화적)',
            'zh': '核心恢复（适合腹直肌分离）',
            'fil': 'Pagbawi ng core (diastasis-friendly)',
            'vi': 'Phục hồi cốt lõi (thân thiện với diastasis)',
            'fa': 'بازیابی مرکز بدن (مناسب برای دیاستازیس)',
            'pl': 'Odbudowa centrum (przyjazna rozejściu mięśni)',
          }),
      desc: L('Güvenli karın aktivasyonu.', 'Safe core activation.', more: {
        'hi': 'सुरक्षित कोर सक्रियण।',
        'pt': 'Ativação segura do core.',
        'es': 'Activación segura del core.',
        'id': 'Aktivasi inti yang aman.',
        'ur': 'محفوظ کور ایکٹیویشن۔',
        'bn': 'নিরাপদ কোর অ্যাক্টিভেশন।',
        'ar': 'تنشيط آمن للجذع.',
        'ru': 'Безопасная активация кора.',
        'de': 'Sichere Core-Aktivierung.',
        'fr': 'Activation sécurisée du tronc.',
        'it': 'Attivazione sicura del core.',
        'ja': '安全な体幹活性化。',
        'ko': '안전한 코어 활성화.',
        'zh': '安全的核心激活。',
        'fil': 'Ligtas na pag-activate ng core.',
        'vi': 'Kích hoạt cốt lõi an toàn.',
        'fa': 'فعال‌سازی ایمن مرکز بدن.',
        'pl': 'Bezpieczna aktywacja centrum.',
      }),
      durationMin: 18,
      category: 'pelvic',
      csectionSafe: false,
      youtubeId: 'S-Q1bI4uhJk'),
  _VideoEx(
      id: 'v10',
      level: 3,
      title: L('Tam vücut güçlendirme', 'Full-body strengthening', more: {
        'hi': 'पूरे शरीर को मजबूत करना',
        'pt': 'Fortalecimento total do corpo',
        'es': 'Fortalecimiento de todo el cuerpo',
        'id': 'Penguatan seluruh tubuh',
        'ur': 'پورے جسم کی مضبوطی',
        'bn': 'পুরো শরীর শক্তিশালীকরণ',
        'ar': 'تقوية الجسم بالكامل',
        'ru': 'Укрепление всего тела',
        'de': 'Ganzkörper-Kräftigung',
        'fr': 'Renforcement complet du corps',
        'it': 'Rafforzamento di tutto il corpo',
        'ja': '全身強化',
        'ko': '전신 강화',
        'zh': '全身力量训练',
        'fil': 'Pagpapalakas ng buong katawan',
        'vi': 'Tăng cường toàn thân',
        'fa': 'تقویت تمام بدن',
        'pl': 'Wzmocnienie całego ciała',
      }),
      desc: L('Hafif ağırlıkla 25 dk.', '25 min with light weights.', more: {
        'hi': 'हल्के वजन के साथ २५ मिनट।',
        'pt': '25 min com pesos leves.',
        'es': '25 min con pesas ligeras.',
        'id': '25 mnt dengan beban ringan.',
        'ur': 'ہلکے وزن کے ساتھ ۲۵ منٹ۔',
        'bn': 'হালকা ওজন নিয়ে ২৫ মিনিট।',
        'ar': '25 دقيقة بأوزان خفيفة.',
        'ru': '25 мин с лёгкими весами.',
        'de': '25 Min mit leichten Gewichten.',
        'fr': '25 min avec des poids légers.',
        'it': '25 min con pesi leggeri.',
        'ja': '軽いウェイトで25分。',
        'ko': '가벼운 무게로 25분.',
        'zh': '轻重量25分钟。',
        'fil': '25 min na may magaan na timbang.',
        'vi': '25 phút với tạ nhẹ.',
        'fa': '۲۵ دقیقه با وزنه‌های سبک.',
        'pl': '25 min z lekkimi ciężarami.',
      }),
      durationMin: 25,
      category: 'yoga',
      csectionSafe: false,
      youtubeId: 'ml6cT4AZdqI'),
  _VideoEx(
      id: 'v11',
      level: 3,
      title: L('Postpartum HIIT (düşük etki)', 'Postpartum HIIT (low-impact)',
          more: {
            'hi': 'प्रसवोत्तर HIIT (कम प्रभाव)',
            'pt': 'HIIT pós-parto (baixo impacto)',
            'es': 'HIIT posparto (bajo impacto)',
            'id': 'HIIT pasca-melahirkan (berdampak rendah)',
            'ur': 'زچگی کے بعد HIIT (کم اثر)',
            'bn': 'প্রসবোত্তর HIIT (কম প্রভাব)',
            'ar': 'HIIT بعد الولادة (منخفض التأثير)',
            'ru': 'Послеродовое HIIT (низкоударное)',
            'de': 'Postpartales HIIT (gelenkschonend)',
            'fr': 'HIIT post-partum (faible impact)',
            'it': 'HIIT post-parto (basso impatto)',
            'ja': '産後HIIT（低衝撃）',
            'ko': '산후 HIIT (저충격)',
            'zh': '产后HIIT（低冲击）',
            'fil': 'Postpartum HIIT (low-impact)',
            'vi': 'HIIT sau sinh (tác động thấp)',
            'fa': 'HIIT پس از زایمان (کم‌تأثیر)',
            'pl': 'HIIT poporodowe (nisko wpłyniowe)',
          }),
      desc: L('Daha enerjik bir tempo.', 'A more energetic pace.', more: {
        'hi': 'अधिक ऊर्जावान गति।',
        'pt': 'Um ritmo mais energético.',
        'es': 'Un ritmo más enérgico.',
        'id': 'Tempo yang lebih energik.',
        'ur': 'زیادہ توانائی بخش رفتار۔',
        'bn': 'আরও উদ্যমী গতি।',
        'ar': 'وتيرة أكثر حيوية.',
        'ru': 'Более энергичный темп.',
        'de': 'Ein energischeres Tempo.',
        'fr': 'Un rythme plus énergique.',
        'it': 'Un ritmo più energico.',
        'ja': 'よりエネルギッシュなペース。',
        'ko': '더 활기찬 속도.',
        'zh': '更有活力的节奏。',
        'fil': 'Mas masiglang bilis.',
        'vi': 'Nhịp độ tràn đầy năng lượng hơn.',
        'fa': 'یک گام پرانرژی‌تر.',
        'pl': 'Bardziej energetyczne tempo.',
      }),
      durationMin: 20,
      category: 'walk',
      csectionSafe: false,
      youtubeId: 'VHyGqsPOUHs'),
];

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key, required this.repository});

  final AppRepository repository;

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  int _level = 1;
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
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    });
  }

  Future<void> _markDone(_VideoEx v) async {
    await widget.repository.addExercise(
      ExerciseSession(
        id: uid(),
        exerciseId: v.id,
        category: v.category,
        durationMin: v.durationMin,
        doneAt: DateTime.now().toIso8601String(),
      ),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✓ ${v.title.of(context)}')),
    );
  }

  Map<int, int> _completedByLevel() {
    final result = <int, int>{1: 0, 2: 0, 3: 0};
    for (final s in widget.repository.exercises) {
      final v = _videos.firstWhere(
        (x) => x.id == s.exerciseId,
        orElse: () => const _VideoEx(
          id: '',
          level: 0,
          title: L('', ''),
          desc: L('', ''),
          durationMin: 0,
          category: '',
          csectionSafe: false,
          youtubeId: '',
        ),
      );
      if (v.level > 0) {
        result[v.level] = (result[v.level] ?? 0) + 1;
      }
    }
    return result;
  }

  bool _isUnlocked(int level, Map<int, int> done) {
    if (level == 1) return true;
    if (level == 2) return (done[1] ?? 0) >= 3;
    return (done[2] ?? 0) >= 3;
  }

  String _levelName(int level, AppLocalizations t) {
    switch (level) {
      case 1:
        return t.vidL1Name;
      case 2:
        return t.vidL2Name;
      default:
        return t.vidL3Name;
    }
  }

  String _levelDesc(int level, AppLocalizations t) {
    switch (level) {
      case 1:
        return t.vidL1Desc;
      case 2:
        return t.vidL2Desc;
      default:
        return t.vidL3Desc;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final profile = widget.repository.profile;
    final isC = profile?.birthType == BirthType.csection;
    final done = _completedByLevel();
    final list = _videos
        .where((v) => v.level == _level)
        .where((v) => !isC || v.csectionSafe || _level == 3)
        .toList();

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller ??
            YoutubePlayerController(initialVideoId: ''),
      ),
      builder: (context, player) {
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            GradientCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome_rounded, size: 16),
                      const SizedBox(width: 6),
                      Text(t.vidHeadline, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(t.vidSub,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: scheme.onPrimary)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [1, 2, 3].map((lvl) {
                final unlocked = _isUnlocked(lvl, done);
                final active = _level == lvl;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: lvl == 3 ? 0 : 8,
                    ),
                    child: InkWell(
                      onTap:
                          unlocked ? () => setState(() => _level = lvl) : null,
                      borderRadius: BorderRadius.circular(14),
                      child: Opacity(
                        opacity: unlocked ? 1 : 0.5,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: active ? scheme.primary : scheme.surface,
                            border: Border.all(
                              color: active ? scheme.primary : scheme.outline,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (!unlocked) ...[
                                    Icon(Icons.lock_outline,
                                        size: 10,
                                        color: scheme.onSurfaceVariant),
                                    const SizedBox(width: 4),
                                  ],
                                  Text(
                                    t.vidLevel,
                                    style: TextStyle(
                                      fontSize: 10,
                                      letterSpacing: 1.2,
                                      color: active
                                          ? scheme.onPrimary
                                          : scheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '$lvl',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: active
                                          ? scheme.onPrimary
                                          : scheme.onSurface,
                                    ),
                              ),
                              Text(
                                _levelName(lvl, t),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: active
                                      ? scheme.onPrimary
                                      : scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            if (_isUnlocked(_level, done))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  _levelDesc(_level, t),
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            if (isC && _level >= 2) ...[
              const SizedBox(height: 8),
              MomriseCard(
                color: const Color(0xFFFEF3C7),
                padding: const EdgeInsets.all(12),
                child: Text('⚠ ${t.exCsectionNote}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF92400E),
                    )),
              ),
            ],
            const SizedBox(height: 12),
            ...list.map((v) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MomriseCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: _activeVideoId == v.youtubeId &&
                                    _controller != null
                                ? YoutubePlayer(
                                    controller: _controller!,
                                    showVideoProgressIndicator: true,
                                    progressIndicatorColor: scheme.primary,
                                    onReady: () {},
                                  )
                                : Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.network(
                                        'https://i.ytimg.com/vi/${v.youtubeId}/hqdefault.jpg',
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, a, b) => Container(
                                          color: scheme.surfaceContainerHighest,
                                        ),
                                      ),
                                      Container(
                                        color:
                                            Colors.black.withValues(alpha: 0.3),
                                      ),
                                      Center(
                                        child: InkWell(
                                          onTap: () => _playVideo(v.youtubeId),
                                          customBorder: const CircleBorder(),
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: scheme.primary,
                                            ),
                                            child: const Icon(
                                              Icons.play_arrow_rounded,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${t.vidLevel} ${v.level} · ${v.durationMin} dk',
                                style: TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 1.1,
                                  color: scheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(v.title.of(context),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text(v.desc.of(context),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: scheme.onSurfaceVariant,
                                  )),
                              const SizedBox(height: 10),
                              OutlinedButton.icon(
                                onPressed: () => _markDone(v),
                                icon: const Icon(Icons.check_rounded, size: 16),
                                label: Text(t.exMarkDone),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(40),
                                ),
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
}
