import 'package:flutter/material.dart';

import '../../../data/repositories/app_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../utils/localized.dart';
import '../../core/widgets/momrise_card.dart';

class _RecoveryStage {
  const _RecoveryStage({
    required this.weekFrom,
    required this.weekTo,
    required this.title,
    required this.summary,
    required this.icon,
    required this.tips,
  });
  final int weekFrom;
  final int weekTo;
  final L title;
  final L summary;
  final IconData icon;
  final List<L> tips;
}

const _stages = <_RecoveryStage>[
  _RecoveryStage(
    weekFrom: 0,
    weekTo: 2,
    title: L('İlk 2 hafta — Bağ kurma', 'First 2 weeks — Bonding', more: {
      'hi': 'पहले 2 हफ्ते — जुड़ाव',
      'pt': 'Primeiras 2 semanas — Vínculo',
      'es': 'Primeras 2 semanas — Vínculo',
      'id': '2 minggu pertama — Ikatan',
      'ur': 'پہلے 2 ہفتے — بندھن',
      'bn': 'প্রথম ২ সপ্তাহ — বন্ধন',
      'ar': 'أول أسبوعين — الترابط',
      'ru': 'Первые 2 недели — Привязанность',
      'de': 'Erste 2 Wochen — Bindung',
      'fr': '2 premières semaines — Lien',
      'it': 'Prime 2 settimane — Legame',
      'ja': '最初の2週間 — 絆を育む',
      'ko': '첫 2주 — 유대감',
      'zh': '最初2周 — 建立亲子关系',
      'fil': 'Unang 2 linggo — Pagbubuklod',
      'vi': '2 tuần đầu — Gắn kết',
      'fa': '۲ هفته اول — پیوند',
      'pl': 'Pierwsze 2 tygodnie — Więź',
    }),
    summary: L(
      'Bedenin hızla iyileşiyor. Bol dinlen, yardımı kabul et.',
      'Your body is healing fast. Rest a lot and accept help.',
      more: {
        'hi': 'आपका शरीर तेज़ी से ठीक हो रहा है। खूब आराम करें और मदद स्वीकार करें।',
        'pt': 'Seu corpo está se recuperando rapidamente. Descanse bastante e aceite ajuda.',
        'es': 'Tu cuerpo se recupera rápido. Descansa mucho y acepta ayuda.',
        'id': 'Tubuhmu pulih dengan cepat. Banyak istirahat dan terima bantuan.',
        'ur': 'آپ کا جسم تیزی سے صحت یاب ہو رہا ہے۔ خوب آرام کریں اور مدد قبول کریں۔',
        'bn': 'আপনার শরীর দ্রুত সুস্থ হচ্ছে। প্রচুর বিশ্রাম নিন এবং সাহায্য গ্রহণ করুন।',
        'ar': 'جسمك يتعافى بسرعة. استريحي كثيرًا واقبلي المساعدة.',
        'ru': 'Твоё тело быстро восстанавливается. Много отдыхай и принимай помощь.',
        'de': 'Dein Körper erholt sich schnell. Ruh dich viel aus und nimm Hilfe an.',
        'fr': 'Ton corps guérit vite. Repose-toi beaucoup et accepte l\'aide.',
        'it': 'Il tuo corpo guarisce velocemente. Riposa molto e accetta aiuto.',
        'ja': '体は急速に回復しています。しっかり休んで、助けを受け入れましょう。',
        'ko': '몸이 빠르게 회복 중입니다. 충분히 쉬고 도움을 받아들이세요.',
        'zh': '你的身体正在快速恢复。多休息，接受帮助。',
        'fil': 'Mabilis gumaling ang iyong katawan. Magpahinga nang marami at tumanggap ng tulong.',
        'vi': 'Cơ thể bạn đang hồi phục nhanh chóng. Hãy nghỉ ngơi nhiều và chấp nhận sự giúp đỡ.',
        'fa': 'بدنت به سرعت در حال بهبود است. زیاد استراحت کن و کمک را بپذیر.',
        'pl': 'Twoje ciało szybko się regeneruje. Dużo odpoczywaj i przyjmuj pomoc.',
      },
    ),
    icon: Icons.bedtime_rounded,
    tips: [
      L('Doğum sonrası kanama (lochia) normaldir, takip et.',
          'Postpartum bleeding (lochia) is normal — keep an eye on it.', more: {
        'hi': 'प्रसवोत्तर रक्तस्राव (लोकिया) सामान्य है — इस पर नज़र रखें।',
        'pt': 'Sangramento pós-parto (lóquios) é normal — fique de olho.',
        'es': 'El sangrado posparto (loquios) es normal — vigílalo.',
        'id': 'Pendarahan pasca-melahirkan (lochia) itu normal — awasi.',
        'ur': 'زچگی کے بعد خون بہنا (لوچیا) معمول ہے — اس پر نظر رکھیں۔',
        'bn': 'প্রসবোত্তর রক্তপাত (লোচিয়া) স্বাভাবিক — নজর রাখুন।',
        'ar': 'نزيف ما بعد الولادة (الهلابة) طبيعي — راقبيه.',
        'ru': 'Послеродовое кровотечение (лохии) — это нормально, следи за ним.',
        'de': 'Postpartale Blutungen (Lochien) sind normal — behalte sie im Auge.',
        'fr': 'Les saignements post-partum (lochies) sont normaux — surveille-les.',
        'it': 'Il sanguinamento post-partum (lochia) è normale — tienilo d\'occhio.',
        'ja': '産後出血（悪露）は正常です — 様子を見守ってください。',
        'ko': '산후 출혈(로키아)은 정상입니다 — 계속 관찰하세요.',
        'zh': '产后出血（恶露）是正常的 — 注意观察。',
        'fil': 'Ang pagdurugo pagkatapos ng panganganak (lochia) ay normal — bantayan ito.',
        'vi': 'Chảy máu sau sinh (sản dịch) là bình thường — hãy theo dõi.',
        'fa': 'خونریزی پس از زایمان (لوچیا) طبیعی است — مراقبش باش.',
        'pl': 'Krwawienie poporodowe (lochia) jest normalne — obserwuj je.',
      }),
      L('Ağır yük kaldırma, kısa yürüyüşler yeterli.',
          'Avoid heavy lifting; short walks are enough.', more: {
        'hi': 'भारी वजन उठाने से बचें; छोटी सैर काफी है।',
        'pt': 'Evite levantar peso; caminhadas curtas são suficientes.',
        'es': 'Evita levantar objetos pesados; los paseos cortos son suficientes.',
        'id': 'Hindari mengangkat beban berat; jalan kaki pendek sudah cukup.',
        'ur': 'بھاری وزن اٹھانے سے گریز کریں؛ چھوٹی چہل قدمی کافی ہے۔',
        'bn': 'ভারী ওজন তোলা এড়িয়ে চলুন; ছোট হাঁটাই যথেষ্ট।',
        'ar': 'تجنبي رفع الأوزان الثقيلة؛ المشي القصير يكفي.',
        'ru': 'Избегай подъёма тяжестей; короткие прогулки достаточны.',
        'de': 'Vermeide schweres Heben; kurze Spaziergänge reichen aus.',
        'fr': 'Évite de soulever des charges lourdes ; de courtes marches suffisent.',
        'it': 'Evita di sollevare carichi pesanti; brevi passeggiate sono sufficienti.',
        'ja': '重い物を持たないでください。短い散歩で十分です。',
        'ko': '무거운 물건을 들지 마세요; 짧은 산책이면 충분합니다.',
        'zh': '避免提重物；短距离散步就足够了。',
        'fil': 'Iwasan ang pagbubuhat ng mabigat; sapat na ang maikling paglalakad.',
        'vi': 'Tránh nâng vật nặng; đi bộ ngắn là đủ.',
        'fa': 'از بلند کردن اجسام سنگین خودداری کن؛ پیاده‌روی کوتاه کافی است.',
        'pl': 'Unikaj podnoszenia ciężarów; wystarczą krótkie spacery.',
      }),
      L('Su tüketimini ihmal etme.', "Don't skip hydration.", more: {
        'hi': 'पानी पीना न भूलें।',
        'pt': 'Não ignore a hidratação.',
        'es': 'No descuides la hidratación.',
        'id': 'Jangan lewatkan hidrasi.',
        'ur': 'پانی پینا مت بھولیں۔',
        'bn': 'হাইড্রেশন এড়িয়ে যাবেন না।',
        'ar': 'لا تهملي شرب الماء.',
        'ru': 'Не забывай пить воду.',
        'de': 'Trink genug.',
        'fr': 'N\'oublie pas de t\'hydrater.',
        'it': 'Non saltare l\'idratazione.',
        'ja': '水分補給を忘れずに。',
        'ko': '수분 섭취를 거르지 마세요.',
        'zh': '别忘了补充水分。',
        'fil': 'Huwag laktawan ang hydration.',
        'vi': 'Đừng bỏ qua việc uống nước.',
        'fa': 'هیدراته ماندن را فراموش نکن.',
        'pl': 'Nie pomijaj nawodnienia.',
      }),
    ],
  ),
  _RecoveryStage(
    weekFrom: 2,
    weekTo: 6,
    title: L('2–6 hafta — Toparlanma', '2–6 weeks — Recovery', more: {
      'hi': '२-६ हफ्ते — रिकवरी',
      'pt': '2-6 semanas — Recuperação',
      'es': '2-6 semanas — Recuperación',
      'id': '2-6 minggu — Pemulihan',
      'ur': '۲-۶ ہفتے — بحالی',
      'bn': '২-৬ সপ্তাহ — পুনরুদ্ধার',
      'ar': '2-6 أسابيع — التعافي',
      'ru': '2-6 недель — Восстановление',
      'de': '2-6 Wochen — Erholung',
      'fr': '2-6 semaines — Récupération',
      'it': '2-6 settimane — Recupero',
      'ja': '2〜6週間 — 回復期',
      'ko': '2-6주 — 회복',
      'zh': '2-6周 — 恢复期',
      'fil': '2-6 linggo — Paggaling',
      'vi': '2-6 tuần — Hồi phục',
      'fa': '۲-۶ هفته — بهبودی',
      'pl': '2-6 tygodni — Rekonwalescencja',
    }),
    summary: L(
      'Diyafram nefesi, hafif esneme ve pelvik farkındalık başlayabilir.',
      'Diaphragmatic breathing, gentle stretching and pelvic awareness can start.',
      more: {
        'hi': 'डायाफ्रामिक श्वास, हल्का स्ट्रेचिंग और पेल्विक जागरूकता शुरू हो सकती है।',
        'pt': 'Respiração diafragmática, alongamento suave e consciência pélvica podem começar.',
        'es': 'La respiración diafragmática, el estiramiento suave y la conciencia pélvica pueden comenzar.',
        'id': 'Pernapasan diafragma, peregangan ringan dan kesadaran panggul dapat dimulai.',
        'ur': 'ڈایافرامیٹک سانس، ہلکا اسٹریچنگ اور پیلوک آگاہی شروع ہو سکتی ہے۔',
        'bn': 'ডায়াফ্রাম্যাটিক শ্বাস, মৃদু স্ট্রেচিং এবং পেলভিক সচেতনতা শুরু হতে পারে।',
        'ar': 'التنفس الحجابي والتمدد اللطيف والوعي بالحوض يمكن أن تبدأ.',
        'ru': 'Диафрагмальное дыхание, мягкая растяжка и осознание тазового дна могут начаться.',
        'de': 'Zwerchfellatmung, sanftes Dehnen und Beckenbodenbewusstsein können beginnen.',
        'fr': 'La respiration diaphragmatique, les étirements doux et la conscience pelvienne peuvent commencer.',
        'it': 'La respirazione diaframmatica, lo stretching delicato e la consapevolezza pelvica possono iniziare.',
        'ja': '横隔膜呼吸、優しいストレッチ、骨盤底の意識を始められます。',
        'ko': '횡격막 호흡, 부드러운 스트레칭 및 골반저 인식을 시작할 수 있습니다.',
        'zh': '可以开始腹式呼吸、温和拉伸和盆底意识练习。',
        'fil': 'Ang diaphragmatic breathing, gentle stretching at pelvic awareness ay maaaring magsimula.',
        'vi': 'Có thể bắt đầu thở bằng cơ hoành, kéo giãn nhẹ và nhận thức về sàn chậu.',
        'fa': 'تنفس دیافراگمی، کشش ملایم و آگاهی از کف لگن می‌توانند شروع شوند.',
        'pl': 'Można rozpocząć oddychanie przeponowe, delikatne rozciąganie i świadomość miednicy.',
      },
    ),
    icon: Icons.air_rounded,
    tips: [
      L('Kegel egzersizleri günde 3 set.', 'Kegel exercises, 3 sets per day.',
          more: {
            'hi': 'केगल व्यायाम दिन में 3 सेट।',
            'pt': 'Exercícios Kegel, 3 séries por dia.',
            'es': 'Ejercicios de Kegel, 3 series al día.',
            'id': 'Latihan Kegel, 3 set per hari.',
            'ur': 'کیگل ورزش، دن میں 3 سیٹ۔',
            'bn': 'কেগেল ব্যায়াম, দিনে ৩ সেট।',
            'ar': 'تمارين كيغل، 3 مجموعات يوميًا.',
            'ru': 'Упражнения Кегеля, 3 подхода в день.',
            'de': 'Kegel-Übungen, 3 Sätze pro Tag.',
            'fr': 'Exercices de Kegel, 3 séries par jour.',
            'it': 'Esercizi di Kegel, 3 serie al giorno.',
            'ja': 'ケーゲル体操、1日3セット。',
            'ko': '케겔 운동, 하루 3세트.',
            'zh': '凯格尔运动，每天3组。',
            'fil': 'Ehersisyo ng Kegel, 3 set bawat araw.',
            'vi': 'Bài tập Kegel, 3 hiệp mỗi ngày.',
            'fa': 'تمرینات کگل، روزانه ۳ ست.',
            'pl': 'Ćwiczenia Kegla, 3 serie dziennie.',
          }),
      L('Postür için duvar egzersizi.', 'Wall posture exercise.', more: {
        'hi': 'मुद्रा के लिए दीवार व्यायाम।',
        'pt': 'Exercício de postura na parede.',
        'es': 'Ejercicio de postura en la pared.',
        'id': 'Latihan postur dinding.',
        'ur': 'کرنسی کے لیے دیوار کی ورزش۔',
        'bn': 'ভঙ্গির জন্য দেয়াল ব্যায়াম।',
        'ar': 'تمرين وضعية الحائط.',
        'ru': 'Упражнение у стены для осанки.',
        'de': 'Wandhaltungsübung.',
        'fr': 'Exercice de posture au mur.',
        'it': 'Esercizio di postura al muro.',
        'ja': '姿勢のための壁エクササイズ。',
        'ko': '자세 교정을 위한 벽 운동.',
        'zh': '靠墙姿态练习。',
        'fil': 'Ehersisyo sa postura sa dingding.',
        'vi': 'Bài tập tư thế dựa tường.',
        'fa': 'تمرین وضعیت بدن روی دیوار.',
        'pl': 'Ćwiczenie postawy przy ścianie.',
      }),
      L('Doktor kontrolünü unutma.', 'Remember your doctor checkup.', more: {
        'hi': 'डॉक्टर की जाँच न भूलें।',
        'pt': 'Não se esqueça da consulta médica.',
        'es': 'No olvides tu revisión médica.',
        'id': 'Jangan lupa periksa ke dokter.',
        'ur': 'ڈاکٹر کا چیک اپ مت بھولیں۔',
        'bn': 'ডাক্তার চেকআপ ভুলবেন না।',
        'ar': 'لا تنسي الكشف الطبي.',
        'ru': 'Не забудь про осмотр врача.',
        'de': 'Vergiss nicht deinen Arzttermin.',
        'fr': 'N\'oublie pas ta visite chez le médecin.',
        'it': 'Non dimenticare la visita dal medico.',
        'ja': '医師の診察を忘れずに。',
        'ko': '의사 검진을 잊지 마세요.',
        'zh': '别忘了看医生。',
        'fil': 'Huwag kalimutan ang iyong check-up sa doktor.',
        'vi': 'Đừng quên đi khám bác sĩ.',
        'fa': 'معاینه پزشک را فراموش نکن.',
        'pl': 'Pamiętaj o wizycie u lekarza.',
      }),
    ],
  ),
  _RecoveryStage(
    weekFrom: 6,
    weekTo: 12,
    title: L('6–12 hafta — Güçlenme', '6–12 weeks — Strengthening', more: {
      'hi': '६-१२ हफ्ते — मजबूती',
      'pt': '6-12 semanas — Fortalecimento',
      'es': '6-12 semanas — Fortalecimiento',
      'id': '6-12 minggu — Penguatan',
      'ur': '۶-۱۲ ہفتے — مضبوطی',
      'bn': '৬-১২ সপ্তাহ — শক্তিশালীকরণ',
      'ar': '6-12 أسبوعًا — التقوية',
      'ru': '6-12 недель — Укрепление',
      'de': '6-12 Wochen — Kräftigung',
      'fr': '6-12 semaines — Renforcement',
      'it': '6-12 settimane — Rafforzamento',
      'ja': '6〜12週間 — 強化期',
      'ko': '6-12주 — 강화',
      'zh': '6-12周 — 增强期',
      'fil': '6-12 linggo — Pagpapalakas',
      'vi': '6-12 tuần — Tăng cường',
      'fa': '۶-۱۲ هفته — تقویت',
      'pl': '6-12 tygodni — Wzmacnianie',
    }),
    summary: L(
      'Düşük etkili kardiyo ve yoga eklenebilir.',
      'Low-impact cardio and yoga can be added.',
      more: {
        'hi': 'कम प्रभाव वाला कार्डियो और योग जोड़ा जा सकता है।',
        'pt': 'Cardio de baixo impacto e ioga podem ser adicionados.',
        'es': 'Se puede añadir cardio de bajo impacto y yoga.',
        'id': 'Kardio berdampak rendah dan yoga dapat ditambahkan.',
        'ur': 'کم اثر والا کارڈیو اور یوگا شامل کیا جا سکتا ہے۔',
        'bn': 'কম প্রভাবের কার্ডিও এবং যোগ যোগ করা যেতে পারে।',
        'ar': 'يمكن إضافة كارديو منخفض التأثير واليوغا.',
        'ru': 'Можно добавить низкоударное кардио и йогу.',
        'de': 'Schonendes Cardio und Yoga können hinzugefügt werden.',
        'fr': 'Un cardio à faible impact et du yoga peuvent être ajoutés.',
        'it': 'Cardio a basso impatto e yoga possono essere aggiunti.',
        'ja': '低衝撃の有酸素運動とヨガを追加できます。',
        'ko': '저충격 유산소와 요가를 추가할 수 있습니다.',
        'zh': '可以加入低冲击有氧和瑜伽。',
        'fil': 'Maaaring idagdag ang low-impact cardio at yoga.',
        'vi': 'Có thể thêm cardio tác động thấp và yoga.',
        'fa': 'کاردیوی کم‌تأثیر و یوگا می‌توانند اضافه شوند.',
        'pl': 'Można dodać cardio o niskim wpływie i jogę.',
      },
    ),
    icon: Icons.directions_walk_rounded,
    tips: [
      L('20 dk yürüyüş + hafif yoga.', '20-min walk + light yoga.', more: {
        'hi': '२० मिनट पैदल चलना + हल्का योग।',
        'pt': '20 min de caminhada + ioga leve.',
        'es': '20 min de caminata + yoga ligero.',
        'id': '20 mnt jalan kaki + yoga ringan.',
        'ur': '۲۰ منٹ چہل قدمی + ہلکی یوگا۔',
        'bn': '২০ মিনিট হাঁটা + হালকা যোগ।',
        'ar': '20 دقيقة مشي + يوغا خفيفة.',
        'ru': '20 мин прогулки + лёгкая йога.',
        'de': '20 Min Spaziergang + sanftes Yoga.',
        'fr': '20 min de marche + yoga léger.',
        'it': '20 min di camminata + yoga leggero.',
        'ja': '20分の散歩＋軽いヨガ。',
        'ko': '20분 산책 + 가벼운 요가.',
        'zh': '20分钟散步+轻度瑜伽。',
        'fil': '20 min lakad + magaan na yoga.',
        'vi': '20 phút đi bộ + yoga nhẹ.',
        'fa': '۲۰ دقیقه پیاده‌روی + یوگای سبک.',
        'pl': '20 min spaceru + lekka joga.',
      }),
      L('Diastasis varsa fizyoterapiste danış.',
          'If you have diastasis, see a physiotherapist.', more: {
        'hi': 'यदि डायस्टेसिस है तो फिजियोथेरेपिस्ट से मिलें।',
        'pt': 'Se tiver diástase, consulte um fisioterapeuta.',
        'es': 'Si tienes diástasis, consulta a un fisioterapeuta.',
        'id': 'Jika mengalami diastasis, konsultasikan dengan fisioterapis.',
        'ur': 'اگر ڈائیسٹیسیس ہے تو فزیو تھراپسٹ سے ملیں۔',
        'bn': 'ডায়াস্টেসিস থাকলে ফিজিওথেরাপিস্টের সঙ্গে দেখা করুন।',
        'ar': 'إذا كان لديك انبساط عضلي، استشيري أخصائي علاج طبيعي.',
        'ru': 'При диастазе обратись к физиотерапевту.',
        'de': 'Bei Diastase einen Physiotherapeuten aufsuchen.',
        'fr': 'Si tu as une diastase, consulte un kinésithérapeute.',
        'it': 'Se hai la diastasi, consulta un fisioterapista.',
        'ja': '腹直筋離開がある場合は理学療法士に相談してください。',
        'ko': '이탈선이 있다면 물리치료사와 상담하세요.',
        'zh': '如有腹直肌分离，请咨询物理治疗师。',
        'fil': 'Kung mayroon kang diastasis, magpatingin sa isang physiotherapist.',
        'vi': 'Nếu bạn bị diastasis, hãy gặp bác sĩ vật lý trị liệu.',
        'fa': 'اگر دیاستازیس داری، به فیزیوتراپیست مراجعه کن.',
        'pl': 'Jeśli masz rozejście mięśni, skonsultuj się z fizjoterapeutą.',
      }),
      L('Beslenmeye demir & omega-3 ekle.', 'Add iron and omega-3 to your diet.',
          more: {
            'hi': 'अपने आहार में आयरन और ओमेगा-3 शामिल करें।',
            'pt': 'Adicione ferro e ômega-3 à sua dieta.',
            'es': 'Añade hierro y omega-3 a tu dieta.',
            'id': 'Tambahkan zat besi dan omega-3 ke dalam makanan Anda.',
            'ur': 'اپنی خوراک میں آئرن اور اومیگا 3 شامل کریں۔',
            'bn': 'আপনার খাদ্যতালিকায় আয়রন ও ওমেগা-৩ যোগ করুন।',
            'ar': 'أضيفي الحديد وأوميغا-3 إلى نظامك الغذائي.',
            'ru': 'Добавь железо и омега-3 в свой рацион.',
            'de': 'Füge Eisen und Omega-3 zu deiner Ernährung hinzu.',
            'fr': 'Ajoute du fer et des oméga-3 à ton alimentation.',
            'it': 'Aggiungi ferro e omega-3 alla tua dieta.',
            'ja': '食事に鉄分とオメガ3を追加しましょう。',
            'ko': '식단에 철분과 오메가-3를 추가하세요.',
            'zh': '在饮食中增加铁和Omega-3。',
            'fil': 'Magdagdag ng iron at omega-3 sa iyong diyeta.',
            'vi': 'Thêm sắt và omega-3 vào chế độ ăn của bạn.',
            'fa': 'آهن و امگا-۳ را به رژیم غذاییت اضافه کن.',
            'pl': 'Dodaj żelazo i omega-3 do swojej diety.',
          }),
    ],
  ),
  _RecoveryStage(
    weekFrom: 12,
    weekTo: 24,
    title: L('12+ hafta — Yeniden enerji', '12+ weeks — Renewed energy', more: {
      'hi': '१२+ हफ्ते — नई ऊर्जा',
      'pt': '12+ semanas — Energia renovada',
      'es': '12+ semanas — Energía renovada',
      'id': '12+ minggu — Energi baru',
      'ur': '۱۲+ ہفتے — نئی توانائی',
      'bn': '১২+ সপ্তাহ — পুনরুজ্জীবিত শক্তি',
      'ar': '12+ أسبوعًا — طاقة متجددة',
      'ru': '12+ недель — Обновлённая энергия',
      'de': '12+ Wochen — Neue Energie',
      'fr': '12+ semaines — Énergie renouvelée',
      'it': '12+ settimane — Energia rinnovata',
      'ja': '12週間以上 — 新たな活力',
      'ko': '12주+ — 재충전된 에너지',
      'zh': '12周以上 — 焕发新能量',
      'fil': '12+ linggo — Panibagong enerhiya',
      'vi': '12+ tuần — Năng lượng mới',
      'fa': '۱۲+ هفته — انرژی تازه',
      'pl': '12+ tygodni — Odnowiona energia',
    }),
    summary: L(
      'Doktor onayıyla daha aktif egzersizler.',
      'More active workouts with your doctor\'s approval.',
      more: {
        'hi': 'डॉक्टर की मंजूरी से अधिक सक्रिय कसरत।',
        'pt': 'Treinos mais ativos com a aprovação do seu médico.',
        'es': 'Ejercicios más activos con la aprobación de tu médico.',
        'id': 'Latihan yang lebih aktif dengan persetujuan dokter.',
        'ur': 'ڈاکٹر کی منظوری سے زیادہ فعال ورزشیں۔',
        'bn': 'ডাক্তারের অনুমোদন নিয়ে আরও সক্রিয় ওয়ার্কআউট।',
        'ar': 'تمارين أكثر نشاطًا بموافقة طبيبك.',
        'ru': 'Более активные тренировки с разрешения врача.',
        'de': 'Aktivere Workouts mit Zustimmung deines Arztes.',
        'fr': 'Des entraînements plus actifs avec l\'accord de ton médecin.',
        'it': 'Allenamenti più attivi con l\'approvazione del medico.',
        'ja': '医師の承認を得て、よりアクティブなワークアウトを。',
        'ko': '의사의 승인을 받아 더 활동적인 운동을.',
        'zh': '经医生许可后进行更活跃的锻炼。',
        'fil': 'Mas aktibong pag-eehersisyo na may pahintulot ng iyong doktor.',
        'vi': 'Các bài tập tích cực hơn với sự chấp thuận của bác sĩ.',
        'fa': 'ورزش‌های فعال‌تر با تأیید پزشک.',
        'pl': 'Bardziej aktywne treningi za zgodą lekarza.',
      },
    ),
    icon: Icons.fitness_center_rounded,
    tips: [
      L('Tam vücut güçlendirme rutini.', 'Full-body strengthening routine.',
          more: {
            'hi': 'पूरे शरीर को मजबूत करने की दिनचर्या।',
            'pt': 'Rotina de fortalecimento total do corpo.',
            'es': 'Rutina de fortalecimiento de todo el cuerpo.',
            'id': 'Rutinitas penguatan seluruh tubuh.',
            'ur': 'پورے جسم کی مضبوطی کا معمول۔',
            'bn': 'পুরো শরীর শক্তিশালী করার রুটিন।',
            'ar': 'روتين تقوية الجسم بالكامل.',
            'ru': 'Рутина укрепления всего тела.',
            'de': 'Ganzkörper-Kräftigungsroutine.',
            'fr': 'Routine de renforcement complet du corps.',
            'it': 'Routine di rafforzamento di tutto il corpo.',
            'ja': '全身強化ルーティン。',
            'ko': '전신 강화 루틴.',
            'zh': '全身力量训练计划。',
            'fil': 'Routine ng pagpapalakas ng buong katawan.',
            'vi': 'Thói quen tăng cường toàn thân.',
            'fa': 'روال تقویت تمام بدن.',
            'pl': 'Rutyna wzmacniania całego ciała.',
          }),
      L('HIIT denemeden önce pelvik kontrol.',
          'Pelvic check before trying HIIT.', more: {
        'hi': 'HIIT आजमाने से पहले पेल्विक जाँच।',
        'pt': 'Verificação pélvica antes de tentar HIIT.',
        'es': 'Revisión pélvica antes de probar HIIT.',
        'id': 'Periksa panggul sebelum mencoba HIIT.',
        'ur': 'HIIT آزمانے سے پہلے پیلوک چیک۔',
        'bn': 'HIIT চেষ্টা করার আগে পেলভিক পরীক্ষা।',
        'ar': 'فحص الحوض قبل تجربة HIIT.',
        'ru': 'Проверка тазового дна перед HIIT.',
        'de': 'Beckenboden-Check vor dem Versuch von HIIT.',
        'fr': 'Vérification pelvienne avant d\'essayer le HIIT.',
        'it': 'Controllo pelvico prima di provare HIIT.',
        'ja': 'HIITを試す前に骨盤チェック。',
        'ko': 'HIIT를 시도하기 전에 골반 확인.',
        'zh': '尝试HIIT前先做盆底检查。',
        'fil': 'Pagsusuri ng pelvic bago subukan ang HIIT.',
        'vi': 'Kiểm tra sàn chậu trước khi thử HIIT.',
        'fa': 'بررسی لگن قبل از امتحان HIIT.',
        'pl': 'Sprawdzenie miednicy przed próbą HIIT.',
      }),
      L('Uyku ve mood takibini sürdür.', 'Keep tracking sleep and mood.',
          more: {
            'hi': 'नींद और मूड की ट्रैकिंग जारी रखें।',
            'pt': 'Continue monitorando o sono e o humor.',
            'es': 'Sigue registrando el sueño y el estado de ánimo.',
            'id': 'Terus pantau tidur dan suasana hati.',
            'ur': 'نیند اور مزاج کی ٹریکنگ جاری رکھیں۔',
            'bn': 'ঘুম এবং মেজাজ ট্র্যাক করা চালিয়ে যান।',
            'ar': 'استمري في تتبع النوم والمزاج.',
            'ru': 'Продолжай отслеживать сон и настроение.',
            'de': 'Verfolge weiterhin Schlaf und Stimmung.',
            'fr': 'Continue à suivre ton sommeil et ton humeur.',
            'it': 'Continua a monitorare sonno e umore.',
            'ja': '睡眠と気分の記録を続けてください。',
            'ko': '수면과 기분 추적을 계속하세요.',
            'zh': '继续记录睡眠和心情。',
            'fil': 'Patuloy na subaybayan ang tulog at mood.',
            'vi': 'Tiếp tục theo dõi giấc ngủ và tâm trạng.',
            'fa': 'ردیابی خواب و خلق و خو را ادامه بده.',
            'pl': 'Kontynuuj śledzenie snu i nastroju.',
          }),
    ],
  ),
];

