import 'dart:async';

import 'package:fightclub/resources/app_colors.dart';
import 'package:fightclub/utils.dart';
import 'package:fightclub/widgets/secondary_action_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late final Future<({int draw, int lost, int won})> _future = _getStats();

  Future<({int won, int lost, int draw})> _getStats() async {
    final sp = SharedPreferencesAsync();
    final int? won = await sp.getInt('stats_won');
    final int? lost = await sp.getInt('stats_lost');
    final int? draw = await sp.getInt('stats_draw');
    return (won: won ?? 0, lost: lost ?? 0, draw: draw ?? 0);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 24),
                child: const Text(
                  'Statistics',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, color: AppColors.darkGreyText),
                ),
              ),
              const Expanded(child: SizedBox.shrink()),
              FutureBuilder<({int won, int lost, int draw})>(
                future: _future,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }
                  final ({int draw, int lost, int won}) stats = snapshot.requireData;
                  unawaited(appearReview());
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Won: ${stats.won}', style: const TextStyle(fontSize: 16, color: AppColors.darkGreyText)),
                      const SizedBox(height: 6),
                      Text('Lost: ${stats.lost}', style: const TextStyle(fontSize: 16, color: AppColors.darkGreyText)),
                      const SizedBox(height: 6),
                      Text('Draw: ${stats.draw}', style: const TextStyle(fontSize: 16, color: AppColors.darkGreyText)),
                    ],
                  );
                },
              ),
              const Expanded(child: SizedBox.shrink()),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SecondaryActionButton(onTap: () => Navigator.of(context).pop(), text: 'Back'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
