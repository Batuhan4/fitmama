import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/user_role.dart';
import '../../../data/repositories/app_repository.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/cloud_sync_service.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../core/widgets/momrise_card.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key, required this.repository});

  final AppRepository repository;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _showPartner = false;
  bool _busy = false;
  final TextEditingController _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  bool get _appleAvailable =>
      !kIsWeb && (Platform.isIOS || Platform.isMacOS);

  Future<void> _signInGoogleAsMom() async {
    setState(() => _busy = true);
    final cred = await AuthService.instance.signInWithGoogle();
    if (cred?.user == null) {
      setState(() => _busy = false);
      return;
    }
    await widget.repository.setRole(UserRole.mom);
    await widget.repository.backfillToCloud();
    if (!mounted) return;
    setState(() => _busy = false);
    context.go(widget.repository.profile == null ? '/onboarding' : '/dashboard');
  }

  Future<void> _signInAppleAsMom() async {
    setState(() => _busy = true);
    final cred = await AuthService.instance.signInWithApple();
    if (cred?.user == null) {
      setState(() => _busy = false);
      return;
    }
    await widget.repository.setRole(UserRole.mom);
    await widget.repository.backfillToCloud();
    if (!mounted) return;
    setState(() => _busy = false);
    context.go(widget.repository.profile == null ? '/onboarding' : '/dashboard');
  }

  Future<void> _enterDemoMode() async {
    setState(() => _busy = true);
    await widget.repository.loadDemoData();
    if (!mounted) return;
    setState(() => _busy = false);
    context.go('/dashboard');
  }

  Future<void> _connectPartner() async {
    final t = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final code = _code.text.trim().toUpperCase();
    if (code.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(t.welcomeBadCode)));
      return;
    }
    setState(() => _busy = true);
    // Partner must also sign in (so Firestore reads work + we know who they are)
    final cred = await AuthService.instance.signInWithGoogle();
    if (cred?.user == null) {
      setState(() => _busy = false);
      return;
    }
    final momUid = await CloudSyncService.instance.resolvePairCode(code);
    if (momUid == null) {
      if (!mounted) return;
      setState(() => _busy = false);
      messenger.showSnackBar(SnackBar(content: Text(t.welcomeBadCode)));
      return;
    }
    await CloudSyncService.instance
        .attachPartner(momUid, cred!.user!.uid);
    await widget.repository.setRole(UserRole.partner);
    await widget.repository.setPairCode(code);
    await widget.repository.setPairedMomUid(momUid);
    if (!mounted) return;
    setState(() => _busy = false);
    messenger.showSnackBar(SnackBar(content: Text(t.welcomeConnected)));
    context.go('/partner');
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              scheme.secondary.withValues(alpha: 0.4),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/branding/momrise_logo_square.png',
                        width: 140,
                        height: 140,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(t.welcomeTitle,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 6),
                    Text(t.welcomeSub,
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: scheme.onSurfaceVariant)),
                    const SizedBox(height: 28),
                    if (_busy)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                            child: CircularProgressIndicator()),
                      ),
                    if (!_busy && !_showPartner) ...[
                      _RoleCard(
                        icon: Icons.favorite_rounded,
                        title: t.welcomeMom,
                        desc: t.welcomeMomDesc,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _GoogleButton(onPressed: _signInGoogleAsMom),
                            if (_appleAvailable) ...[
                              const SizedBox(height: 8),
                              _AppleButton(onPressed: _signInAppleAsMom),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _RoleCard(
                        icon: Icons.people_alt_rounded,
                        title: t.welcomePartner,
                        desc: t.welcomePartnerDesc,
                        child: ElevatedButton(
                          onPressed: () => setState(() => _showPartner = true),
                          child: Text(t.welcomeEnterCode),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: _enterDemoMode,
                        icon: const Icon(Icons.science_outlined, size: 16),
                        label: const Text('Demo modu ile gir'),
                        style: TextButton.styleFrom(
                          foregroundColor: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (!_busy && _showPartner)
                      MomriseCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: scheme.secondary
                                        .withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(Icons.vpn_key_rounded,
                                      color: scheme.primary),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(t.welcomeEnterCode,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                      const SizedBox(height: 4),
                                      Text(t.welcomeEnterCodeDesc,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: scheme.onSurfaceVariant,
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            TextField(
                              controller: _code,
                              textAlign: TextAlign.center,
                              maxLength: 6,
                              textCapitalization:
                                  TextCapitalization.characters,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                letterSpacing: 8,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'A1B2C3',
                                counterText: '',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () =>
                                        setState(() => _showPartner = false),
                                    child: Text(t.commonCancel),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _connectPartner,
                                    child: Text(t.welcomeConnect),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.desc,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String desc;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MomriseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: scheme.secondary.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: scheme.primary, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(desc,
                        style: TextStyle(
                          fontSize: 12,
                          color: scheme.onSurfaceVariant,
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.g_mobiledata_rounded, size: 22),
      label: const Text('Google ile devam et'),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(46),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1F1F1F),
        side: const BorderSide(color: Color(0xFFDADCE0)),
      ),
    );
  }
}

class _AppleButton extends StatelessWidget {
  const _AppleButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.apple, size: 20),
      label: const Text('Apple ile devam et'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(46),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
    );
  }
}
