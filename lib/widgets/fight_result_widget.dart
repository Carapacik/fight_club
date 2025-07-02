import 'package:fightclub/entities/fight_result.dart';
import 'package:fightclub/resources/app_colors.dart';
import 'package:fightclub/resources/app_images.dart';
import 'package:flutter/material.dart';

class FightResultWidget extends StatelessWidget {
  const FightResultWidget({required this.fightResult, super.key});

  final FightResult fightResult;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 140,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('You', style: TextStyle(color: AppColors.darkGreyText, fontSize: 14)),
                const SizedBox(height: 10),
                Image.asset(AppImages.youAvatar, width: 90, height: 90),
              ],
            ),
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: fightResult.color, borderRadius: BorderRadius.circular(22)),
              child: Center(
                child: Text(
                  fightResult.result.toLowerCase(),
                  style: const TextStyle(color: AppColors.white, fontSize: 16),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Enemy', style: TextStyle(color: AppColors.darkGreyText, fontSize: 14)),
                const SizedBox(height: 10),
                Image.asset(AppImages.enemyAvatar, width: 90, height: 90),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
      ],
    ),
  );
}
