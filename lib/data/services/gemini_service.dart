import 'dart:convert';

import 'package:http/http.dart' as http;

/// API key for Gemini 2.5 Flash Lite. Get one from https://aistudio.google.com/
/// and replace the placeholder. The chatbot bubble silently disables itself
/// if this is left empty, so the rest of the app keeps working.
const String kGeminiApiKey = String.fromEnvironment('GEMINI_API_KEY',
    defaultValue: 'AIzaSyBcUSdAVM7_loRQeEhtRVwZcpFCxUxUl2s');

const String _model = 'gemma-4-26b-a4b-it';
const String _endpoint =
    'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent';

class ChatTurn {
  ChatTurn({required this.role, required this.text});
  final String role;
  final String text;
}

class GeminiService {
  GeminiService({String? apiKey}) : _apiKey = apiKey ?? kGeminiApiKey;

  final String _apiKey;

  bool get isConfigured => _apiKey.isNotEmpty;

  Future<String> reply({
    required List<ChatTurn> history,
    required String userMessage,
    required String languageCode,
  }) async {
    if (!isConfigured) {
      return _fallback(languageCode);
    }

    final uri = Uri.parse('$_endpoint?key=$_apiKey');
    final contents = <Map<String, dynamic>>[
      for (final t in history)
        {
          'role': t.role,
          'parts': [
            {'text': t.text}
          ],
        },
      {
        'role': 'user',
        'parts': [
          {'text': userMessage}
        ],
      },
    ];

    final body = {
      'system_instruction': {
        'parts': [
          {'text': _systemPrompt(languageCode)}
        ]
      },
      'contents': contents,
      'generationConfig': {
        'temperature': 0.8,
        'topP': 0.95,
        'maxOutputTokens': 1024,
      },
      'safetySettings': const [
        {
          'category': 'HARM_CATEGORY_HARASSMENT',
          'threshold': 'BLOCK_ONLY_HIGH'
        },
        {
          'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
          'threshold': 'BLOCK_ONLY_HIGH'
        },
      ],
    };

    try {
      final res = await http
          .post(uri,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(body))
          .timeout(const Duration(seconds: 20));
      if (res.statusCode == 429) {
        return _quotaFallback(languageCode);
      }
      if (res.statusCode != 200) {
        return _errorFallback(languageCode);
      }
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final candidates = data['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) {
        return _errorFallback(languageCode);
      }
      final content = candidates.first['content'] as Map<String, dynamic>?;
      final parts = content?['parts'] as List?;
      if (parts == null || parts.isEmpty) return _errorFallback(languageCode);
      // Gemma models stream thinking traces as parts with `thought: true`;
      // join only the real response parts.
      final text = parts
          .where((p) => p is Map && p['thought'] != true)
          .map((p) => (p as Map)['text'] as String? ?? '')
          .join()
          .trim();
      return text.isEmpty ? _errorFallback(languageCode) : text;
    } catch (_) {
      return _errorFallback(languageCode);
    }
  }

  String _quotaFallback(String lang) {
    if (lang == 'tr') {
      return 'Günlük sohbet kotası doldu 💜 Birazdan tekrar dene ya da Gemini API key planını yükselt.';
    }
    return 'Daily chat quota reached 💜 Try again later or upgrade the Gemini API key plan.';
  }

  String _systemPrompt(String lang) {
    switch (lang) {
      case 'tr':
        return '''Sen "Momi", postpartum dönemdeki annelere duygusal destek veren sıcak, empatik bir Türkçe arkadaşsın.
- Doktor değilsin: tıbbi/teşhis sorularında nazikçe sağlık profesyoneline yönlendir.
- Cevapların 2-4 cümle, samimi, yargısız ve şefkatli olsun.
- Anne kendini kötü hissediyorsa önce duygusunu doğrula, sonra küçük bir öneri sun (nefes, su, kısa yürüyüş, biriyle konuşmak).
- Gerçekten ciddi durumlarda (intihar düşüncesi, kendine/bebeğe zarar) hemen profesyonel yardım al diye yönlendir.
- Emoji kullanabilirsin ama abartma. Sade ve hafif tut.''';
      case 'en':
      default:
        return '''You are "Momi", a warm, empathetic friend offering emotional support to mothers in the postpartum period.
- You are not a doctor: for medical/diagnostic questions, gently redirect to a health professional.
- Replies should be 2-4 sentences, sincere, non-judgmental and compassionate.
- If the mom feels low, first validate the feeling, then offer one small suggestion (breathing, water, short walk, talking to someone).
- For serious crises (suicidal thoughts, self/baby harm) direct them to seek immediate professional help.
- You may use emojis sparingly. Keep it light and kind.''';
    }
  }

  String _fallback(String lang) {
    if (lang == 'tr') {
      return 'Sohbet özelliği henüz kurulmamış. Ayarlardan Gemini API anahtarını ekleyince burada konuşabiliriz. 💜';
    }
    return 'Chat is not configured yet. Add a Gemini API key in settings and we can talk here. 💜';
  }

  String _errorFallback(String lang) {
    if (lang == 'tr') {
      return 'Şu an cevap veremiyorum 💜 Birazdan tekrar dener misin?';
    }
    return "I can't respond right now 💜 Could you try again in a moment?";
  }
}
