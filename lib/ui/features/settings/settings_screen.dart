import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../data/repositories/app_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../core/widgets/momrise_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.repository});

  final AppRepository repository;

  static String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rnd = Random();
    return List.generate(6, (_) => chars[rnd.nextInt(chars.length)]).join();
  }

  Future<void> _generate(BuildContext context) async {
    final t = AppLocalizations.of(context);
    final code = _generateCode();
    await repository.setPairCode(code);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(t.setCodeGenerated)));
  }

  Future<void> _copy(BuildContext context) async {
    final t = AppLocalizations.of(context);
    if (repository.pairCode.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: repository.pairCode));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(t.setCodeCopied)));
  }

  Future<void> _reset(BuildContext context) async {
    final t = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(t.setResetConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t.commonCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t.commonDelete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await repository.resetAll();
    if (!context.mounted) return;
    context.go('/welcome');
  }

  Future<void> _showExport(BuildContext context) async {
    final t = AppLocalizations.of(context);
    final dump = repository.exportDump();
    final pretty = const JsonEncoder.withIndent('  ').convert(dump);
    await Clipboard.setData(ClipboardData(text: pretty));
    if (!context.mounted) return;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.setExport),
        content: SizedBox(
          width: 320,
          child: SingleChildScrollView(
            child: SelectableText(
              pretty,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.commonClose),
          ),
        ],
      ),
    );
  }

  Future<void> _import(BuildContext context) async {
    final t = AppLocalizations.of(context);
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.setImport),
        content: TextField(
          controller: controller,
          maxLines: 8,
          decoration: const InputDecoration(hintText: '{ ... }'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t.commonCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t.commonSave),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      final decoded = jsonDecode(controller.text);
      if (decoded is Map<String, dynamic>) {
        await repository.importDump(decoded);
      }
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('—')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final profile = repository.profile;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        MomriseCard(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [scheme.primary, scheme.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      (profile?.name.isNotEmpty == true
                              ? profile!.name[0]
                              : '🌸')
                          .toUpperCase(),
                      style: TextStyle(
                        color: scheme.onPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profile?.name ?? 'Anne',
                            style:
                                Theme.of(context).textTheme.titleMedium),
                        Text(
                          profile == null
                              ? '—'
                              : '${profile.birthType.name == 'csection' ? 'Sezaryen' : 'Normal'} · ${profile.babyBirthDate}',
                          style: TextStyle(
                            fontSize: 11,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => context.go('/onboarding'),
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: Text(t.setEditProfile),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        MomriseCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.vpn_key_rounded,
                      color: scheme.primary, size: 16),
                  const SizedBox(width: 8),
                  Text(t.setPairTitle,
                      style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
              const SizedBox(height: 8),
              Text(t.setPairDesc,
                  style: TextStyle(
                    fontSize: 11,
                    color: scheme.onSurfaceVariant,
                  )),
              const SizedBox(height: 12),
              if (repository.pairCode.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: scheme.secondary.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(t.setYourCode,
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 1.2,
                            color: scheme.onSurfaceVariant,
                          )),
                      const SizedBox(height: 4),
                      Text(
                        repository.pairCode,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          letterSpacing: 8,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              if (repository.pairCode.isNotEmpty) const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _generate(context),
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: Text(
                        repository.pairCode.isNotEmpty
                            ? t.setRegen
                            : t.setGenerate,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: repository.pairCode.isEmpty
                          ? null
                          : () => _copy(context),
                      icon: const Icon(Icons.copy_rounded, size: 16),
                      label: Text(t.setCopy),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        MomriseCard(
          child: Column(
            children: [
              _row(context, Icons.translate, t.setLanguage,
                  trailing: _LanguagePicker(repository: repository)),
              Divider(color: scheme.outline.withValues(alpha: 0.4)),
              _row(
                context,
                repository.isDark
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
                t.setTheme,
                trailing: OutlinedButton(
                  onPressed: () => repository.setDark(!repository.isDark),
                  child: Text(repository.isDark ? t.setDark : t.setLight),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        MomriseCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(t.setData.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1.2,
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    )),
              ),
              OutlinedButton.icon(
                onPressed: () => _showExport(context),
                icon: const Icon(Icons.download_rounded, size: 16),
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(t.setExport),
                ),
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  minimumSize: const Size.fromHeight(44),
                ),
              ),
              const SizedBox(height: 6),
              OutlinedButton.icon(
                onPressed: () => _import(context),
                icon: const Icon(Icons.upload_rounded, size: 16),
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(t.setImport),
                ),
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  minimumSize: const Size.fromHeight(44),
                ),
              ),
              const SizedBox(height: 6),
              OutlinedButton.icon(
                onPressed: () async {
                  await repository.setRole(null);
                  if (!context.mounted) return;
                  context.go('/welcome');
                },
                icon: const Icon(Icons.swap_horiz_rounded, size: 16),
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(t.partnerSwitchRole),
                ),
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  minimumSize: const Size.fromHeight(44),
                ),
              ),
              const SizedBox(height: 6),
              OutlinedButton.icon(
                onPressed: () => _reset(context),
                icon: Icon(Icons.delete_outline_rounded,
                    size: 16, color: scheme.error),
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    t.setReset,
                    style: TextStyle(color: scheme.error),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  minimumSize: const Size.fromHeight(44),
                  side: BorderSide(
                    color: scheme.error.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _row(
    BuildContext context,
    IconData icon,
    String title, {
    Widget? trailing,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: scheme.primary, size: 16),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 13))),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}

class _LanguagePicker extends StatelessWidget {
  const _LanguagePicker({required this.repository});

  final AppRepository repository;

  static const _locales = <_Locale>[
    _Locale('tr', 'Türkçe'),
    _Locale('en', 'English'),
    _Locale('hi', 'हिन्दी'),
    _Locale('pt', 'Português'),
    _Locale('es', 'Español'),
    _Locale('id', 'Bahasa Indonesia'),
    _Locale('ur', 'اردو'),
    _Locale('bn', 'বাংলা'),
    _Locale('ar', 'العربية'),
    _Locale('ru', 'Русский'),
    _Locale('de', 'Deutsch'),
    _Locale('fr', 'Français'),
    _Locale('it', 'Italiano'),
    _Locale('ja', '日本語'),
    _Locale('ko', '한국어'),
    _Locale('zh', '简体中文'),
    _Locale('fil', 'Filipino'),
    _Locale('vi', 'Tiếng Việt'),
    _Locale('fa', 'فارسی'),
    _Locale('pl', 'Polski'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final current = repository.language;
    final selected = _locales.firstWhere((l) => l.code == current);

    return InkWell(
      onTap: () => _showPicker(context),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: scheme.primary,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selected.name,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: scheme.onPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down_rounded, size: 16, color: scheme.onPrimary),
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) {
        final scheme = Theme.of(ctx).colorScheme;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          constraints: const BoxConstraints(maxHeight: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: _locales.map((l) {
                    final active = l.code == repository.language;
                    return ListTile(
                      dense: true,
                      selected: active,
                      title: Text(
                        l.name,
                        style: TextStyle(
                          fontWeight: active ? FontWeight.w600 : null,
                          color: active ? scheme.primary : null,
                        ),
                      ),
                      onTap: () {
                        repository.setLanguage(l.code);
                        Navigator.pop(ctx);
                      },
                      trailing: active
                          ? Icon(Icons.check_rounded, size: 18, color: scheme.primary)
                          : null,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Locale {
  const _Locale(this.code, this.name);
  final String code;
  final String name;
}
