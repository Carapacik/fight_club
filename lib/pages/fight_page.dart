import 'dart:async';

import 'package:fightclub/entities/body_part.dart';
import 'package:fightclub/entities/fight_result.dart';
import 'package:fightclub/resources/app_colors.dart';
import 'package:fightclub/resources/app_images.dart';
import 'package:fightclub/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FightPage extends StatefulWidget {
  const FightPage({super.key});

  @override
  FightPageState createState() => FightPageState();
}

class FightPageState extends State<FightPage> {
  static const int _maxLives = 5;
  BodyPart? _defendingBodyPart;
  BodyPart? _attackingBodyPart;
  BodyPart _whatEnemyDefends = BodyPart.random;
  BodyPart _whatEnemyAttacks = BodyPart.random;
  int _youLives = _maxLives;
  int _enemyLives = _maxLives;
  String _centerText = '';

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              _FightersInfo(maxLivesCount: _maxLives, youLivesCount: _youLives, enemyLivesCount: _enemyLives),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                  child: ColoredBox(
                    color: AppColors.darkPurple,
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          _centerText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 10, color: AppColors.darkGreyText),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _ControlsWidget(
                defendingBodyPart: _defendingBodyPart,
                selectDefendingBodyPart: _selectDefendingBodyPart,
                attackingBodyPart: _attackingBodyPart,
                selectAttackingBodyPart: _selectAttackingBodyPart,
              ),
              const SizedBox(height: 14),
              ActionButton(
                text: _isLivesCountZero() ? 'Back' : 'Go',
                onTap: _onGoButtonClicked,
                color: _getGoButtonColor(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    ),
  );

  Color _getGoButtonColor() {
    if (_isLivesCountZero()) {
      return AppColors.blackButton;
    } else if (!_isAllBodyPartsSelected()) {
      return AppColors.greyButton;
    } else {
      return AppColors.blackButton;
    }
  }

  bool _isAllBodyPartsSelected() => _defendingBodyPart != null && _attackingBodyPart != null;

  bool _isLivesCountZero() => _youLives == 0 || _enemyLives == 0;

  Future<void> _onGoButtonClicked() async {
    if (_isLivesCountZero()) {
      Navigator.of(context).pop();
    } else if (_isAllBodyPartsSelected()) {
      setState(() {
        final enemyLoseLife = _attackingBodyPart != _whatEnemyDefends;
        final youLoseLife = _defendingBodyPart != _whatEnemyAttacks;

        if (enemyLoseLife) {
          _enemyLives--;
        }
        if (youLoseLife) {
          _youLives--;
        }

        final FightResult? fightResult = FightResult.calculateResult(_youLives, _enemyLives);
        if (fightResult != null) {
          unawaited(_saveFightResult(fightResult));
        }
        _centerText = _calculateCenterText(youLoseLife, enemyLoseLife);

        _whatEnemyDefends = BodyPart.random;
        _whatEnemyAttacks = BodyPart.random;

        _defendingBodyPart = null;
        _attackingBodyPart = null;
      });
    }
  }

  Future<void> _saveFightResult(FightResult fightResult) async {
    final sp = SharedPreferencesAsync();
    await sp.setString('last_fight_result', fightResult.result);
    final key = 'stats_${fightResult.result.toLowerCase()}';
    final int? currentValue = await sp.getInt(key);
    await sp.setInt(key, (currentValue ?? 0) + 1);
  }

  String _calculateCenterText(final bool youLoseLife, final bool enemyLoseLife) {
    if (_youLives == 0 && _enemyLives == 0) {
      return 'Draw';
    } else if (_enemyLives == 0) {
      return 'You won';
    } else if (_youLives == 0) {
      return 'You lost';
    } else {
      final first = enemyLoseLife
          ? "You hit enemy's ${_attackingBodyPart!.name.toLowerCase()}."
          : 'Your attack was blocked.';
      final second = youLoseLife
          ? 'Enemy hit your ${_whatEnemyAttacks.name.toLowerCase()}.'
          : "Enemy's attack was blocked.";

      return '$first\n$second';
    }
  }

  void _selectDefendingBodyPart(final BodyPart value) {
    if (_isLivesCountZero()) {
      return;
    }
    setState(() {
      _defendingBodyPart = value;
    });
  }

  void _selectAttackingBodyPart(final BodyPart value) {
    if (_isLivesCountZero()) {
      return;
    }
    setState(() {
      _attackingBodyPart = value;
    });
  }
}

class _ControlsWidget extends StatelessWidget {
  const _ControlsWidget({
    required this.defendingBodyPart,
    required this.selectDefendingBodyPart,
    required this.attackingBodyPart,
    required this.selectAttackingBodyPart,
  });

