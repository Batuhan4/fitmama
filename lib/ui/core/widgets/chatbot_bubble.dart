import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/services/gemini_service.dart';
import '../../../utils/localized.dart';

const _kPosKey = 'chatbot_bubble_pos_y';
const _kSideKey = 'chatbot_bubble_side'; // 'left' or 'right'

const _bubbleSize = 60.0;
const _bubbleMargin = 12.0;

const _title = L('Momi · Duygusal Destek', 'Momi · Emotional Support', more: {
  'de': 'Momi · Emotionale Unterstützung',
  'fr': 'Momi · Soutien émotionnel',
  'es': 'Momi · Apoyo emocional',
  'pt': 'Momi · Apoio emocional',
  'it': 'Momi · Sostegno emotivo',
  'ru': 'Momi · Эмоциональная поддержка',
  'pl': 'Momi · Wsparcie emocjonalne',
  'hi': 'Momi · भावनात्मक सहारा',
  'id': 'Momi · Dukungan emosional',
  'ur': 'Momi · جذباتی سہارا',
  'bn': 'Momi · মানসিক সহায়তা',
  'ar': 'Momi · دعم عاطفي',
  'ja': 'Momi · 心のサポート',
  'ko': 'Momi · 정서적 지지',
  'zh': 'Momi · 情绪支持',
  'fil': 'Momi · Emosyonal na suporta',
  'vi': 'Momi · Hỗ trợ tinh thần',
  'fa': 'Momi · حمایت عاطفی',
});

const _hint = L('Bugün nasıl hissediyorsun?', 'How are you feeling today?',
    more: {
      'de': 'Wie fühlst du dich heute?',
      'fr': "Comment te sens-tu aujourd'hui ?",
      'es': '¿Cómo te sientes hoy?',
      'pt': 'Como você está se sentindo hoje?',
      'it': 'Come ti senti oggi?',
      'ru': 'Как ты себя чувствуешь сегодня?',
      'pl': 'Jak się dziś czujesz?',
      'hi': 'आज आप कैसा महसूस कर रहे हैं?',
      'id': 'Bagaimana perasaanmu hari ini?',
      'ur': 'آج آپ کیسا محسوس کر رہی ہیں؟',
      'bn': 'আজ আপনি কেমন অনুভব করছেন?',
      'ar': 'كيف تشعرين اليوم؟',
      'ja': '今日はどんな気分ですか？',
      'ko': '오늘 기분이 어떠세요?',
      'zh': '今天感觉怎么样？',
      'fil': 'Kumusta ang pakiramdam mo ngayon?',
      'vi': 'Hôm nay bạn cảm thấy thế nào?',
      'fa': 'امروز چه احساسی داری؟',
    });

const _greeting = L(
    'Merhaba 💜 Buradayım. İçinden geçenleri yazmak istersen seni dinliyorum.',
    'Hi 💜 I am here. If you want to share what is on your mind, I am listening.',
    more: {
      'de':
          'Hallo 💜 Ich bin hier. Wenn du schreiben möchtest, was dich beschäftigt — ich höre zu.',
      'fr':
          'Bonjour 💜 Je suis là. Si tu veux écrire ce que tu ressens, je t’écoute.',
      'es':
          'Hola 💜 Estoy aquí. Si quieres contarme cómo te sientes, te escucho.',
      'pt':
          'Olá 💜 Estou aqui. Se quiser me contar o que está sentindo, te escuto.',
      'it':
          'Ciao 💜 Sono qui. Se vuoi scrivermi come ti senti, ti ascolto.',
      'ru': 'Привет 💜 Я здесь. Если хочешь поделиться — я слушаю.',
      'pl':
          'Cześć 💜 Jestem tutaj. Jeśli chcesz napisać, co czujesz — słucham.',
      'hi': 'नमस्ते 💜 मैं यहाँ हूँ। आप जो महसूस कर रही हैं, बताइए।',
      'id':
          'Halo 💜 Aku di sini. Kalau ingin bercerita tentang perasaanmu, aku mendengarkan.',
      'ur':
          'سلام 💜 میں یہاں ہوں۔ آپ جو محسوس کر رہی ہیں، بتائیں۔ میں سن رہی ہوں۔',
      'bn':
          'হাই 💜 আমি এখানে আছি। আপনি যা অনুভব করছেন তা বলুন, আমি শুনছি।',
      'ar': 'مرحباً 💜 أنا هنا. شاركيني مشاعرك، أنا أستمع.',
      'ja': 'こんにちは 💜 ここにいます。気持ちを話してくれたら聞きますよ。',
      'ko': '안녕하세요 💜 여기 있어요. 마음에 있는 것을 적어주세요. 듣고 있어요.',
      'zh': '你好 💜 我在这里。想聊聊心里的事，我在听。',
      'fil':
          'Kumusta 💜 Nandito ako. Kung gusto mong ibahagi ang nararamdaman mo, nakikinig ako.',
      'vi':
          'Chào bạn 💜 Mình ở đây. Nếu muốn chia sẻ cảm xúc, mình đang lắng nghe.',
      'fa': 'سلام 💜 من اینجا هستم. هرچه حس می‌کنی برایم بنویس، گوش می‌دهم.',
    });