class RecoveryTimelineScreen extends StatelessWidget {
  const RecoveryTimelineScreen({super.key, required this.repository});

  final AppRepository repository;

  int _weeksSince(String birthDate) {
    final dt = DateTime.tryParse(birthDate) ?? DateTime.now();
    final days = DateTime.now().difference(dt).inDays;
    return days < 0 ? 0 : days ~/ 7;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final profile = repository.profile;
    final weeks =
        profile == null ? 0 : _weeksSince(profile.babyBirthDate);
    final activeStageIndex = _stages.indexWhere(
        (s) => weeks >= s.weekFrom && weeks < s.weekTo);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        GradientCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.timeline_rounded, size: 16),
                  const SizedBox(width: 6),
                  Text(t.recoveryWeek(weeks),
                      style: const TextStyle(fontSize: 13)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                activeStageIndex == -1
                    ? '🎉'
                    : _stages[activeStageIndex.clamp(0, _stages.length - 1)]
                        .title
                        .of(context),
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: scheme.onPrimary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ..._stages.asMap().entries.map((entry) {
          final i = entry.key;
          final s = entry.value;
          final isActive = i == activeStageIndex;
          final isPast = weeks >= s.weekTo;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MomriseCard(
              border: isActive
                  ? Border.all(color: scheme.primary, width: 2)
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isPast
                              ? const Color(0xFF34D399).withValues(alpha: 0.18)
                              : isActive
                                  ? scheme.primary.withValues(alpha: 0.18)
                                  : scheme.surfaceContainerHighest,
                        ),
                        child: Icon(
                          isPast
                              ? Icons.check_rounded
                              : s.icon,
                          color: isPast
                              ? const Color(0xFF059669)
                              : isActive
                                  ? scheme.primary
                                  : scheme.onSurfaceVariant,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${s.weekFrom}-${s.weekTo} hf',
                              style: TextStyle(
                                fontSize: 10,
                                letterSpacing: 1.1,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                            Text(s.title.of(context),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(s.summary.of(context),
                      style: TextStyle(
                          fontSize: 12, color: scheme.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  ...s.tips.map(
                    (tip) => Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.brightness_1,
                              size: 5, color: scheme.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(tip.of(context),
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 60),
      ],
    );
  }
}
