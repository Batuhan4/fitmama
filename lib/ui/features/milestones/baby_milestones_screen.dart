import 'package:flutter/material.dart';

import '../../../data/repositories/app_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../utils/localized.dart';
import '../../core/widgets/fitmama_card.dart';

class _Milestone {
  const _Milestone({
    required this.id,
    required this.title,
    required this.desc,
    required this.weekFrom,
    required this.weekTo,
  });
  final String id;
  final L title;
  final L desc;
  final int weekFrom;
  final int weekTo;
}

const _milestones = <_Milestone>[
  _Milestone(
      id: 'smile',
      title: L('İlk sosyal gülümseme', 'First social smile', more: {
        'hi': 'पहली सामाजिक मुस्कान',
        'pt': 'Primeiro sorriso social',
        'es': 'Primera sonrisa social',
        'id': 'Senyum sosial pertama',
        'ur': 'پہلی سماجی مسکراہٹ',
        'bn': 'প্রথম সামাজিক হাসি',
        'ar': 'أول ابتسامة اجتماعية',
        'ru': 'Первая социальная улыбка',
        'de': 'Erstes soziales Lächeln',
        'fr': 'Premier sourire social',
        'it': 'Primo sorriso sociale',
        'ja': '初めての社会的微笑み',
        'ko': '첫 사회적 미소',
        'zh': '第一次社交微笑',
        'fil': 'Unang sosyal na ngiti',
        'vi': 'Nụ cười xã hội đầu tiên',
        'fa': 'اولین لبخند اجتماعی',
        'pl': 'Pierwszy społeczny uśmiech',
      }),
      desc: L('Anne/baba sesine yanıt olarak gülümseme.',
          "Smiles in response to a parent's voice.", more: {
        'hi': "माता-पिता की आवाज़ के जवाब में मुस्कान।",
        'pt': "Sorriso em resposta à voz dos pais.",
        'es': "Sonrisa en respuesta a la voz de los padres.",
        'id': "Senyum sebagai respons terhadap suara orang tua.",
        'ur': "والدین کی آواز کے جواب میں مسکراہٹ۔",
        'bn': "মা-বাবার কণ্ঠের প্রতিক্রিয়ায় হাসি।",
        'ar': "ابتسامة استجابة لصوت الوالدين.",
        'ru': "Улыбка в ответ на голос родителя.",
        'de': "Lächeln als Reaktion auf die Stimme der Eltern.",
        'fr': "Sourire en réponse à la voix d'un parent.",
        'it': "Sorriso in risposta alla voce di un genitore.",
        'ja': "親の声に反応して微笑む。",
        'ko': "부모의 목소리에 반응하여 미소 짓습니다.",
        'zh': "对父母声音的回应性微笑。",
        'fil': "Ngiti bilang tugon sa boses ng magulang.",
        'vi': "Mỉm cười để đáp lại giọng nói của cha mẹ.",
        'fa': "لبخند در پاسخ به صدای والدین.",
        'pl': "Uśmiech w odpowiedzi na głos rodzica.",
      }),
      weekFrom: 4,
      weekTo: 8),
  _Milestone(
      id: 'head',
      title: L('Başını dik tutma', 'Holds head up', more: {
        'hi': 'सिर उठाकर रखता है',
        'pt': 'Levanta a cabeça',
        'es': 'Levanta la cabeza',
        'id': 'Mengangkat kepala',
        'ur': 'سر اٹھا کر رکھتا ہے',
        'bn': 'মাথা সোজা করে ধরে',
        'ar': 'يرفع رأسه',
        'ru': 'Держит голову',
        'de': 'Hält den Kopf hoch',
        'fr': 'Tient la tête droite',
        'it': 'Tiene la testa sollevata',
        'ja': '頭を持ち上げる',
        'ko': '머리를 들다',
        'zh': '抬头',
        'fil': 'Itinataas ang ulo',
        'vi': 'Giữ đầu thẳng',
        'fa': 'سر را بالا نگه می‌دارد',
        'pl': 'Podnosi głowę',
      }),
      desc: L('Karın üstü yatarken başını birkaç saniye kaldırır.',
          'Lifts head for a few seconds during tummy time.', more: {
        'hi': 'पेट के बल लेटते समय कुछ सेकंड के लिए सिर उठाता है।',
        'pt': 'Levanta a cabeça por alguns segundos durante o tempo de barriga.',
        'es': 'Levanta la cabeza unos segundos durante el tiempo boca abajo.',
        'id': 'Mengangkat kepala selama beberapa detik saat tengkurap.',
        'ur': 'پیٹ کے بل لیٹتے ہوئے کچھ سیکنڈ کے لیے سر اٹھاتا ہے۔',
        'bn': 'পেটের উপর শুয়ে থাকার সময় কয়েক সেকেন্ডের জন্য মাথা তুলে রাখে।',
        'ar': 'يرفع رأسه لبضع ثوانٍ أثناء الاستلقاء على البطن.',
        'ru': 'Поднимает голову на несколько секунд во время лежания на животе.',
        'de': 'Hebt den Kopf für einige Sekunden während der Bauchlage.',
        'fr': 'Lève la tête pendant quelques secondes durant le temps sur le ventre.',
        'it': 'Solleva la testa per alcuni secondi durante il tempo a pancia in giù.',
        'ja': 'うつ伏せの時間に数秒間頭を持ち上げる。',
        'ko': '엎드린 시간 동안 몇 초간 머리를 듭니다.',
        'zh': '俯卧时能抬头几秒钟。',
        'fil': 'Itinataas ang ulo ng ilang segundo sa oras ng paghiga nang nakadapa.',
        'vi': 'Giơ đầu lên vài giây trong thời gian nằm sấp.',
        'fa': 'سر را برای چند ثانیه در زمان خوابیدن روی شکم بلند می‌کند.',
        'pl': 'Podnosi głowę na kilka sekund podczas leżenia na brzuchu.',
      }),
      weekFrom: 6,
      weekTo: 12),
  _Milestone(
      id: 'coo',
      title: L('Agulama / sesler', 'Cooing / sounds', more: {
        'hi': 'कूकना / आवाज़ें',
        'pt': 'Arrulhos / sons',
        'es': 'Arrullos / sonidos',
        'id': 'Mengek / suara',
        'ur': 'کو / آوازیں',
        'bn': 'কু-কু / শব্দ',
        'ar': 'المناغاة / أصوات',
        'ru': 'Гуление / звуки',
        'de': 'Gurren / Laute',
        'fr': 'Gazouillis / sons',
        'it': 'Cinguettio / suoni',
        'ja': 'クーイング / 音声',
        'ko': '구구거림 / 소리',
        'zh': '咕咕声/发声',
        'fil': 'Pagkukuwento / tunog',
        'vi': 'Bi bô / âm thanh',
        'fa': 'قُروقُر / صداها',
        'pl': 'Gruchanie / dźwięki',
      }),
      desc: L('Ünlüler ile kısa sesler çıkarır.', 'Makes short vowel sounds.',
          more: {
            'hi': 'छोटी स्वर ध्वनियाँ निकालता है।',
            'pt': 'Faz sons curtos de vogais.',
            'es': 'Emite sonidos cortos de vocales.',
            'id': 'Mengeluarkan suara vokal pendek.',
            'ur': 'مختصر حرفِ علت کی آوازیں نکالتا ہے۔',
            'bn': 'ছোট স্বরধ্বনি তৈরি করে।',
            'ar': 'يصدر أصوات حروف علة قصيرة.',
            'ru': 'Издаёт короткие гласные звуки.',
            'de': 'Macht kurze Vokale.',
            'fr': 'Produit de courts sons de voyelles.',
            'it': 'Emette brevi suoni vocalici.',
            'ja': '短い母音を発する。',
            'ko': '짧은 모음 소리를 냅니다.',
            'zh': '发出短元音。',
            'fil': 'Gumagawa ng maiikling tunog ng patinig.',
            'vi': 'Tạo ra các âm nguyên âm ngắn.',
            'fa': 'صداهای کوتاه مصوتی تولید می‌کند.',
            'pl': 'Wydaje krótkie dźwięki samogłoskowe.',
          }),
      weekFrom: 6,
      weekTo: 14),
  _Milestone(
      id: 'grasp',
      title: L('Nesneye uzanma', 'Reaches for objects', more: {
        'hi': 'वस्तुओं तक पहुँचना',
        'pt': 'Alcança objetos',
        'es': 'Alcanza objetos',
        'id': 'Meraih benda',
        'ur': 'اشیاء تک پہنچنا',
        'bn': 'জিনিস ধরতে চাওয়া',
        'ar': 'الوصول إلى الأشياء',
        'ru': 'Тянется к предметам',
        'de': 'Greift nach Gegenständen',
        'fr': 'Attrape les objets',
        'it': 'Raggiunge gli oggetti',
        'ja': '物に手を伸ばす',
        'ko': '물건을 잡으려고 함',
        'zh': '伸手够物',
        'fil': 'Inaabot ang mga bagay',
        'vi': 'Với lấy đồ vật',
        'fa': 'دست دراز کردن به اشیا',
        'pl': 'Sięga po przedmioty',
      }),
      desc: L('Önündeki oyuncağa elini uzatır.', 'Reaches for a toy in front of them.',
          more: {
            'hi': 'अपने सामने खिलौने तक हाथ बढ़ाता है।',
            'pt': 'Estende a mão para um brinquedo à sua frente.',
            'es': 'Extiende la mano hacia un juguete frente a él.',
            'id': 'Mengulurkan tangan ke arah mainan di depannya.',
            'ur': 'اپنے سامنے کھلونے کی طرف ہاتھ بڑھاتا ہے۔',
            'bn': 'সামনের খেলনার দিকে হাত বাড়ায়।',
            'ar': 'يمد يده نحو لعبة أمامه.',
            'ru': 'Тянется рукой к игрушке перед собой.',
            'de': 'Greift nach einem Spielzeug vor sich.',
            'fr': 'Tend la main vers un jouet devant lui.',
            'it': 'Allunga la mano verso un giocattolo di fronte a sé.',
            'ja': '前のおもちゃに手を伸ばす。',
            'ko': '앞에 있는 장난감을 향해 손을 뻗습니다.',
            'zh': '伸手够面前的玩具。',
            'fil': 'Inaabot ang isang laruan sa harap niya.',
            'vi': 'Đưa tay với lấy đồ chơi trước mặt.',
            'fa': 'دستش را به سمت اسباب‌بازی جلویش دراز می‌کند.',
            'pl': 'Sięga ręką po zabawkę przed sobą.',
          }),
      weekFrom: 12,
      weekTo: 20),
  _Milestone(
      id: 'roll',
      title: L('Yana dönme', 'Rolls over', more: {
        'hi': 'करवट बदलना',
        'pt': 'Rola',
        'es': 'Se da la vuelta',
        'id': 'Berguling',
        'ur': 'پلٹنا',
        'bn': 'পাশ ফেরা',
        'ar': 'التقلب',
        'ru': 'Переворачивается',
        'de': 'Dreht sich um',
        'fr': 'Se retourne',
        'it': 'Si gira',
        'ja': '寝返り',
        'ko': '뒤집기',
        'zh': '翻身',
        'fil': 'Pag-ikot',
        'vi': 'Lật người',
        'fa': 'غلت زدن',
        'pl': 'Przewraca się',
      }),
      desc: L('Sırttan yan tarafına dönmeye başlar.',
          'Begins rolling from back to side.', more: {
        'hi': 'पीठ से करवट लेना शुरू करता है।',
        'pt': 'Começa a rolar de costas para o lado.',
        'es': 'Empieza a girar de espalda al lado.',
        'id': 'Mulai berguling dari punggung ke samping.',
        'ur': 'پیٹھ سے پہلو پر پلٹنا شروع کرتا ہے۔',
        'bn': 'পিঠ থেকে পাশ ফেরানো শুরু করে।',
        'ar': 'يبدأ بالتقلب من الظهر إلى الجانب.',
        'ru': 'Начинает переворачиваться со спины на бок.',
        'de': 'Beginnt sich von hinten auf die Seite zu drehen.',
        'fr': 'Commence à rouler du dos sur le côté.',
        'it': 'Inizia a girarsi dalla schiena al fianco.',
        'ja': '仰向けから横向きに転がり始める。',
        'ko': '등에서 옆으로 돌기 시작합니다.',
        'zh': '开始从仰卧翻到侧卧。',
        'fil': 'Nagsisimulang gumulong mula sa likod patungo sa gilid.',
        'vi': 'Bắt đầu lăn từ ngửa sang nghiêng.',
        'fa': 'شروع به غلتیدن از پشت به پهلو می‌کند.',
        'pl': 'Zaczyna się przewracać z pleców na bok.',
      }),
      weekFrom: 16,
      weekTo: 24),
  _Milestone(
      id: 'sit',
      title: L('Destekli oturma', 'Sits with support', more: {
        'hi': 'सहारे से बैठना',
        'pt': 'Senta com apoio',
        'es': 'Se sienta con apoyo',
        'id': 'Duduk dengan dukungan',
        'ur': 'سہارے سے بیٹھنا',
        'bn': 'সাহায্যে বসা',
        'ar': 'الجلوس بدعم',
        'ru': 'Сидит с поддержкой',
        'de': 'Sitzt mit Unterstützung',
        'fr': 'S\'assoit avec soutien',
        'it': 'Si siede con supporto',
        'ja': '支えありで座る',
        'ko': '지원을 받고 앉음',
        'zh': '有支撑地坐',
        'fil': 'Umupo nang may suporta',
        'vi': 'Ngồi có đỡ',
        'fa': 'با حمایت نشستن',
        'pl': 'Siedzi z podparciem',
      }),
      desc: L('Yastıkla desteklenerek oturabilir.', 'Sits propped up with a pillow.',
          more: {
            'hi': 'तकिए के सहारे बैठ सकता है।',
            'pt': 'Senta apoiado com um travesseiro.',
            'es': 'Se sienta apoyado con una almohada.',
            'id': 'Duduk bersandar dengan bantal.',
            'ur': 'تکیے کے سہارے بیٹھ سکتا ہے۔',
            'bn': 'বালিশ দিয়ে সাপোর্ট দিয়ে বসতে পারে।',
            'ar': 'يجلس متكئًا على وسادة.',
            'ru': 'Сидит, подпертый подушкой.',
            'de': 'Sitzt, mit einem Kissen gestützt.',
            'fr': 'S\'assoit calé avec un oreiller.',
            'it': 'Si siede sostenuto da un cuscino.',
            'ja': '枕で支えられて座る。',
            'ko': '베개로 받쳐 앉습니다.',
            'zh': '靠枕头支撑坐着。',
            'fil': 'Umupo nang may suporta sa unan.',
            'vi': 'Ngồi được kê bằng gối.',
            'fa': 'با تکیه به بالش می‌نشیند.',
            'pl': 'Siedzi podparty poduszką.',
          }),
      weekFrom: 20,
      weekTo: 30),
  _Milestone(
      id: 'food',
      title: L('Ek gıda başlangıcı', 'Solid-food start', more: {
        'hi': 'ठोस आहार की शुरुआत',
        'pt': 'Início da alimentação sólida',
        'es': 'Inicio de alimentos sólidos',
        'id': 'Awal makanan padat',
        'ur': 'ٹھوس خوراک کا آغاز',
        'bn': 'কঠিন খাবারের শুরু',
        'ar': 'بدء الأطعمة الصلبة',
        'ru': 'Начало прикорма',
        'de': 'Beginn der Beikost',
        'fr': 'Début des solides',
        'it': 'Inizio dei solidi',
        'ja': '離乳食開始',
        'ko': '이유식 시작',
        'zh': '开始添加辅食',
        'fil': 'Pagsisimula ng solidong pagkain',
        'vi': 'Bắt đầu ăn dặm',
        'fa': 'شروع غذای جامد',
        'pl': 'Rozpoczęcie pokarmów stałych',
      }),
      desc: L('Pediatrist onayıyla katı gıdaya geçiş.',
          "Transition to solids with the pediatrician's approval.", more: {
        'hi': "बाल रोग विशेषज्ञ की मंजूरी से ठोस आहार में संक्रमण।",
        'pt': 'Transição para sólidos com aprovação do pediatra.',
        'es': 'Transición a sólidos con la aprobación del pediatra.',
        'id': 'Transisi ke makanan padat dengan persetujuan dokter anak.',
        'ur': 'ماہر اطفال کی منظوری سے ٹھوس خوراک میں منتقلی۔',
        'bn': 'শিশু বিশেষজ্ঞের অনুমোদনে কঠিন খাবারে রূপান্তর।',
        'ar': 'الانتقال إلى الأطعمة الصلبة بموافقة طبيب الأطفال.',
        'ru': 'Переход к прикорму с одобрения педиатра.',
        'de': 'Übergang zu fester Nahrung mit Zustimmung des Kinderarztes.',
        'fr': 'Transition vers les solides avec l\'accord du pédiatre.',
        'it': 'Passaggio ai solidi con l\'approvazione del pediatra.',
        'ja': '小児科医の承認を得て離乳食へ移行。',
        'ko': '소아과 의사의 승인을 받아 이유식으로 전환.',
        'zh': '在儿科医生批准下开始添加辅食。',
        'fil': 'Paglipat sa solidong pagkain na may pahintulot ng pediatrician.',
        'vi': 'Chuyển sang ăn dặm với sự chấp thuận của bác sĩ nhi khoa.',
        'fa': 'انتقال به غذای جامد با تأیید پزشک متخصص اطفال.',
        'pl': 'Przejście na pokarmy stałe za zgodą pediatry.',
      }),
      weekFrom: 24,
      weekTo: 32),
  _Milestone(
      id: 'crawl',
      title: L('Emekleme', 'Crawling', more: {
        'hi': 'रेंगना',
        'pt': 'Engatinhar',
        'es': 'Gatear',
        'id': 'Merangkak',
        'ur': 'رینگنا',
        'bn': 'হামাগুড়ি দেওয়া',
        'ar': 'الزحف',
        'ru': 'Ползание',
        'de': 'Krabbeln',
        'fr': 'Ramper',
        'it': 'Strisciare',
        'ja': 'ハイハイ',
        'ko': '기어가기',
        'zh': '爬行',
        'fil': 'Paggapang',
        'vi': 'Bò',
        'fa': 'چهار دست و پا رفتن',
        'pl': 'Raczkowanie',
      }),
      desc: L('Karın üstü ileri sürünme.', 'Belly crawl forward.', more: {
        'hi': 'पेट के बल आगे रेंगना।',
        'pt': 'Rastejar de barriga para frente.',
        'es': 'Arrastrarse hacia adelante con la barriga.',
        'id': 'Merayap dengan perut ke depan.',
        'ur': 'پیٹ کے بل آگے رینگنا۔',
        'bn': 'পেটের উপর ভর দিয়ে সামনে এগোনো।',
        'ar': 'الزحف على البطن للأمام.',
        'ru': 'Ползёт на животе вперёд.',
        'de': 'Auf dem Bauch vorwärts krabbeln.',
        'fr': 'Rampe sur le ventre en avant.',
        'it': 'Striscia in avanti sulla pancia.',
        'ja': 'お腹で前に這う。',
        'ko': '배로 앞으로 기어갑니다.',
        'zh': '用腹部向前爬行。',
        'fil': 'Paggapang pasulong gamit ang tiyan.',
        'vi': 'Bò bằng bụng về phía trước.',
        'fa': 'روی شکم به جلو خزیدن.',
        'pl': 'Czołganie się do przodu na brzuchu.',
      }),
      weekFrom: 28,
      weekTo: 44),
  _Milestone(
      id: 'word',
      title: L('İlk heceler', 'First syllables', more: {
        'hi': 'पहले अक्षर',
        'pt': 'Primeiras sílabas',
        'es': 'Primeras sílabas',
        'id': 'Suku kata pertama',
        'ur': 'پہلے حروف',
        'bn': 'প্রথম সিলেবল',
        'ar': 'المقاطع الأولى',
        'ru': 'Первые слоги',
        'de': 'Erste Silben',
        'fr': 'Premières syllabes',
        'it': 'Prime sillabe',
        'ja': '最初の音節',
        'ko': '첫 음절',
        'zh': '第一个音节',
        'fil': 'Unang pantig',
        'vi': 'Âm tiết đầu tiên',
        'fa': 'اولین هجاها',
        'pl': 'Pierwsze sylaby',
      }),
      desc: L('"mama", "baba" gibi tekrarlı heceler.',
          'Repeating syllables like "mama", "dada".', more: {
        'hi': '"मामा", "दादा" जैसे दोहराए जाने वाले अक्षर।',
        'pt': 'Sílabas repetidas como "mama", "papa".',
        'es': 'Sílabas repetitivas como "mama", "papa".',
        'id': 'Suku kata berulang seperti "mama", "dada".',
        'ur': '"ماما"، "دادا" جیسے دہرائے جانے والے حروف۔',
        'bn': '"মামা", "দাদা" এর মতো পুনরাবৃত্ত সিলেবল।',
        'ar': 'مقاطع متكررة مثل "ماما"، "دادا".',
        'ru': 'Повторяющиеся слоги, такие как "мама", "папа".',
        'de': 'Wiederholte Silben wie "mama", "papa".',
        'fr': 'Syllabes répétées comme "mama", "papa".',
        'it': 'Sillabe ripetute come "mama", "papa".',
        'ja': '"ママ"、"パパ"のような繰り返しの音節。',
        'ko': '"마마", "다다" 같은 반복되는 음절.',
        'zh': '重复的音节，如"妈妈"、"爸爸"。',
        'fil': 'Paulit-ulit na pantig tulad ng "mama", "dada".',
        'vi': 'Các âm tiết lặp lại như "mama", "baba".',
        'fa': 'هجاهای تکراری مانند "ماما"، "دادا".',
        'pl': 'Powtarzające się sylaby, takie jak "mama", "tata".',
      }),
      weekFrom: 32,
      weekTo: 52),
];

