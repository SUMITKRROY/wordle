import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';

class WordleTile extends StatelessWidget {
  final String letter;
  final bool isActive;
  final bool isFilled;
  final String evaluation;
  final Duration delay;

  const WordleTile({
    super.key,
    required this.letter,
    required this.isActive,
    required this.isFilled,
    required this.evaluation,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: _getTileColor(),
        border: Border.all(
          color: _getBorderColor(),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: isActive && letter.isEmpty
            ? Container(
                width: 2,
                height: 20,
                color: const Color(AppColors.tileBorder),
              ).animate(onPlay: (controller) => controller.repeat())
                .fadeIn(duration: 500.ms)
                .then()
                .fadeOut(duration: 500.ms)
            : Text(
                letter.toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _getTextColor(),
                ),
              ),
      ),
    )
        .animate()
        .scale(
          duration: AppConstants.tileFlipDuration,
          curve: Curves.easeInOut,
          delay: delay,
        )
        .then()
        .flipV(
          duration: AppConstants.tileFlipDuration,
          curve: Curves.easeInOut,
        );
  }

  Color _getTileColor() {
    if (evaluation.isNotEmpty) {
      return Color(AppUtils.getLetterColor(evaluation));
    }
    if (isFilled) {
      return Colors.transparent;
    }
    return Colors.transparent;
  }

  Color _getBorderColor() {
    if (evaluation.isNotEmpty) {
      return Color(AppUtils.getLetterColor(evaluation));
    }
    if (isActive) {
      return const Color(AppColors.tileBorder);
    }
    if (letter.isNotEmpty) {
      return const Color(AppColors.tileBorder);
    }
    return const Color(AppColors.tileBorder).withValues(alpha: 0.5);
  }

  Color _getTextColor() {
    if (evaluation.isNotEmpty) {
      return Colors.white;
    }
    return Colors.black;
  }
} 