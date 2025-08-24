import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';
import '../../data/game_model.dart';
import '../../service/word_validation_service.dart';
import '../../provider/game_cubit.dart';
import '../../provider/game_state.dart';
import '../../provider/game_state.dart';
import 'results_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize game if not already done
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameCubit = context.read<GameCubit>();
      if (gameCubit.state is GameInitial) {
        gameCubit.initializeGame();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameCubit, GameState>(
      listener: (context, state) {
        if (state is GameWon) {
          // Navigate to results screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ResultsScreen(
                game: state.game,
                attempts: state.attempts,
                won: true,
              ),
            ),
          );
        } else if (state is GameLost) {
          // Navigate to results screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ResultsScreen(
                game: state.game,
                attempts: state.game.attemptsMade,
                won: false,
              ),
            ),
          );
        } else if (state is GameTimeUp) {
          // Navigate to results screen for time up
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ResultsScreen(
                game: state.game,
                attempts: state.game.attemptsMade,
                won: false,
                isTimeUp: true,
              ),
            ),
          );
        } else if (state is GameError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (context, state) {
        print('🔄 Building UI with state: ${state.runtimeType}');
        if (state is GameLoaded) {
          print('📊 Current row: ${state.game.currentRow}, evaluations: ${state.game.letterEvaluations}');
        }
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: _buildAppBar(),
          body: _buildBody(state),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Wordle Lite'),
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      elevation: 0,
      actions: [
        // Network status indicator
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wifi,
                size: 16,
                color: Colors.green,
              ),
              const SizedBox(width: 4),
              Text(
                'Online',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: _showInstructionsDialog,
        ),
        // Debug button to show answer (remove in production)
        // IconButton(
        //   icon: const Icon(Icons.bug_report),
        //   onPressed: _showAnswerWord,
        // ),
      ],
    );
  }

  Widget _buildBody(GameState state) {
    if (state is GameLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is GameLoaded) {
      return Column(
        children: [
          // Game Board
          Expanded(
            flex: 1,
            child: _buildGameBoard(state.game),
          ),

          // Keyboard
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
              child: _buildKeyboard(state.game),
            ),

          ),
          // Submit button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (state.game.isCurrentRowComplete && 
                           state.game.gameStatus == 'playing' &&
                           state.game.currentWord.isNotEmpty)
                    ? () => _handleSubmit(state.game)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return const Center(
      child: Text('Something went wrong'),
    );
  }

  Widget _buildGameBoard(GameModel game) {
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
                (col) => _buildTile(game, row, col),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTile(GameModel game, int row, int col) {
    final letter = game.currentGrid[row][col];
    final isActive = row == game.currentRow && col == game.currentCol;
    final isFilled = row < game.currentRow || (row == game.currentRow && col < game.currentCol);
    final evaluation = _getEvaluation(game, row, col);

    Color backgroundColor;
    Color borderColor;
    Color textColor;

    if (evaluation.isNotEmpty) {
      switch (evaluation) {
        case 'correct':
          backgroundColor = const Color(AppColors.correctGreen);
          borderColor = const Color(AppColors.correctGreen);
          textColor = Colors.white;
          break;
        case 'present':
          backgroundColor = const Color(AppColors.presentYellow);
          borderColor = const Color(AppColors.presentYellow);
          textColor = Colors.white;
          break;
        case 'absent':
          backgroundColor = const Color(AppColors.absentGray);
          borderColor = const Color(AppColors.absentGray);
          textColor = Colors.white;
          break;
        default:
          backgroundColor = Colors.transparent;
          borderColor = const Color(AppColors.tileBorder);
          textColor = const Color(AppColors.keyboardText);
      }
    } else {
      backgroundColor = Colors.transparent;
      borderColor = isActive || isFilled 
          ? const Color(AppColors.keyboardText)
          : const Color(AppColors.tileBorder);
      textColor = const Color(AppColors.keyboardText);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(2),
      width: MediaQuery.of(context).size.width * 0.15,
      height: MediaQuery.of(context).size.width * 0.15,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: letter.isNotEmpty 
            ? Text(
                letter.toUpperCase(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              )
            : isActive 
                ? Container(
                    width: 2,
                    height: 20,
                    color: const Color(AppColors.keyboardText),
                  )
                : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildKeyboard(GameModel game) {
    return Column(
      children: [
        // First row: Q W E R T Y U I O P
        _buildKeyboardRow(['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'], game),
        
        const SizedBox(height: 8),
        
        // Second row: A S D F G H J K L
        _buildKeyboardRow(['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'], game),
        
        const SizedBox(height: 8),
        
        // Third row: Z X C V B N M + ENTER + DELETE
        _buildKeyboardRow(['Z', 'X', 'C', 'V', 'B', 'N', 'M'], game, hasSpecialKeys: true),
      ],
    );
  }

  Widget _buildKeyboardRow(List<String> keys, GameModel game, {bool hasSpecialKeys = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (hasSpecialKeys) _buildSpecialKey('ENTER'),
        ...keys.map((key) => _buildLetterKey(key, game)),
        if (hasSpecialKeys) _buildSpecialKey('DELETE'),
      ],
    );
  }

  Widget _buildLetterKey(String letter, GameModel game) {
    final evaluation = _getKeyboardEvaluation(game, letter);
    
    Color backgroundColor;
    Color textColor;

    if (evaluation.isNotEmpty) {
      switch (evaluation) {
        case 'correct':
          backgroundColor = const Color(AppColors.correctGreen);
          textColor = Colors.white;
          break;
        case 'present':
          backgroundColor = const Color(AppColors.presentYellow);
          textColor = Colors.white;
          break;
        case 'absent':
          backgroundColor = const Color(AppColors.absentGray);
          textColor = Colors.white;
          break;
        default:
          backgroundColor = const Color(AppColors.keyboardKey);
          textColor = const Color(AppColors.keyboardText);
      }
    } else {
      backgroundColor = const Color(AppColors.keyboardKey);
      textColor = const Color(AppColors.keyboardText);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.read<GameCubit>().addLetter(letter),
          borderRadius: BorderRadius.circular(4),
          child: Container(
            height: 48,
            width: MediaQuery.of(context).size.width * 0.08,
            decoration: BoxDecoration(
              color: backgroundColor,
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
    VoidCallback? onTap;

    if (key == 'ENTER') {
      icon = Icons.keyboard_return;
      // ENTER key is disabled - only Submit button works
      onTap = null;
    } else {
      icon = Icons.backspace_outlined;
      onTap = () => context.read<GameCubit>().removeLetter();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: Container(
            height: 48,
            width: MediaQuery.of(context).size.width * 0.12,
            decoration: BoxDecoration(
              color: key == 'ENTER' 
                  ? const Color(AppColors.absentGray).withOpacity(0.3)
                  : const Color(AppColors.keyboardKey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 20,
                color: key == 'ENTER' 
                    ? const Color(AppColors.keyboardText).withOpacity(0.5)
                    : const Color(AppColors.keyboardText),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getEvaluation(GameModel game, int row, int col) {
    if (row < game.letterEvaluations.length) {
      final rowEvaluations = game.letterEvaluations[row].split(',');
      if (col < rowEvaluations.length) {
        final evaluation = rowEvaluations[col];
        if (evaluation.isNotEmpty) {
          print('🎨 Row $row, Col $col: $evaluation');
        }
        return evaluation;
      }
    }
    return '';
  }

  String _getKeyboardEvaluation(GameModel game, String letter) {
    final evaluations = <String>[];
    
    for (int row = 0; row < game.letterEvaluations.length; row++) {
      final rowEvaluations = game.letterEvaluations[row].split(',');
      for (int col = 0; col < rowEvaluations.length && col < game.currentGrid[row].length; col++) {
        final gridLetter = game.currentGrid[row][col];
        final evaluation = rowEvaluations[col];
        
        if (gridLetter.toUpperCase() == letter && evaluation.isNotEmpty) {
          evaluations.add(evaluation);
        }
      }
    }
    
    // Return the best evaluation (correct > present > absent)
    if (evaluations.contains('correct')) return 'correct';
    if (evaluations.contains('present')) return 'present';
    if (evaluations.contains('absent')) return 'absent';
    
    return '';
  }

  void _showInstructionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Play'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Guess the word in 6 tries.'),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.square, color: Color(AppColors.correctGreen), size: 24),
                SizedBox(width: 8),
                Text('Green: Letter is in the correct position'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.square, color: Color(AppColors.presentYellow), size: 24),
                SizedBox(width: 8),
                Text('Yellow: Letter is in the word but wrong position'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.square, color: Color(AppColors.absentGray), size: 24),
                SizedBox(width: 8),
                Text('Gray: Letter is not in the word'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit(GameModel game) async {
    final currentWord = game.currentWord;
    
    print('🔍 Submitting word: "$currentWord"');
    
    // Guard against empty words
    if (currentWord.isEmpty || currentWord.length != 5) {
      print('❌ Cannot submit empty or incomplete word: "$currentWord"');
      return;
    }
    
    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Checking word...'),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
    
    // Validate if the word exists using external API
    final isValid = await WordValidationService.isValidWord(currentWord);
    
    print('📋 Validation result for "$currentWord": $isValid');
    
    // Dismiss loading indicator
    ScaffoldMessenger.of(context).clearSnackBars();
    
    if (!isValid) {
      print('❌ Word "$currentWord" is not valid, showing error message');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not a valid word'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    print('✅ Word "$currentWord" is valid, submitting to game');
    // Submit the row through the cubit
    context.read<GameCubit>().submitRow();
    
    // Add a small delay to ensure state is updated, then refresh UI
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      setState(() {});
    }
  }

  void _showAnswerWord() {
    final gameCubit = context.read<GameCubit>();
    if (gameCubit.state is GameLoaded) {
      final answer = (gameCubit.state as GameLoaded).game.answerWord;
      _showWordInfo(answer);
    }
  }

  Future<void> _showWordInfo(String word) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Loading word information...'),
          ],
        ),
      ),
    );

    try {
      final definition = await WordValidationService.getWordDefinition(word);
      
      // Close loading dialog
      Navigator.of(context).pop();
      
      // Show word info dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Word: ${word.toUpperCase()}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (definition != null) ...[
                const Text(
                  'Definition:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(definition),
              ] else ...[
                const Text('No definition available'),
              ],
              const SizedBox(height: 16),
              const Text(
                'This word was validated against an external dictionary API.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();
      
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading word info: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
} 