import 'package:fightclub/resources/app_colors.dart';
import 'package:flutter/material.dart';

class SecondaryActionButton extends StatelessWidget {
  const SecondaryActionButton({required this.onTap, required this.text, super.key});

  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(border: Border.all(color: AppColors.darkGreyText, width: 2)),
      child: Text(text.toUpperCase(), style: const TextStyle(fontSize: 13, color: AppColors.darkGreyText)),
    ),
  );
}
