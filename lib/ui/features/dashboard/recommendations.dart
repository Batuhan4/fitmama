import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/mood_entry.dart';
import '../../../data/models/profile.dart';
import '../../../data/repositories/app_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../utils/date_utils.dart';
import '../../../utils/localized.dart';
import '../../core/widgets/momrise_card.dart';

enum _Tab { food, mood, exercise }

class Recommendations extends StatefulWidget {
  const Recommendations({super.key, required this.repository});

  final AppRepository repository;

  @override
  State<Recommendations> createState() => _RecommendationsState();
}

class _RecommendationsState extends State<Recommendations> {
  _Tab _tab = _Tab.food;
  int _seed = DateTime.now().millisecondsSinceEpoch % 1000;

  static const _foodPool = <_FoodIdea>[
    _FoodIdea(
      L('Yulaf + muz + ceviz', 'Oats + banana + walnuts', more: {
        'hi': 'जई + केला + अखरोट',
        'pt': 'Aveia + banana + nozes',
        'es': 'Avena + plátano + nueces',
        'id': 'Oat + pisang + kenari',
        'ur': 'جئی + کیلا + اخروٹ',
        'bn': 'ওটস + কলা + আখরোট',
        'ar': 'شوفان + موز + جوز',
        'ru': 'Овсянка + банан + грецкие орехи',
        'de': 'Haferflocken + Banane + Walnüsse',
        'fr': 'Avoine + banane + noix',
        'it': 'Avena + banana + noci',
        'ja': 'オートミール＋バナナ＋くるみ',
        'ko': '오트밀 + 바나나 + 호두',
        'zh': '燕麦+香蕉+核桃',
        'fil': 'Oats + saging + walnut',
        'vi': 'Yến mạch + chuối + óc chó',
        'fa': 'جو دوسر + موز + گردو',
        'pl': 'Płatki owsiane + banan + orzechy włoskie',
      }),
      L('Emzirme için demir ve omega-3.',
          'Iron and omega-3 for breastfeeding.', more: {
        'hi': 'स्तनपान के लिए आयरन और ओमेगा-3।',
        'pt': 'Ferro e ômega-3 para a amamentação.',
        'es': 'Hierro y omega-3 para la lactancia.',
        'id': 'Zat besi dan omega-3 untuk menyusui.',
        'ur': 'دودھ پلانے کے لیے آئرن اور اومیگا 3۔',
        'bn': 'স্তন্যপানের জন্য আয়রন ও ওমেগা-৩।',
        'ar': 'الحديد وأوميغا-3 للرضاعة.',
        'ru': 'Железо и омега-3 для кормления грудью.',
        'de': 'Eisen und Omega-3 für die Stillzeit.',
        'fr': 'Fer et oméga-3 pour l\'allaitement.',
        'it': 'Ferro e omega-3 per l\'allattamento.',
        'ja': '授乳中の鉄分とオメガ3。',
        'ko': '수유를 위한 철분과 오메가-3.',
        'zh': '哺乳期需要的铁和Omega-3。',
        'fil': 'Iron at omega-3 para sa pagpapasuso.',
        'vi': 'Sắt và omega-3 cho việc cho con bú.',
        'fa': 'آهن و امگا-۳ برای شیردهی.',
        'pl': 'Żelazo i omega-3 do karmienia piersią.',
      }),
      blockAllergens: ['nuts', 'gluten'],
    ),
    _FoodIdea(
      L('Yumurta + avokado tost', 'Egg + avocado toast', more: {
        'hi': 'अंडा + एवोकाडो टोस्ट',
        'pt': 'Torrada de ovo + abacate',
        'es': 'Tostada de huevo + aguacate',
        'id': 'Telur + roti panggang alpukat',
        'ur': 'انڈہ + ایوکاڈو ٹوسٹ',
        'bn': 'ডিম + অ্যাভোকাডো টোস্ট',
        'ar': 'خبز محمص بالبيض والأفوكادو',
        'ru': 'Тост с яйцом и авокадо',
        'de': 'Ei + Avocado-Toast',
        'fr': 'Toast œuf + avocat',
        'it': 'Toast con uovo e avocado',
        'ja': '卵＋アボカドトースト',
        'ko': '계란 + 아보카도 토스트',
        'zh': '鸡蛋+牛油果吐司',
        'fil': 'Itlog + avocado toast',
        'vi': 'Bánh mì nướng trứng + bơ',
        'fa': 'نان تست با تخم‌مرغ و آووکادو',
        'pl': 'Tost z jajkiem i awokado',
      }),
      L('Protein ve sağlıklı yağ.', 'Protein and healthy fats.', more: {
        'hi': 'प्रोटीन और स्वस्थ वसा।',
        'pt': 'Proteína e gorduras saudáveis.',
        'es': 'Proteínas y grasas saludables.',
        'id': 'Protein dan lemak sehat.',
        'ur': 'پروٹین اور صحت مند چکنائی۔',
        'bn': 'প্রোটিন ও স্বাস্থ্যকর চর্বি।',
        'ar': 'بروتين ودهون صحية.',
        'ru': 'Белок и полезные жиры.',
        'de': 'Protein und gesunde Fette.',
        'fr': 'Protéines et bonnes graisses.',
        'it': 'Proteine e grassi sani.',
        'ja': 'タンパク質と健康的な脂肪。',
        'ko': '단백질과 건강한 지방.',
        'zh': '蛋白质和健康脂肪。',
        'fil': 'Protina at malulusog na taba.',
        'vi': 'Protein và chất béo lành mạnh.',
        'fa': 'پروتئین و چربی‌های سالم.',
        'pl': 'Białko i zdrowe tłuszcze.',
      }),
      blockAllergens: ['egg', 'gluten'],
    ),
    _FoodIdea(
      L('Mercimek çorbası', 'Lentil soup', more: {
        'hi': 'दाल का सूप',
        'pt': 'Sopa de lentilhas',
        'es': 'Sopa de lentejas',
        'id': 'Sup miju-miju',
        'ur': 'دال کا سوپ',
        'bn': 'মসুর ডালের স্যুপ',
        'ar': 'شوربة العدس',
        'ru': 'Чечевичный суп',
        'de': 'Linsensuppe',
        'fr': 'Soupe aux lentilles',
        'it': 'Zuppa di lenticchie',
        'ja': 'レンズ豆のスープ',
        'ko': '렌틸 수프',
        'zh': '扁豆汤',
        'fil': 'Lentil soup',
        'vi': 'Súp đậu lăng',
        'fa': 'سوپ عدس',
        'pl': 'Zupa z soczewicy',
      }),
      L('Demir ve lif kaynağı.', 'Iron and fiber.', more: {
        'hi': 'आयरन और फाइबर का स्रोत।',
        'pt': 'Fonte de ferro e fibras.',
        'es': 'Fuente de hierro y fibra.',
        'id': 'Sumber zat besi dan serat.',
        'ur': 'آئرن اور فائبر کا ذریعہ۔',
        'bn': 'আয়রন ও ফাইবারের উৎস।',
        'ar': 'مصدر للحديد والألياف.',
        'ru': 'Источник железа и клетчатки.',
        'de': 'Quelle für Eisen und Ballaststoffe.',
        'fr': 'Source de fer et de fibres.',
        'it': 'Fonte di ferro e fibre.',
        'ja': '鉄分と食物繊維の源。',
        'ko': '철분과 섬유질 공급원.',
        'zh': '铁和纤维的来源。',
        'fil': 'Pinagmumulan ng iron at fiber.',
        'vi': 'Nguồn sắt và chất xơ.',
        'fa': 'منبع آهن و فیبر.',
        'pl': 'Źródło żelaza i błonnika.',
      }),
      blockDislikes: ['legumes'],
    ),
    _FoodIdea(
      L('Izgara tavuk + kinoa', 'Grilled chicken + quinoa', more: {
        'hi': 'ग्रिल्ड चिकन + क्विनोआ',
        'pt': 'Frango grelhado + quinoa',
        'es': 'Pollo a la parrilla + quinoa',
        'id': 'Ayam panggang + quinoa',
        'ur': 'گرلڈ چکن + کوئنو',
        'bn': 'গ্রিলড চিকেন + কুইনোয়া',
        'ar': 'دجاج مشوي + كينوا',
        'ru': 'Курица-гриль + киноа',
        'de': 'Gegrilltes Hähnchen + Quinoa',
        'fr': 'Poulet grillé + quinoa',
        'it': 'Pollo alla griglia + quinoa',
        'ja': 'グリルチキン＋キヌア',
        'ko': '구운 닭고기 + 퀴노아',
        'zh': '烤鸡+藜麦',
        'fil': 'Inihaw na manok + quinoa',
        'vi': 'Gà nướng + hạt diêm mạch',
        'fa': 'مرغ کبابی + کینوآ',
        'pl': 'Grillowany kurczak + komosa ryżowa',
      }),
      L('Yağsız protein, B vitamini.',
          'Lean protein, B vitamins.', more: {
        'hi': 'दुबला प्रोटीन, बी विटामिन।',
        'pt': 'Proteína magra, vitaminas B.',
        'es': 'Proteína magra, vitaminas B.',
        'id': 'Protein tanpa lemak, vitamin B.',
        'ur': 'دبلی پروٹین، بی وٹامنز۔',
        'bn': 'চর্বিহীন প্রোটিন, বি ভিটামিন।',
        'ar': 'بروتين خفيف، فيتامينات ب.',
        'ru': 'Нежирный белок, витамины группы B.',
        'de': 'Mageres Protein, B-Vitamine.',
        'fr': 'Protéines maigres, vitamines B.',
        'it': 'Proteine magre, vitamine B.',
        'ja': '低脂肪タンパク質、ビタミンB。',
        'ko': '저지방 단백질, 비타민 B.',
        'zh': '瘦肉蛋白、B族维生素。',
        'fil': 'Lean protein, B bitamina.',
        'vi': 'Protein nạc, vitamin B.',
        'fa': 'پروتئین کم‌چرب، ویتامین‌های گروه B.',
        'pl': 'Chude białko, witaminy z grupy B.',
      }),
      blockDislikes: ['red_meat'],
    ),
    _FoodIdea(
      L('Somon + sebze', 'Salmon + veggies', more: {
        'hi': 'सैल्मन + सब्जियाँ',
        'pt': 'Salmão + vegetais',
        'es': 'Salmón + verduras',
        'id': 'Salmon + sayuran',
        'ur': 'سالمن + سبزیاں',
        'bn': 'স্যামন + সবজি',
        'ar': 'سلمون + خضروات',
        'ru': 'Лосось + овощи',
        'de': 'Lachs + Gemüse',
        'fr': 'Saumon + légumes',
        'it': 'Salmone + verdure',
        'ja': 'サーモン＋野菜',
        'ko': '연어 + 야채',
        'zh': '三文鱼+蔬菜',
        'fil': 'Salmon + gulay',
        'vi': 'Cá hồi + rau củ',
        'fa': 'سالمون + سبزیجات',
        'pl': 'Łosoś + warzywa',
      }),
      L('Omega-3 ile ruh hali desteği.',
          'Omega-3 supports mood.', more: {
        'hi': 'ओमेगा-3 मूड को सहारा देता है।',
        'pt': 'O ômega-3 apoia o humor.',
        'es': 'El omega-3 apoya el estado de ánimo.',
        'id': 'Omega-3 mendukung suasana hati.',
        'ur': 'اومیگا 3 مزاج کی حمایت کرتا ہے۔',
        'bn': 'ওমেগা-৩ মেজাজ সমর্থন করে।',
        'ar': 'أوميغا-3 يدعم المزاج.',
        'ru': 'Омега-3 поддерживает настроение.',
        'de': 'Omega-3 unterstützt die Stimmung.',
        'fr': 'Les oméga-3 soutiennent l\'humeur.',
        'it': 'Gli omega-3 supportano l\'umore.',
        'ja': 'オメガ3は気分をサポートします。',
        'ko': '오메가-3가 기분을 지원합니다.',
        'zh': 'Omega-3有助于调节情绪。',
        'fil': 'Sinusuportahan ng omega-3 ang mood.',
        'vi': 'Omega-3 hỗ trợ tâm trạng.',
        'fa': 'امگا-۳ از خلق و خو حمایت می‌کند.',
        'pl': 'Omega-3 wspiera nastrój.',
      }),
      blockDislikes: ['fish'],
      blockAllergens: ['seafood'],
    ),
    _FoodIdea(
      L('Yoğurt + meyve + chia', 'Yogurt + fruit + chia', more: {
        'hi': 'दही + फल + चिया',
        'pt': 'Iogurte + fruta + chia',
        'es': 'Yogur + fruta + chía',
        'id': 'Yogurt + buah + chia',
        'ur': 'دہی + پھل + چیا',
        'bn': 'দই + ফল + চিয়া',
        'ar': 'زبادي + فاكهة + شيا',
        'ru': 'Йогурт + фрукты + чиа',
        'de': 'Joghurt + Obst + Chia',
        'fr': 'Yaourt + fruit + chia',
        'it': 'Yogurt + frutta + chia',
        'ja': 'ヨーグルト＋フルーツ＋チアシード',
        'ko': '요거트 + 과일 + 치아',
        'zh': '酸奶+水果+奇亚籽',
        'fil': 'Yogurt + prutas + chia',
        'vi': 'Sữa chua + trái cây + chia',
        'fa': 'ماست + میوه + چیا',
        'pl': 'Jogurt + owoce + chia',
      }),
      L('Probiyotik ve kalsiyum.', 'Probiotics and calcium.', more: {
        'hi': 'प्रोबायोटिक्स और कैल्शियम।',
        'pt': 'Probióticos e cálcio.',
        'es': 'Probióticos y calcio.',
        'id': 'Probiotik dan kalsium.',
        'ur': 'پروبائیوٹکس اور کیلشیم۔',
        'bn': 'প্রোবায়োটিক এবং ক্যালসিয়াম।',
        'ar': 'بروبيوتيك وكالسيوم.',
        'ru': 'Пробиотики и кальций.',
        'de': 'Probiotika und Kalzium.',
        'fr': 'Probiotiques et calcium.',
        'it': 'Probiotici e calcio.',
        'ja': 'プロバイオティクスとカルシウム。',
        'ko': '프로바이오틱스와 칼슘.',
        'zh': '益生菌和钙。',
        'fil': 'Probiotics at calcium.',
        'vi': 'Probiotic và canxi.',
        'fa': 'پروبیوتیک‌ها و کلسیم.',
        'pl': 'Probiotyki i wapń.',
      }),
      blockDislikes: ['dairy'],
      blockAllergens: ['milk'],
    ),
    _FoodIdea(
      L('Humus + sebze çubukları', 'Hummus + veggie sticks', more: {
        'hi': 'हम्मस + सब्जी स्टिक्स',
        'pt': 'Homus + palitos de vegetais',
        'es': 'Hummus + bastones de verduras',
        'id': 'Hummus + stik sayuran',
        'ur': 'حمص + سبزی کی اسٹکس',
        'bn': 'হুমাস + সবজি স্টিক',
        'ar': 'حمص + أعواد الخضار',
        'ru': 'Хумус + овощные палочки',
        'de': 'Hummus + Gemüsesticks',
        'fr': 'Hummus + bâtonnets de légumes',
        'it': 'Hummus + bastoncini di verdure',
        'ja': 'フムス＋野菜スティック',
        'ko': '후무스 + 야채 스틱',
        'zh': '鹰嘴豆泥+蔬菜棒',
        'fil': 'Hummus + veggie sticks',
        'vi': 'Hummus + que rau củ',
        'fa': 'حمص + چوب‌های سبزیجات',
        'pl': 'Hummus + słupki warzywne',
      }),
      L('Hafif ara öğün, lif.', 'Light snack, fiber.', more: {
        'hi': 'हल्का नाश्ता, फाइबर।',
        'pt': 'Lanche leve, fibra.',
        'es': 'Merienda ligera, fibra.',
        'id': 'Camilan ringan, serat.',
        'ur': 'ہلکا ناشتہ، فائبر۔',
        'bn': 'হালকা নাস্তা, ফাইবার।',
        'ar': 'وجبة خفيفة، ألياف.',
        'ru': 'Лёгкий перекус, клетчатка.',
        'de': 'Leichter Snack, Ballaststoffe.',
        'fr': 'Collation légère, fibres.',
        'it': 'Spuntino leggero, fibre.',
        'ja': '軽いおやつ、食物繊維。',
        'ko': '가벼운 간식, 섬유질.',
        'zh': '清淡零食，纤维。',
        'fil': 'Magaan na meryenda, fiber.',
        'vi': 'Bữa ăn nhẹ, chất xơ.',
        'fa': 'میان‌وعده سبک، فیبر.',
        'pl': 'Lekka przekąska, błonnik.',
      }),
      blockDislikes: ['legumes', 'veg'],
    ),
    _FoodIdea(
      L('Tam tahıllı makarna + ton',
          'Whole-grain pasta + tuna', more: {
        'hi': 'साबुत अनाज पास्ता + टूना',
        'pt': 'Massa integral + atum',
        'es': 'Pasta integral + atún',
        'id': 'Pasta gandum utuh + tuna',
        'ur': 'سارا اناج پاستا + ٹونا',
        'bn': 'গোটা শস্যের পাস্তা + টুনা',
        'ar': 'معكرونة الحبوب الكاملة + تونة',
        'ru': 'Макароны из цельного зерна + тунец',
        'de': 'Vollkornpasta + Thunfisch',
        'fr': 'Pâtes complètes + thon',
        'it': 'Pasta integrale + tonno',
        'ja': '全粒粉パスタ＋ツナ',
        'ko': '통곡물 파스타 + 참치',
        'zh': '全麦意面+金枪鱼',
        'fil': 'Whole-grain pasta + tuna',
        'vi': 'Mì ống nguyên cám + cá ngừ',
        'fa': 'پاستای غلات کامل + تن ماهی',
        'pl': 'Makaron pełnoziarnisty + tuńczyk',
      }),
      L('Karbonhidrat + protein.', 'Carbs + protein.', more: {
        'hi': 'कार्ब्स + प्रोटीन।',
        'pt': 'Carboidratos + proteína.',
        'es': 'Carbohidratos + proteína.',
        'id': 'Karbohidrat + protein.',
        'ur': 'کاربوہائیڈریٹ + پروٹین۔',
        'bn': 'কার্বোহাইড্রেট + প্রোটিন।',
        'ar': 'كربوهيدرات + بروتين.',
        'ru': 'Углеводы + белок.',
        'de': 'Kohlenhydrate + Protein.',
        'fr': 'Glucides + protéines.',
        'it': 'Carboidrati + proteine.',
        'ja': '炭水化物＋タンパク質。',
        'ko': '탄수화물 + 단백질.',
        'zh': '碳水+蛋白质。',
        'fil': 'Carbs + protein.',
        'vi': 'Carb + protein.',
        'fa': 'کربوهیدرات + پروتئین.',
        'pl': 'Węglowodany + białko.',
      }),
      blockAllergens: ['gluten', 'seafood'],
    ),
  ];

