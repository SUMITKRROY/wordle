import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';
import 'wordle_tile.dart';

class WordleBoard extends StatelessWidget {
  final List<List<String>> grid;
  final int currentRow;
  final int currentCol;
  final List<String> letterEvaluations;

  const WordleBoard({
    super.key,
    required this.grid,
    required this.currentRow,
    required this.currentCol,
    required this.letterEvaluations,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            AppConstants.maxAttempts,
            (row) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                AppConstants.wordLength,
                (col) => WordleTile(
                  letter: grid[row][col],
                  isActive: row == currentRow && col == currentCol,
                  isFilled: row < currentRow || (row == currentRow && col < currentCol),
                  evaluation: _getEvaluation(row, col),
                  delay: Duration(milliseconds: col * 100),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getEvaluation(int row, int col) {
    if (row < letterEvaluations.length) {
      final rowEvaluations = letterEvaluations[row].split(',');
      if (col < rowEvaluations.length) {
        return rowEvaluations[col];
      }
    }
    return '';
  }
} 