const _suggestions = [
  L('Bugün çok yorgunum', "I'm really tired today", more: {
    'de': 'Ich bin heute sehr müde',
    'fr': "Je suis très fatiguée aujourd'hui",
    'es': 'Hoy estoy muy cansada',
    'pt': 'Hoje estou muito cansada',
    'it': 'Oggi sono molto stanca',
    'ru': 'Я очень устала сегодня',
    'pl': 'Jestem dziś bardzo zmęczona',
    'hi': 'आज मैं बहुत थकी हुई हूँ',
    'id': 'Hari ini aku sangat lelah',
    'ur': 'آج میں بہت تھک گئی ہوں',
    'bn': 'আজ আমি খুব ক্লান্ত',
    'ar': 'أشعر بتعب شديد اليوم',
    'ja': '今日はとても疲れています',
    'ko': '오늘 너무 피곤해요',
    'zh': '我今天好累',
    'fil': 'Pagod na pagod ako ngayon',
    'vi': 'Hôm nay tôi rất mệt',
    'fa': 'امروز خیلی خسته‌ام',
  }),
  L('Endişeliyim', "I'm anxious", more: {
    'de': 'Ich bin ängstlich',
    'fr': 'Je suis anxieuse',
    'es': 'Estoy ansiosa',
    'pt': 'Estou ansiosa',
    'it': 'Sono ansiosa',
    'ru': 'Я тревожусь',
    'pl': 'Jestem zaniepokojona',
    'hi': 'मैं चिंतित हूँ',
    'id': 'Aku cemas',
    'ur': 'میں پریشان ہوں',
    'bn': 'আমি উদ্বিগ্ন',
    'ar': 'أشعر بالقلق',
    'ja': '不安です',
    'ko': '불안해요',
    'zh': '我很焦虑',
    'fil': 'Kinakabahan ako',
    'vi': 'Tôi đang lo lắng',
    'fa': 'مضطربم',
  }),
  L('Kendimi yalnız hissediyorum', 'I feel lonely', more: {
    'de': 'Ich fühle mich einsam',
    'fr': 'Je me sens seule',
    'es': 'Me siento sola',
    'pt': 'Me sinto sozinha',
    'it': 'Mi sento sola',
    'ru': 'Я чувствую себя одинокой',
    'pl': 'Czuję się samotna',
    'hi': 'मुझे अकेलापन महसूस हो रहा है',
    'id': 'Aku merasa kesepian',
    'ur': 'میں خود کو اکیلا محسوس کر رہی ہوں',
    'bn': 'আমি একা বোধ করছি',
    'ar': 'أشعر بالوحدة',
    'ja': '寂しいです',
    'ko': '외로워요',
    'zh': '我感到孤独',
    'fil': 'Nag-iisa ang pakiramdam ko',
    'vi': 'Tôi cảm thấy cô đơn',
    'fa': 'احساس تنهایی می‌کنم',
  }),
];

