import 'package:fightclub/resources/app_colors.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({required this.onTap, required this.color, required this.text, super.key});

  final String text;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      color: color,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.whiteText),
      ),
    ),
  );
}