  final BodyPart? defendingBodyPart;
  final ValueSetter<BodyPart> selectDefendingBodyPart;
  final BodyPart? attackingBodyPart;
  final ValueSetter<BodyPart> selectAttackingBodyPart;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          children: [
            Text('Defend'.toUpperCase(), style: const TextStyle(color: AppColors.darkGreyText)),
            const SizedBox(height: 13),
            _BodyPartButton(
              bodyPart: BodyPart.head,
              selected: defendingBodyPart == BodyPart.head,
              bodyPartSetter: selectDefendingBodyPart,
            ),
            const SizedBox(height: 14),
            _BodyPartButton(
              bodyPart: BodyPart.torso,
              selected: defendingBodyPart == BodyPart.torso,
              bodyPartSetter: selectDefendingBodyPart,
            ),
            const SizedBox(height: 14),
            _BodyPartButton(
              bodyPart: BodyPart.legs,
              selected: defendingBodyPart == BodyPart.legs,
              bodyPartSetter: selectDefendingBodyPart,
            ),
          ],
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          children: [
            Text('Attack'.toUpperCase(), style: const TextStyle(color: AppColors.darkGreyText)),
            const SizedBox(height: 13),
            _BodyPartButton(
              bodyPart: BodyPart.head,
              selected: attackingBodyPart == BodyPart.head,
              bodyPartSetter: selectAttackingBodyPart,
            ),
            const SizedBox(height: 14),
            _BodyPartButton(
              bodyPart: BodyPart.torso,
              selected: attackingBodyPart == BodyPart.torso,
              bodyPartSetter: selectAttackingBodyPart,
            ),
            const SizedBox(height: 14),
            _BodyPartButton(
              bodyPart: BodyPart.legs,
              selected: attackingBodyPart == BodyPart.legs,
              bodyPartSetter: selectAttackingBodyPart,
            ),
          ],
        ),
      ),
      const SizedBox(width: 16),
    ],
  );
}

class _FightersInfo extends StatelessWidget {
  const _FightersInfo({required this.maxLivesCount, required this.youLivesCount, required this.enemyLivesCount});

  final int maxLivesCount;
  final int youLivesCount;
  final int enemyLivesCount;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 160,
    child: Stack(
      children: [
        const Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: ColoredBox(color: AppColors.white)),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.white, AppColors.darkPurple])),
              ),
            ),
            Expanded(child: ColoredBox(color: AppColors.darkPurple)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _LivesWidget(overallLivesCount: maxLivesCount, currentLivesCount: youLivesCount),
            Column(
              children: [
                const SizedBox(height: 16),
                const Text('You', style: TextStyle(color: AppColors.darkGreyText)),
                const SizedBox(height: 12),
                Image.asset(AppImages.youAvatar, width: 90, height: 90),
              ],
            ),
            const SizedBox(
              height: 44,
              width: 44,
              child: DecoratedBox(
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.blueButton),
                child: Center(
                  child: Text('vs', style: TextStyle(color: AppColors.whiteText, fontSize: 16)),
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 16),
                const Text('Enemy', style: TextStyle(color: AppColors.darkGreyText)),
                const SizedBox(height: 12),
                Image.asset(AppImages.enemyAvatar, width: 90, height: 90),
              ],
            ),
            _LivesWidget(overallLivesCount: maxLivesCount, currentLivesCount: enemyLivesCount),
          ],
        ),
      ],
    ),
  );
}

class _LivesWidget extends StatelessWidget {
  const _LivesWidget({required this.overallLivesCount, required this.currentLivesCount})
    : assert(overallLivesCount >= 1, 'overallLivesCount must be more than 1'),
      assert(currentLivesCount >= 0, 'currentLivesCount must be more than 1'),
      assert(currentLivesCount <= overallLivesCount, 'overallLivesCount must be more than currentLivesCount');

  final int overallLivesCount;
  final int currentLivesCount;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(overallLivesCount, (index) {
      if (index < currentLivesCount) {
        return [
          Image.asset(AppImages.heartFull, width: 18, height: 18),
          if (overallLivesCount - 1 > index) const SizedBox(height: 4),
        ];
      } else {
        return [
          Image.asset(AppImages.heartEmpty, width: 18, height: 18),
          if (overallLivesCount - 1 > index) const SizedBox(height: 4),
        ];
      }
    }).expand((element) => element).toList(),
  );
}

class _BodyPartButton extends StatelessWidget {
  const _BodyPartButton({required this.bodyPart, required this.selected, required this.bodyPartSetter});

  final BodyPart bodyPart;
  final bool selected;
  final ValueSetter<BodyPart> bodyPartSetter;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => bodyPartSetter(bodyPart),
    child: SizedBox(
      height: 40,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? AppColors.blueButton : Colors.transparent,
          border: !selected ? Border.all(color: AppColors.darkGreyText, width: 2) : null,
        ),
        child: Center(
          child: Text(
            bodyPart.name.toUpperCase(),
            style: TextStyle(fontSize: 13, color: selected ? AppColors.whiteText : AppColors.darkGreyText),
          ),
        ),
      ),
    ),
  );
}