class ChatbotOverlay extends StatefulWidget {
  const ChatbotOverlay({super.key, required this.child});

  final Widget child;

  @override
  State<ChatbotOverlay> createState() => _ChatbotOverlayState();
}

class _ChatbotOverlayState extends State<ChatbotOverlay>
    with SingleTickerProviderStateMixin {
  double _y = 0.45; // fraction 0..1 of available height
  String _side = 'right';
  bool _loaded = false;
  bool _dragging = false;
  double _dragX = 0;
  double _dragY = 0;

  late final AnimationController _snapCtrl;
  Animation<Offset>? _snapAnim;

  @override
  void initState() {
    super.initState();
    _snapCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    )..addListener(() {
        if (_snapAnim != null) {
          setState(() {
            _dragX = _snapAnim!.value.dx;
            _dragY = _snapAnim!.value.dy;
          });
        }
      });
    _restore();
  }

  @override
  void dispose() {
    _snapCtrl.dispose();
    super.dispose();
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final y = prefs.getDouble(_kPosKey) ?? 0.45;
    final side = prefs.getString(_kSideKey) ?? 'right';
    if (!mounted) return;
    setState(() {
      _y = y.clamp(0.05, 0.85);
      _side = side;
      _loaded = true;
    });
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kPosKey, _y);
    await prefs.setString(_kSideKey, _side);
  }

  void _openChat(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (_) => const _ChatPanel(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        if (!_loaded) {
          return widget.child;
        }
        final restingX = _side == 'left'
            ? _bubbleMargin
            : c.maxWidth - _bubbleSize - _bubbleMargin;
        final restingY = (_y * (c.maxHeight - _bubbleSize)).clamp(
          _bubbleMargin,
          c.maxHeight - _bubbleSize - _bubbleMargin,
        );
        final left = _dragging || _snapCtrl.isAnimating ? _dragX : restingX;
        final top = _dragging || _snapCtrl.isAnimating ? _dragY : restingY;

        return Stack(
          children: [
            widget.child,
            Positioned(
              left: left,
              top: top,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanStart: (_) {
                  _snapCtrl.stop();
                  setState(() {
                    _dragging = true;
                    _dragX = left;
                    _dragY = top;
                  });
                },
                onPanUpdate: (d) {
                  setState(() {
                    _dragX = (_dragX + d.delta.dx).clamp(
                      0.0,
                      c.maxWidth - _bubbleSize,
                    );
                    _dragY = (_dragY + d.delta.dy).clamp(
                      0.0,
                      c.maxHeight - _bubbleSize,
                    );
                  });
                },
                onPanEnd: (_) => _settle(c.maxWidth, c.maxHeight),
                onTap: () => _openChat(context),
                child: const _FloatingBubble(),
              ),
            ),
          ],
        );
      },
    );
  }

  void _settle(double w, double h) {
    final center = _dragX + _bubbleSize / 2;
    final goLeft = center < w / 2;
    _side = goLeft ? 'left' : 'right';
    final targetX = goLeft
        ? _bubbleMargin
        : w - _bubbleSize - _bubbleMargin;
    final clampedY = _dragY.clamp(
      _bubbleMargin,
      h - _bubbleSize - _bubbleMargin,
    );
    _y = (clampedY - _bubbleMargin) / (h - _bubbleSize - _bubbleMargin * 2);
    _y = _y.clamp(0.0, 1.0);

    _snapAnim = Tween<Offset>(
      begin: Offset(_dragX, _dragY),
      end: Offset(targetX, clampedY),
    ).animate(CurvedAnimation(parent: _snapCtrl, curve: Curves.easeOutBack));
    _snapCtrl.forward(from: 0).then((_) {
      if (!mounted) return;
      setState(() {
        _dragging = false;
      });
      _persist();
    });
  }
}

class _FloatingBubble extends StatefulWidget {
  const _FloatingBubble();

  @override
  State<_FloatingBubble> createState() => _FloatingBubbleState();
}

