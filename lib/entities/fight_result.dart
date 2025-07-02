import 'package:fightclub/resources/app_colors.dart';
import 'package:flutter/material.dart';

enum FightResult {
  won._('Won', AppColors.green),
  lost._('Lost', AppColors.red),
  draw._('Draw', AppColors.blueButton);

  const FightResult._(this.result, this.color);

  final String result;
  final Color color;

  static FightResult getByName(String name) => values.firstWhere((fightResult) => fightResult.result == name);

  static FightResult? calculateResult(int youLives, int enemyLives) {
    if (youLives == 0 && enemyLives == 0) {
      return draw;
    } else if (youLives == 0) {
      return lost;
    } else if (enemyLives == 0) {
      return won;
    } else {
      return null;
    }
  }

  @override
  String toString() => 'FightResult{result : $result}';
}
