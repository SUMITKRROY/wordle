import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';
import '../../data/game_model.dart';
import 'home_screen.dart';

class ResultsScreen extends StatelessWidget {
  final GameModel game;
  final int attempts;
  final bool won;
  final bool isTimeUp;

  const ResultsScreen({
    super.key,
    required this.game,
    required this.attempts,
    required this.won,
    this.isTimeUp = false,
  });

  @override
  Widget build(BuildContext context) {
    // Debug: Print game state
    print('🎮 Results Screen - Game state:');
    print('   Answer: ${game.answerWord}');
    print('   Won: $won');
    print('   Attempts: $attempts');
    print('   Letter evaluations: ${game.letterEvaluations}');
    print('   Current grid: ${game.currentGrid}');
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Game Results'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Result Header
                      _buildResultHeader(context),
                      
                      const SizedBox(height: 24),
                      
                      // Game Grid
                      _buildGameGrid(),
                      
                      const SizedBox(height: 24),
                      
                      // Statistics
                      _buildStatistics(context),
                      
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              
              // Action Buttons (fixed at bottom)
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultHeader(BuildContext context) {
    IconData icon;
    String title;
    String subtitle;
    Color color;

    if (won) {
      icon = Icons.celebration;
      title = AppText.congratulations;
      subtitle = 'You solved it in $attempts ${attempts == 1 ? 'try' : 'tries'}!';
      color = const Color(AppColors.correctGreen);
    } else if (isTimeUp) {
      icon = Icons.timer_off;
      title = AppText.timeUp;
      subtitle = 'Time ran out!';
      color = const Color(AppColors.absentGray);
    } else {
      icon = Icons.close;
      title = AppText.gameOver;
      subtitle = 'The word was ${game.answerWord}';
      color = const Color(AppColors.absentGray);
    }

    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(
            icon,
            size: 30,
            color: color,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGameGrid() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: List.generate(
          game.currentGrid.length,
          (row) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              game.currentGrid[row].length,
              (col) => Container(
                width: 35,
                height: 35,
                margin: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  color: _getTileColor(row, col),
                  border: Border.all(
                    color: const Color(AppColors.tileBorder),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Center(
                  child: Text(
                    game.currentGrid[row][col],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _getTileColor(row, col) == Colors.transparent 
                          ? Colors.black 
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getTileColor(int row, int col) {
    // Only show evaluations for rows that have been played
    if (row < game.letterEvaluations.length && game.letterEvaluations[row].isNotEmpty) {
      final rowEvaluations = game.letterEvaluations[row].split(',');
      if (col < rowEvaluations.length && rowEvaluations[col].isNotEmpty) {
        final evaluation = rowEvaluations[col];
        print('🎨 Tile ($row, $col): $evaluation');
        switch (evaluation) {
          case 'correct':
            return const Color(AppColors.correctGreen);
          case 'present':
            return const Color(AppColors.presentYellow);
          case 'absent':
            return const Color(AppColors.absentGray);
        }
      }
    }
    // Return transparent for empty/unplayed tiles
    return Colors.transparent;
  }

  Widget _buildStatistics(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Game Statistics',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Mode', game.isTimeMode ? 'Time' : 'Classic'),
              _buildStatItem('Attempts', attempts.toString()),
              _buildStatItem('Result', won ? 'Won' : 'Lost'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Share Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _shareResults(),
            icon: const Icon(Icons.share),
            label: const Text('Share Results'),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // New Game Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _startNewGame(context),
            child: const Text('New Game'),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Home Button
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () => _goHome(context),
            child: const Text('Back to Home'),
          ),
        ),
      ],
    );
  }

  void _shareResults() {
    final message = AppUtils.formatShareMessage(attempts, won);
    Share.share(message, subject: 'Wordle Lite Results');
  }

  void _startNewGame(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  void _goHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
    );
  }
} 