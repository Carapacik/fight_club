import 'dart:async';

import 'package:fightclub/entities/fight_result.dart';
import 'package:fightclub/pages/fight_page.dart';
import 'package:fightclub/pages/statistics_page.dart';
import 'package:fightclub/resources/app_colors.dart';
import 'package:fightclub/widgets/action_button.dart';
import 'package:fightclub/widgets/fight_result_widget.dart';
import 'package:fightclub/widgets/secondary_action_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) => _MainPageContent();
}

class _MainPageContent extends StatefulWidget {
  @override
  __MainPageContentState createState() => __MainPageContentState();
}

class __MainPageContentState extends State<_MainPageContent> {
  late final _future = _getLastResult();

  Future<String?> _getLastResult() async {
    final sp = SharedPreferencesAsync();
    final r = await sp.getString('last_fight_result');

    return r;
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
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'The\nfight\nclub'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 30, color: AppColors.darkGreyText),
                ),
              ),
              const Spacer(),
              FutureBuilder<String?>(
                future: _future,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }
                  final result = snapshot.requireData;
                  if (result == null) {
                    return const SizedBox.shrink();
                  }
                  final fightResult = FightResult.getByName(result);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Last fight result',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.darkGreyText, fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      FightResultWidget(fightResult: fightResult),
                    ],
                  );
                },
              ),
              const Spacer(),
              SecondaryActionButton(
                text: 'Statistics',
                onTap: () {
                  unawaited(
                    Navigator.of(context).push<void>(MaterialPageRoute(builder: (context) => const StatisticsPage())),
                  );
                },
              ),
              const SizedBox(height: 16),
              ActionButton(
                onTap: () {
                  unawaited(
                    Navigator.of(context)
                        .push<void>(MaterialPageRoute(builder: (context) => const FightPage()))
                        .then((value) => setState(() {})),
                  );
                },
                color: AppColors.blackButton,
                text: 'Start',
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    ),
  );
}
