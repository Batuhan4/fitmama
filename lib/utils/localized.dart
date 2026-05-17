import 'package:flutter/widgets.dart';

/// Pair of strings keyed by locale code; used for content that lives in
/// Dart constants (meal titles, exercise names, etc.) rather than in ARB.
/// Pair of strings keyed by locale code; used for content that lives in
/// Dart constants (meal titles, exercise names, etc.) rather than in ARB.
class L {
  const L(this.tr, this.en, {Map<String, String>? more}) : _more = more;
  final String tr;
  final String en;
  final Map<String, String>? _more;

  String of(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode;
    if (code == 'en') return en;
    if (code == 'tr') return tr;
    return _more?[code] ?? en;
  }
}