class _FloatingBubbleState extends State<_FloatingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        final scale = 1 + math.sin(_pulse.value * math.pi * 2) * 0.04;
        return Transform.scale(
          scale: scale,
          child: Container(
            width: _bubbleSize,
            height: _bubbleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFB39DDB), Color(0xFFF5C9D6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7E57C2).withValues(alpha: 0.45),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.7),
                width: 2,
              ),
            ),
            child: const Center(
              child: Icon(Icons.favorite_rounded,
                  color: Colors.white, size: 26),
            ),
          ),
        );
      },
    );
  }
}

class _ChatPanel extends StatefulWidget {
  const _ChatPanel();

  @override
  State<_ChatPanel> createState() => _ChatPanelState();
}

class _ChatPanelState extends State<_ChatPanel> {
  final _service = GeminiService();
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final List<ChatTurn> _turns = [];
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send(String text) async {
    final clean = text.trim();
    if (clean.isEmpty || _loading) return;
    final lang = Localizations.localeOf(context).languageCode;
    setState(() {
      _turns.add(ChatTurn(role: 'user', text: clean));
      _loading = true;
    });
    _controller.clear();
    _scrollToEnd();
    final history = _turns.sublist(0, _turns.length - 1);
    final reply = await _service.reply(
      history: history,
      userMessage: clean,
      languageCode: lang,
    );
    if (!mounted) return;
    setState(() {
      _turns.add(ChatTurn(role: 'model', text: reply));
      _loading = false;
    });
    _scrollToEnd();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final mq = MediaQuery.of(context);
    final keyboard = mq.viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: keyboard),
      child: FractionallySizedBox(
        heightFactor: 0.82,
        child: Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(
              color: scheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 10),
              _Header(),
              const Divider(height: 1),
              Expanded(
                child: _turns.isEmpty
                    ? _EmptyState(onPick: _send)
                    : ListView.builder(
                        controller: _scroll,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                        itemCount: _turns.length + (_loading ? 1 : 0),
                        itemBuilder: (_, i) {
                          if (i == _turns.length) {
                            return const _TypingBubble();
                          }
                          final t = _turns[i];
                          return _MessageBubble(
                            text: t.text,
                            fromUser: t.role == 'user',
                          );
                        },
                      ),
              ),
              _Composer(
                controller: _controller,
                onSend: _send,
                enabled: !_loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFB39DDB), Color(0xFFF5C9D6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(Icons.favorite_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _title.of(context),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close_rounded, color: scheme.onSurfaceVariant),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onPick});

  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: scheme.primary.withValues(alpha: 0.18),
              ),
            ),
            child: Text(
              _greeting.of(context),
              style: TextStyle(
                color: scheme.onSurface,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _hint.of(context),
            style: TextStyle(
              fontSize: 12,
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestions.map((s) {
              final label = s.of(context);
              return ActionChip(
                label: Text(label),
                onPressed: () => onPick(label),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.text, required this.fromUser});

  final String text;
  final bool fromUser;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = fromUser
        ? scheme.primary
        : scheme.surfaceContainerHighest.withValues(alpha: 0.9);
    final fg = fromUser ? scheme.onPrimary : scheme.onSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            fromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(fromUser ? 16 : 4),
                  bottomRight: Radius.circular(fromUser ? 4 : 16),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(color: fg, fontSize: 14, height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.9),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (context, _) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    final v = ((_ctrl.value + i * 0.2) % 1.0);
                    final scale = 0.6 + 0.6 * (1 - (2 * v - 1).abs());
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: scheme.onSurfaceVariant,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.onSend,
    required this.enabled,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSend;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: enabled,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: onSend,
                decoration: InputDecoration(
                  hintText: _hint.of(context),
                  filled: true,
                  fillColor:
                      scheme.surfaceContainerHighest.withValues(alpha: 0.7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: enabled ? scheme.primary : scheme.surfaceContainerHighest,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: enabled ? () => onSend(controller.text) : null,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    Icons.send_rounded,
                    color: enabled
                        ? scheme.onPrimary
                        : scheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
