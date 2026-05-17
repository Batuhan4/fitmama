import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/fitmama_card.dart';
import '../../core/widgets/section_header.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.initialQuery = ''});

  final String initialQuery;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _ctrl;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialQuery);
    _query = widget.initialQuery;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final filtered = _entries
        .where((e) => _query.isEmpty ||
            e.label.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _ctrl,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Tarif, program, blog ara…',
            fillColor: Colors.transparent,
            filled: true,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          style: TextStyle(color: scheme.onSurface),
          onChanged: (v) => setState(() => _query = v),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () {
                _ctrl.clear();
                setState(() => _query = '');
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          if (_query.isEmpty) ...[
            SectionHeader(
                title: 'Popüler aramalar',
                upper: true,
                padding: EdgeInsets.zero),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in const [
                  'Core Recovery',
                  'Pelvik taban',
                  'HIIT',
                  'Yulaflı pankek',
                  'Glute builder',
                  'Postpartum',
                ])
                  _SuggestChip(
                      label: s,
                      onTap: () {
                        _ctrl.text = s;
                        setState(() => _query = s);
                      }),
              ],
            ),
            const SizedBox(height: 24),
            SectionHeader(
                title: 'Trend programlar',
                upper: true,
                padding: EdgeInsets.zero),
            const SizedBox(height: 8),
            for (final e in _entries.take(4))
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _ResultRow(entry: e),
              ),
          ] else if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text('"$_query" için sonuç yok.',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            )
          else
            for (final e in filtered)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _ResultRow(entry: e),
              ),
        ],
      ),
    );
  }
}

class _SuggestChip extends StatelessWidget {
  const _SuggestChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppPalette.darkSurfaceRaised
              : AppPalette.lightSurfaceRaised,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 13)),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.entry});
  final _SearchEntry entry;

  @override
  Widget build(BuildContext context) {
    return FitmamaCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      onTap: () => GoRouter.of(context).push(entry.route),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: entry.color.withValues(alpha: 0.15),
            ),
            child: Icon(entry.icon, color: entry.color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                Text(entry.kind,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_rounded,
              size: 18,
              color: Theme.of(context).colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}

class _SearchEntry {
  const _SearchEntry(
      this.label, this.kind, this.icon, this.color, this.route);
  final String label;
  final String kind;
  final IconData icon;
  final Color color;
  final String route;
}

const _entries = <_SearchEntry>[
  _SearchEntry('Core Recovery', 'Program',
      Icons.self_improvement_rounded, AppPalette.primary,
      '/programs/core-recovery?title=Core%20Recovery'),
  _SearchEntry('Kalça Geliştirme', 'Program',
      Icons.directions_run_rounded, AppPalette.primary,
      '/programs/kalca-gelistirme?title=Kal%C3%A7a%20Geli%C5%9Ftirme'),
  _SearchEntry('Bel İnceltme', 'Program',
      Icons.accessibility_new_rounded, AppPalette.accentPurple,
      '/programs/bel-inceltme?title=Bel%20%C4%B0nceltme'),
  _SearchEntry('Yulaflı Muz Pankek', 'Tarif',
      Icons.cake_rounded, AppPalette.accentOrange,
      '/nutrition/recipe?title=Yulafl%C4%B1%20Muz%20Pankek'),
  _SearchEntry('Tavuklu Pesto Makarna', 'Tarif',
      Icons.ramen_dining_rounded, AppPalette.accentOrange,
      '/nutrition/recipe?title=Tavuklu%20Pesto%20Makarna'),
  _SearchEntry('Pelvik Taban Reset', 'Program',
      Icons.spa_rounded, AppPalette.accentPurple,
      '/programs/pelvik-taban?title=Pelvik%20Taban%20Reset'),
  _SearchEntry('Postpartum pelvik sağlık', 'Blog yazısı',
      Icons.article_rounded, AppPalette.accentBlue,
      '/nutrition/blog/pelvik-taban'),
  _SearchEntry('Emzirme ve beslenme', 'Blog yazısı',
      Icons.article_rounded, AppPalette.accentBlue,
      '/nutrition/blog/emzirme-ve-beslenme'),
  _SearchEntry('21 Gün Core Recovery', 'Challenge',
      Icons.emoji_events_rounded, AppPalette.accentYellow,
      '/challenges'),
];
