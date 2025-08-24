import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';

class WordleKeyboard extends StatelessWidget {
  final Function(String) onKeyPressed;
  final VoidCallback? onSubmit;
  final Map<String, String> letterEvaluations;
  final bool showSubmitButton;

  const WordleKeyboard({
    super.key,
    required this.onKeyPressed,
    this.onSubmit,
    required this.letterEvaluations,
    this.showSubmitButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // First row: Q W E R T Y U I O P
          _buildKeyboardRow(['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P']),
          
          const SizedBox(height: 8),
          
          // Second row: A S D F G H J K L
          _buildKeyboardRow(['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L']),
          
          const SizedBox(height: 8),
          
          // Third row: Z X C V B N M + ENTER
          _buildKeyboardRow(['Z', 'X', 'C', 'V', 'B', 'N', 'M'], hasEnter: true),
          
          if (showSubmitButton) ...[
            const SizedBox(height: 8),
            
            // Submit Button Row
            _buildSubmitButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildKeyboardRow(List<String> keys, {bool hasEnter = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (hasEnter) Flexible(child: _buildSpecialKey('ENTER')),
        ...keys.map((key) => Flexible(child: _buildLetterKey(key))),
        if (hasEnter) Flexible(child: _buildSpecialKey('BACKSPACE')),
      ],
    );
  }

  Widget _buildLetterKey(String letter) {
    final evaluation = letterEvaluations[letter] ?? '';
    final color = evaluation.isNotEmpty 
        ? Color(AppUtils.getLetterColor(evaluation))
        : const Color(AppColors.keyboardKey);
    final textColor = evaluation.isNotEmpty 
        ? Colors.white 
        : const Color(AppColors.keyboardText);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onKeyPressed(letter),
          borderRadius: BorderRadius.circular(4),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialKey(String key) {
    IconData icon;
    
    switch (key) {
      case 'ENTER':
        icon = Icons.keyboard_return;
        break;
      case 'BACKSPACE':
        icon = Icons.backspace;
        break;
      default:
        icon = Icons.keyboard;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onKeyPressed(key),
          borderRadius: BorderRadius.circular(4),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(AppColors.keyboardKey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 20,
                color: const Color(AppColors.keyboardText),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onSubmit,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(AppColors.correctGreen),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 