class BabyMilestonesScreen extends StatelessWidget {
  const BabyMilestonesScreen({super.key, required this.repository});

  final AppRepository repository;

  int _weeksSince(String birth) {
    final dt = DateTime.tryParse(birth) ?? DateTime.now();
    final d = DateTime.now().difference(dt).inDays;
    return d < 0 ? 0 : d ~/ 7;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final profile = repository.profile;
    final weeks =
        profile == null ? 0 : _weeksSince(profile.babyBirthDate);
    final months = weeks ~/ 4;
    final done = repository.milestones;

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
                  const Icon(Icons.child_care_rounded, size: 16),
                  const SizedBox(width: 6),
                  Text(months >= 1
                      ? t.milestoneAgeMonths(months)
                      : t.milestoneAge(weeks),
                      style: const TextStyle(fontSize: 13)),
                ],
              ),
              const SizedBox(height: 6),
              Text(t.milestoneTitle,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: scheme.onPrimary)),
              const SizedBox(height: 6),
              Text(
                '${done.length} / ${_milestones.length}',
                style: TextStyle(
                  color: scheme.onPrimary.withValues(alpha: 0.85),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: done.isEmpty
                      ? 0
                      : done.length / _milestones.length,
                  minHeight: 8,
                  backgroundColor:
                      scheme.onPrimary.withValues(alpha: 0.2),
                  valueColor:
                      AlwaysStoppedAnimation(scheme.onPrimary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ..._milestones.map((m) {
          final isDone = done.contains(m.id);
          final inWindow = weeks >= m.weekFrom && weeks <= m.weekTo;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FitmamaCard(
              padding: const EdgeInsets.all(14),
              onTap: () => repository.toggleMilestone(m.id, !isDone),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone
                          ? scheme.primary
                          : scheme.surfaceContainerHighest,
                      border: Border.all(
                        color: isDone ? scheme.primary : scheme.outline,
                      ),
                    ),
                    child: isDone
                        ? Icon(Icons.check_rounded,
                            color: scheme.onPrimary, size: 16)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.title.of(context),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: isDone
                                  ? scheme.onSurfaceVariant
                                  : scheme.onSurface,
                            )),
                        Text(m.desc.of(context),
                            style: TextStyle(
                              fontSize: 11,
                              color: scheme.onSurfaceVariant,
                            )),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: inWindow
                                ? scheme.primary.withValues(alpha: 0.15)
                                : scheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${m.weekFrom}-${m.weekTo} ${Localizations.localeOf(context).languageCode == 'en' ? 'wk' : 'hf'}',
                            style: TextStyle(
                              fontSize: 10,
                              color: inWindow
                                  ? scheme.primary
                                  : scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
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