  static const _moodPositive = <_Idea>[
    _Idea(
      L('5 dakika minnet listesi', '5-minute gratitude list', more: {
        'hi': '५ मिनट की कृतज्ञता सूची',
        'pt': 'Lista de gratidão de 5 minutos',
        'es': 'Lista de gratitud de 5 minutos',
        'id': 'Daftar syukur 5 menit',
        'ur': '۵ منٹ کی شکرگزاری کی فہرست',
        'bn': '৫ মিনিটের কৃতজ্ঞতা তালিকা',
        'ar': 'قائمة الامتنان لمدة 5 دقائق',
        'ru': 'Список благодарности на 5 минут',
        'de': '5-Minuten-Dankbarkeitsliste',
        'fr': 'Liste de gratitude de 5 minutes',
        'it': 'Lista di gratitudine di 5 minuti',
        'ja': '5分間の感謝リスト',
        'ko': '5분 감사 목록',
        'zh': '5分钟感恩清单',
        'fil': '5 minutong listahan ng pasasalamat',
        'vi': 'Danh sách lòng biết ơn 5 phút',
        'fa': 'فهرست سپاسگزاری ۵ دقیقه‌ای',
        'pl': '5-minutowa lista wdzięczności',
      }),
      L('Bugün şükrettiğin 3 şeyi yaz.',
          'Write 3 things you\'re grateful for today.', more: {
        'hi': 'आज की 3 चीज़ें लिखें जिनके लिए आप आभारी हैं।',
        'pt': 'Escreva 3 coisas pelas quais você é grata hoje.',
        'es': 'Escribe 3 cosas por las que estés agradecida hoy.',
        'id': 'Tulis 3 hal yang kamu syukuri hari ini.',
        'ur': 'آج کی 3 چیزیں لکھیں جن کے لیے آپ شکرگزار ہیں۔',
        'bn': 'আজকে আপনি কৃতজ্ঞ ৩টি জিনিস লিখুন।',
        'ar': 'اكتبي 3 أشياء أنتِ ممتنة لها اليوم.',
        'ru': 'Напиши 3 вещи, за которые ты благодарна сегодня.',
        'de': 'Schreib 3 Dinge auf, für die du heute dankbar bist.',
        'fr': 'Écris 3 choses pour lesquelles tu es reconnaissante aujourd\'hui.',
        'it': 'Scrivi 3 cose per cui sei grata oggi.',
        'ja': '今日感謝していることを3つ書き出してください。',
        'ko': '오늘 감사한 일 3가지를 적어보세요.',
        'zh': '写下今天你感恩的3件事。',
        'fil': 'Sumulat ng 3 bagay na pinasasalamatan mo ngayong araw.',
        'vi': 'Viết 3 điều bạn biết ơn hôm nay.',
        'fa': '۳ چیزی را که امروز برایشان سپاسگزار هستی بنویس.',
        'pl': 'Napisz 3 rzeczy, za które jesteś dzisiaj wdzięczna.',
      }),
    ),
    _Idea(
      L('Bebekle güneşli mola', 'Sunny break with baby', more: {
        'hi': 'बच्चे के साथ धूप में ब्रेक',
        'pt': 'Pausa ensolarada com o bebê',
        'es': 'Pausa soleada con el bebé',
        'id': 'Istirahat cerah dengan bayi',
        'ur': 'بچے کے ساتھ دھوپ والا وقفہ',
        'bn': 'বাচ্চার সাথে রৌদ্রজ্জ্বল বিরতি',
        'ar': 'استراحة مشمسة مع الطفل',
        'ru': 'Солнечный перерыв с малышом',
        'de': 'Sonnige Pause mit dem Baby',
        'fr': 'Pause ensoleillée avec bébé',
        'it': 'Pausa soleggiata con il bambino',
        'ja': '赤ちゃんと日向ぼっこ',
        'ko': '아기와 함께하는 햇볕 쬐기',
        'zh': '和宝宝一起享受阳光',
        'fil': 'Maaraw na pahinga kasama si baby',
        'vi': 'Nghỉ ngơi dưới nắng cùng bé',
        'fa': 'استراحت آفتابی با نوزاد',
        'pl': 'Słoneczna przerwa z dzieckiem',
      }),
      L('10 dk açık hava ruh halini yükseltir.',
          '10 min outdoors lifts your mood.', more: {
        'hi': '१० मिनट बाहर रहने से मूड बेहतर होता है।',
        'pt': '10 min ao ar livre melhora seu humor.',
        'es': '10 min al aire libre mejora tu estado de ánimo.',
        'id': '10 mnt di luar ruangan meningkatkan suasana hati.',
        'ur': '۱۰ منٹ باہر رہنے سے مزاج بہتر ہوتا ہے۔',
        'bn': 'বাইরে ১০ মিনিট মেজাজ উন্নত করে।',
        'ar': '10 دقائق في الهواء الطلق ترفع مزاجك.',
        'ru': '10 минут на свежем воздухе поднимают настроение.',
        'de': '10 Min draußen heben deine Stimmung.',
        'fr': '10 min dehors améliore ton humeur.',
        'it': '10 min all\'aperto migliorano l\'umore.',
        'ja': '屋外で10分過ごすと気分が上向きます。',
        'ko': '야외 10분이 기분을 좋게 합니다.',
        'zh': '户外10分钟可以改善心情。',
        'fil': '10 min sa labas ay nagpapasigla ng iyong mood.',
        'vi': '10 phút ngoài trời cải thiện tâm trạng.',
        'fa': '۱۰ دقیقه در فضای باز حالت را بهتر می‌کند.',
        'pl': '10 minut na zewnątrz poprawia nastrój.',
      }),
    ),
  ];
  static const _moodNegative = <_Idea>[
    _Idea(
      L('4-4-4 nefes', '4-4-4 breathing', more: {
        'hi': '४-४-४ श्वास',
        'pt': 'Respiração 4-4-4',
        'es': 'Respiración 4-4-4',
        'id': 'Pernapasan 4-4-4',
        'ur': '۴-۴-۴ سانس',
        'bn': '৪-৪-৪ শ্বাস',
        'ar': 'تنفس 4-4-4',
        'ru': 'Дыхание 4-4-4',
        'de': '4-4-4-Atmung',
        'fr': 'Respiration 4-4-4',
        'it': 'Respiro 4-4-4',
        'ja': '4-4-4呼吸法',
        'ko': '4-4-4 호흡',
        'zh': '4-4-4呼吸法',
        'fil': '4-4-4 paghinga',
        'vi': 'Thở 4-4-4',
        'fa': 'تنفس ۴-۴-۴',
        'pl': 'Oddychanie 4-4-4',
      }),
      L('Stresi düşürmek için kısa nefes turu.',
          'A short breath cycle to lower stress.', more: {
        'hi': 'तनाव कम करने के लिए एक छोटा श्वास चक्र।',
        'pt': 'Um ciclo curto de respiração para reduzir o estresse.',
        'es': 'Un breve ciclo de respiración para reducir el estrés.',
        'id': 'Siklus napas pendek untuk menurunkan stres.',
        'ur': 'تناؤ کم کرنے کے لیے سانس کا ایک چھوٹا چکر۔',
        'bn': 'স্ট্রেস কমানোর জন্য একটি সংক্ষিপ্ত শ্বাস চক্র।',
        'ar': 'دورة تنفس قصيرة لتخفيف التوتر.',
        'ru': 'Короткий дыхательный цикл для снижения стресса.',
        'de': 'Ein kurzer Atemzyklus, um Stress abzubauen.',
        'fr': 'Un court cycle de respiration pour réduire le stress.',
        'it': 'Un breve ciclo di respiro per ridurre lo stress.',
        'ja': 'ストレスを下げるための短い呼吸サイクル。',
        'ko': '스트레스 완화를 위한 짧은 호흡 주기.',
        'zh': '一个简短的呼吸循环来减轻压力。',
        'fil': 'Isang maikling ikot ng paghinga upang mabawasan ang stress.',
        'vi': 'Một chu kỳ thở ngắn để giảm căng thẳng.',
        'fa': 'یک چرخه تنفس کوتاه برای کاهش استرس.',
        'pl': 'Krótki cykl oddechowy w celu obniżenia stresu.',
      }),
    ),
    _Idea(
      L('Sevdiğin birini ara', 'Call a loved one', more: {
        'hi': 'किसी प्रियजन को कॉल करें',
        'pt': 'Ligue para alguém querido',
        'es': 'Llama a un ser querido',
        'id': 'Telepon orang yang kamu sayangi',
        'ur': 'کسی عزیز کو کال کریں',
        'bn': 'প্রিয় কাউকে ফোন করুন',
        'ar': 'اتصلي بأحد أحبائك',
        'ru': 'Позвони близкому человеку',
        'de': 'Ruf einen geliebten Menschen an',
        'fr': 'Appelle un être cher',
        'it': 'Chiama una persona cara',
        'ja': '大切な人に電話する',
        'ko': '사랑하는 사람에게 전화하세요',
        'zh': '给亲人打个电话',
        'fil': 'Tawagan ang isang mahal sa buhay',
        'vi': 'Gọi cho người thân yêu',
        'fa': 'به یک عزیز زنگ بزن',
        'pl': 'Zadzwoń do bliskiej osoby',
      }),
      L('Kısa bir sohbet yalnızlığı azaltır.',
          'A short chat eases loneliness.', more: {
        'hi': 'एक छोटी सी बातचीत अकेलापन कम करती है।',
        'pt': 'Uma conversa curta alivia a solidão.',
        'es': 'Una charla corta alivia la soledad.',
        'id': 'Obrolan singkat mengurangi kesepian.',
        'ur': 'ایک چھوٹی سی گفتگو تنہائی کم کرتی ہے۔',
        'bn': 'একটি ছোট আলাপ একাকীত্ব কমায়।',
        'ar': 'محادثة قصيرة تخفف الوحدة.',
        'ru': 'Короткий разговор уменьшает одиночество.',
        'de': 'Ein kurzes Gespräch lindert Einsamkeit.',
        'fr': 'Une courte conversation atténue la solitude.',
        'it': 'Una breve chiacchierata allevia la solitudine.',
        'ja': '短いおしゃべりが孤独を和らげます。',
        'ko': '짧은 대화가 외로움을 덜어줍니다.',
        'zh': '短暂的聊天可以缓解孤独感。',
        'fil': 'Ang maikling usapan ay nagpapagaan ng kalungkutan.',
        'vi': 'Một cuộc trò chuyện ngắn làm dịu nỗi cô đơn.',
        'fa': 'یک گفتگوی کوتاه تنهایی را کاهش می‌دهد.',
        'pl': 'Krótka rozmowa łagodzi samotność.',
      }),
    ),
    _Idea(
      L('Sıcak duş + müzik', 'Warm shower + music', more: {
        'hi': 'गर्म स्नान + संगीत',
        'pt': 'Banho quente + música',
        'es': 'Ducha caliente + música',
        'id': 'Mandi air hangat + musik',
        'ur': 'گرم شاور + موسیقی',
        'bn': 'গরম ঝরনা + সঙ্গীত',
        'ar': 'دش دافئ + موسيقى',
        'ru': 'Тёплый душ + музыка',
        'de': 'Warme Dusche + Musik',
        'fr': 'Douche chaude + musique',
        'it': 'Doccia calda + musica',
        'ja': '温かいシャワー＋音楽',
        'ko': '따뜻한 샤워 + 음악',
        'zh': '热水澡+音乐',
        'fil': 'Mainit na shower + musika',
        'vi': 'Tắm nước ấm + nhạc',
        'fa': 'دوش گرم + موسیقی',
        'pl': 'Ciepły prysznic + muzyka',
      }),
      L('Bedenini gevşet, kendine 10 dk ayır.',
          'Relax your body, take 10 min for yourself.', more: {
        'hi': 'अपने शरीर को आराम दें, अपने लिए १० मिनट निकालें।',
        'pt': 'Relaxe seu corpo, reserve 10 min para si mesma.',
        'es': 'Relaja tu cuerpo, tómate 10 min para ti.',
        'id': 'Rilekskan tubuhmu, luangkan 10 menit untuk dirimu sendiri.',
        'ur': 'اپنے جسم کو آرام دیں، اپنے لیے ۱۰ منٹ نکالیں۔',
        'bn': 'শরীর শিথিল করুন, নিজের জন্য ১০ মিনিট নিন।',
        'ar': 'استرخي، خذي 10 دقائق لنفسك.',
        'ru': 'Расслабь тело, удели себе 10 минут.',
        'de': 'Entspanne deinen Körper, nimm dir 10 Minuten für dich.',
        'fr': 'Détends ton corps, prends 10 min pour toi.',
        'it': 'Rilassa il corpo, prenditi 10 min per te.',
        'ja': '体をリラックスさせて、自分のために10分取りましょう。',
        'ko': '몸을 이완시키고, 자신을 위해 10분을 내세요.',
        'zh': '放松身体，给自己10分钟。',
        'fil': 'Magpahinga ng katawan, maglaan ng 10 min para sa iyong sarili.',
        'vi': 'Thư giãn cơ thể, dành 10 phút cho bản thân.',
        'fa': 'بدنت را رها کن، ۱۰ دقیقه برای خودت وقت بگذار.',
        'pl': 'Rozluźnij ciało, weź 10 minut dla siebie.',
      }),
    ),
  ];

