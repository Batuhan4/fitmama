import 'package:flutter/material.dart';

import '../../../data/repositories/app_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../milestones/baby_milestones_screen.dart';
import '../milestones/kegel_screen.dart';
import '../videos/videos_screen.dart';
import 'exercise_screen.dart';

class ExerciseHubScreen extends StatefulWidget {
  const ExerciseHubScreen({super.key, required this.repository});

  final AppRepository repository;

  @override
  State<ExerciseHubScreen> createState() => _ExerciseHubScreenState();
}

class _ExerciseHubScreenState extends State<ExerciseHubScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: TabBar(
            controller: _tab,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: t.exTitle),
              Tab(text: t.vidTitle),
              Tab(text: t.milestoneTitle),
              Tab(text: t.kegelTitle),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              ExerciseScreen(repository: widget.repository),
              VideosScreen(repository: widget.repository),
              BabyMilestonesScreen(repository: widget.repository),
              const KegelScreen(),
            ],
          ),
        ),
      ],
    );
  }
}
