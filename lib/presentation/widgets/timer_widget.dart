import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';

class TimerWidget extends StatelessWidget {
  final int remainingSeconds;
  final bool isPaused;

  const TimerWidget({
    super.key,
    required this.remainingSeconds,
    required this.isPaused,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    final isLowTime = remainingSeconds <= 30;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _getTimerColor(isLowTime),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getTimerColor(isLowTime).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPaused ? Icons.pause : Icons.timer,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (isPaused) ...[
            const SizedBox(width: 8),
            const Text(
              'PAUSED',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getTimerColor(bool isLowTime) {
    if (isLowTime) {
      return Colors.red;
    } else if (remainingSeconds <= 60) {
      return Colors.orange;
    } else {
      return Colors.blue;
    }
  }
} 