  static const _exerciseNormal = <_Idea>[
    _Idea(
      L('Yumuşak kedi-inek (5 dk)', 'Gentle cat-cow (5 min)', more: {
        'hi': 'कोमल बिल्ली-गाय (५ मिनट)',
        'pt': 'Gato-vaca suave (5 min)',
        'es': 'Gato-vaca suave (5 min)',
        'id': 'Kucing-sapi lembut (5 mnt)',
        'ur': 'نرم بلی-گائے (۵ منٹ)',
        'bn': 'মৃদু বিড়াল-গরু (৫ মিনিট)',
        'ar': 'القط-البقرة اللطيف (5 د)',
        'ru': 'Мягкая кошка-корова (5 мин)',
        'de': 'Sanfte Katze-Kuh (5 Min)',
        'fr': 'Chat-vache doux (5 min)',
        'it': 'Gatto-mucca delicato (5 min)',
        'ja': '優しいキャットカウ（5分）',
        'ko': '부드러운 고양이-소 (5분)',
        'zh': '温和的猫牛式（5分钟）',
        'fil': 'Mahinang cat-cow (5 min)',
        'vi': 'Mèo-bò nhẹ nhàng (5 phút)',
        'fa': 'گربه-گاو نرم (۵ دقیقه)',
        'pl': 'Łagodny kot-krowa (5 min)',
      }),
      L('Sırtı esnetir.', 'Stretches the back.', more: {
        'hi': 'पीठ को स्ट्रेच करता है।',
        'pt': 'Alonga as costas.',
        'es': 'Estira la espalda.',
        'id': 'Meregangkan punggung.',
        'ur': 'کمر کو کھینچتا ہے۔',
        'bn': 'পিঠ প্রসারিত করে।',
        'ar': 'يمد الظهر.',
        'ru': 'Растягивает спину.',
        'de': 'Dehnt den Rücken.',
        'fr': 'Étire le dos.',
        'it': 'Allunga la schiena.',
        'ja': '背中を伸ばします。',
        'ko': '등을 스트레칭합니다.',
        'zh': '拉伸背部。',
        'fil': 'Nag-uunat ng likod.',
        'vi': 'Kéo giãn lưng.',
        'fa': 'پشت را کش می‌دهد.',
        'pl': 'Rozciąga plecy.',
      }),
    ),
    _Idea(
      L('Kısa yürüyüş (10 dk)', 'Short walk (10 min)', more: {
        'hi': 'छोटी सैर (१० मिनट)',
        'pt': 'Caminhada curta (10 min)',
        'es': 'Paseo corto (10 min)',
        'id': 'Jalan kaki pendek (10 mnt)',
        'ur': 'چھوٹی چہل قدمی (۱۰ منٹ)',
        'bn': 'ছোট হাঁটা (১০ মিনিট)',
        'ar': 'مشي قصير (10 د)',
        'ru': 'Короткая прогулка (10 мин)',
        'de': 'Kurzer Spaziergang (10 Min)',
        'fr': 'Courte marche (10 min)',
        'it': 'Breve passeggiata (10 min)',
        'ja': '短い散歩（10分）',
        'ko': '짧은 산책 (10분)',
        'zh': '短距离散步（10分钟）',
        'fil': 'Maikling lakad (10 min)',
        'vi': 'Đi bộ ngắn (10 phút)',
        'fa': 'پیاده‌روی کوتاه (۱۰ دقیقه)',
        'pl': 'Krótki spacer (10 min)',
      }),
      L('Açık havada hafif tempo.',
          'Easy outdoor pace.', more: {
        'hi': 'खुली हवा में हल्की गति।',
        'pt': 'Ritmo leve ao ar livre.',
        'es': 'Ritmo ligero al aire libre.',
        'id': 'Kecepatan ringan di luar ruangan.',
        'ur': 'کھلی ہوا میں ہلکی رفتار۔',
        'bn': 'খোলা বাতাসে হালকা গতি।',
        'ar': 'وتيرة خفيفة في الهواء الطلق.',
        'ru': 'Лёгкий темп на свежем воздухе.',
        'de': 'Leichtes Tempo an der frischen Luft.',
        'fr': 'Rythme léger en plein air.',
        'it': 'Passo leggero all\'aria aperta.',
        'ja': '屋外での軽いペース。',
        'ko': '야외에서 가벼운 속도.',
        'zh': '户外轻松的步伐。',
        'fil': 'Magaan na bilis sa labas.',
        'vi': 'Nhịp độ nhẹ nhàng ngoài trời.',
        'fa': 'سرعت ملایم در فضای باز.',
        'pl': 'Lekkie tempo na świeżym powietrzu.',
      }),
    ),
    _Idea(
      L('Kegel egzersizi (5 dk)', 'Kegel exercise (5 min)', more: {
        'hi': 'केगल व्यायाम (५ मिनट)',
        'pt': 'Exercício Kegel (5 min)',
        'es': 'Ejercicio de Kegel (5 min)',
        'id': 'Latihan Kegel (5 mnt)',
        'ur': 'کیگل ورزش (۵ منٹ)',
        'bn': 'কেগেল ব্যায়াম (৫ মিনিট)',
        'ar': 'تمرين كيغل (5 د)',
        'ru': 'Упражнение Кегеля (5 мин)',
        'de': 'Kegel-Übung (5 Min)',
        'fr': 'Exercice de Kegel (5 min)',
        'it': 'Esercizio di Kegel (5 min)',
        'ja': 'ケーゲル体操（5分）',
        'ko': '케겔 운동 (5분)',
        'zh': '凯格尔运动（5分钟）',
        'fil': 'Ehersisyo ng Kegel (5 min)',
        'vi': 'Bài tập Kegel (5 phút)',
        'fa': 'تمرین کگل (۵ دقیقه)',
        'pl': 'Ćwiczenie Kegla (5 min)',
      }),
      L('Pelvik tabanı güçlendirir.',
          'Strengthens the pelvic floor.', more: {
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
    ),
  ];

  static const _exerciseC = <_Idea>[
    _Idea(
      L('Diyafram nefesi (5 dk)',
          'Diaphragmatic breathing (5 min)', more: {
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
      L('Karın derin nefes, yara güvenli.',
          'Deep belly breath, incision-safe.', more: {
        'hi': 'गहरी पेट की साँस, चीरे के लिए सुरक्षित।',
        'pt': 'Respiração profunda da barriga, segura para a incisão.',
        'es': 'Respiración profunda de vientre, segura para la incisión.',
        'id': 'Napas perut dalam, aman untuk luka sayatan.',
        'ur': 'پیٹ کی گہری سانس، زخم کے لیے محفوظ۔',
        'bn': 'গভীর পেটের শ্বাস, ছেদনের জন্য নিরাপদ।',
        'ar': 'نفس عميق من البطن، آمن للشق الجراحي.',
        'ru': 'Глубокое дыхание животом, безопасное при разрезе.',
        'de': 'Tiefe Bauchatmung, schnittwundensicher.',
        'fr': 'Respiration profonde du ventre, sans risque pour l\'incision.',
        'it': 'Respiro profondo della pancia, sicuro per l\'incisione.',
        'ja': '深い腹式呼吸、切開部に安全。',
        'ko': '깊은 배 호흡, 절개 부위에 안전.',
        'zh': '深腹式呼吸，对切口安全。',
        'fil': 'Malalim na paghinga sa tiyan, ligtas sa sugat.',
        'vi': 'Thở bụng sâu, an toàn cho vết mổ.',
        'fa': 'نفس عمیق شکمی، ایمن برای برش.',
        'pl': 'Głęboki oddech brzuchem, bezpieczny dla nacięcia.',
      }),
    ),
    _Idea(
      L('Boyun + omuz esneme', 'Neck + shoulder stretch', more: {
        'hi': 'गर्दन + कंधे का स्ट्रेच',
        'pt': 'Alongamento de pescoço + ombros',
        'es': 'Estiramiento de cuello + hombros',
        'id': 'Peregangan leher + bahu',
        'ur': 'گردن + کندھے کا اسٹریچ',
        'bn': 'ঘাড় + কাঁধের স্ট্রেচ',
        'ar': 'تمدد الرقبة + الكتفين',
        'ru': 'Растяжка шеи + плеч',
        'de': 'Nacken + Schulter dehnen',
        'fr': 'Étirement du cou + épaules',
        'it': 'Stretching di collo + spalle',
        'ja': '首＋肩のストレッチ',
        'ko': '목 + 어깨 스트레칭',
        'zh': '颈肩拉伸',
        'fil': 'Pag-unat ng leeg + balikat',
        'vi': 'Kéo giãn cổ + vai',
        'fa': 'کشش گردن + شانه',
        'pl': 'Rozciąganie szyi + ramion',
      }),
      L('Emzirme sertliğini geçirir.',
          'Eases nursing stiffness.', more: {
        'hi': 'स्तनपान की जकड़न को कम करता है।',
        'pt': 'Alivia a rigidez da amamentação.',
        'es': 'Alivia la rigidez de la lactancia.',
        'id': 'Meredakan kekakuan menyusui.',
        'ur': 'دودھ پلانے کی سختی کو دور کرتا ہے۔',
        'bn': 'স্তন্যপানের শক্তভাব দূর করে।',
        'ar': 'يخفف تيبس الرضاعة.',
        'ru': 'Снимает скованность после кормления.',
        'de': 'Lindert die Steifheit beim Stillen.',
        'fr': 'Soulage la raideur de l\'allaitement.',
        'it': 'Allevia la rigidità dell\'allattamento.',
        'ja': '授乳によるこわばりを和らげます。',
        'ko': '수유 뻣뻣함을 완화합니다.',
        'zh': '缓解哺乳引起的僵硬。',
        'fil': 'Nagpapagaan ng paninigas dahil sa pagpapasuso.',
        'vi': 'Giảm cứng do cho con bú.',
        'fa': 'سفتی شیردهی را کاهش می‌دهد.',
        'pl': 'Łagodzi sztywność po karmieniu.',
      }),
    ),
    _Idea(
      L('Yavaş yürüyüş (5 dk)', 'Slow walk (5 min)', more: {
        'hi': 'धीमी सैर (५ मिनट)',
        'pt': 'Caminhada lenta (5 min)',
        'es': 'Paseo lento (5 min)',
        'id': 'Jalan kaki lambat (5 mnt)',
        'ur': 'آہستہ چہل قدمی (۵ منٹ)',
        'bn': 'ধীর হাঁটা (৫ মিনিট)',
        'ar': 'مشي بطيء (5 د)',
        'ru': 'Медленная прогулка (5 мин)',
        'de': 'Langsamer Spaziergang (5 Min)',
        'fr': 'Marche lente (5 min)',
        'it': 'Passeggiata lenta (5 min)',
        'ja': 'ゆっくり歩き（5分）',
        'ko': '천천히 걷기 (5분)',
        'zh': '慢走（5分钟）',
        'fil': 'Mabagal na lakad (5 min)',
        'vi': 'Đi bộ chậm (5 phút)',
        'fa': 'پیاده‌روی آهسته (۵ دقیقه)',
        'pl': 'Wolny spacer (5 min)',
      }),
      L('Ev içi kısa adımlar.', 'Small steps around the house.', more: {
        'hi': 'घर के अंदर छोटे कदम।',
        'pt': 'Passos curtos dentro de casa.',
        'es': 'Pasos cortos dentro de casa.',
        'id': 'Langkah kecil di sekitar rumah.',
        'ur': 'گھر کے اندر چھوٹے قدم۔',
        'bn': 'বাড়ির ভিতরে ছোট পদক্ষেপ।',
        'ar': 'خطوات قصيرة داخل المنزل.',
        'ru': 'Небольшие шаги по дому.',
        'de': 'Kleine Schritte im Haus.',
        'fr': 'Petits pas dans la maison.',
        'it': 'Piccoli passi in casa.',
        'ja': '家の中での小さな歩幅。',
        'ko': '집 안에서 작은 걸음.',
        'zh': '在家里小步走动。',
        'fil': 'Maliit na hakbang sa paligid ng bahay.',
        'vi': 'Những bước nhỏ quanh nhà.',
        'fa': 'قدم‌های کوتاه در خانه.',
        'pl': 'Małe kroki po domu.',
      }),
    ),
  ];

  List<T> _pickRandom<T>(List<T> input, int n, int seed) {
    final a = List<T>.of(input);
    var s = seed;
    for (var i = a.length - 1; i > 0; i--) {
      s = (s * 9301 + 49297) % 233280;
      final j = ((s / 233280) * (i + 1)).floor();
      final tmp = a[i];
      a[i] = a[j];
      a[j] = tmp;
    }
    return a.take(n).toList();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final profile = widget.repository.profile;
    final todayMood = widget.repository.moods
        .where((m) => m.date == todayKey())
        .firstOrNull;
    final negative =
        todayMood != null && negativeMoods.contains(todayMood.mood);

    final items = <_Suggestion>[];
    if (_tab == _Tab.food) {
      final allergens = profile?.allergens ?? const <String>[];
      final dislikes = profile?.dislikes ?? const <String>[];
      final safe = _foodPool.where((f) {
        final ba =
            f.blockAllergens.any((a) => allergens.contains(a));
        final bd = f.blockDislikes.any((d) => dislikes.contains(d));
        return !ba && !bd;
      }).toList();
      final pool = safe.isEmpty ? _foodPool : safe;
      items.addAll(
        _pickRandom(pool, 3, _seed).map(
          (m) => _Suggestion(m.title, m.desc, '/nutrition', t.recLogMeal),
        ),
      );
    } else if (_tab == _Tab.mood) {
      final pool = negative ? _moodNegative : _moodPositive;
      items.addAll(
        _pickRandom(pool, pool.length.clamp(0, 3), _seed).map(
          (m) => _Suggestion(
            m.title,
            m.desc,
            negative ? '/breathing' : '/mood',
            negative ? t.recTryNow : t.recLogMood,
          ),
        ),
      );
    } else {
      final pool = profile?.birthType == BirthType.csection
          ? _exerciseC
          : _exerciseNormal;
      items.addAll(
        _pickRandom(pool, pool.length.clamp(0, 3), _seed).map(
          (m) => _Suggestion(m.title, m.desc, '/exercise', t.recStart),
        ),
      );
    }

    return MomriseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  t.recTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: 'refresh',
                icon: const Icon(Icons.refresh_rounded, size: 18),
                onPressed: () => setState(() => _seed += 7),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _segment(_Tab.food, t.recFood, Icons.restaurant_rounded),
                _segment(_Tab.mood, t.recMood, Icons.sentiment_satisfied_rounded),
                _segment(_Tab.exercise, t.recExercise, Icons.fitness_center_rounded),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((it) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: scheme.outline.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              it.title.of(context),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              it.desc.of(context),
                              style: TextStyle(
                                fontSize: 11,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push(it.to),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(it.cta),
                            const Icon(Icons.chevron_right_rounded, size: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _segment(_Tab tab, String label, IconData icon) {
    final active = _tab == tab;
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => setState(() => _tab = tab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active ? scheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: active ? scheme.onSurface : scheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: active
                      ? scheme.onSurface
                      : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Idea {
  const _Idea(this.title, this.desc);
  final L title;
  final L desc;
}

class _FoodIdea {
  const _FoodIdea(
    this.title,
    this.desc, {
    this.blockAllergens = const <String>[],
    this.blockDislikes = const <String>[],
  });
  final L title;
  final L desc;
  final List<String> blockAllergens;
  final List<String> blockDislikes;
}

class _Suggestion {
  const _Suggestion(this.title, this.desc, this.to, this.cta);
  final L title;
  final L desc;
  final String to;
  final String cta;
}
