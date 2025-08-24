import 'package:hive/hive.dart';

part '../service/game_model.g.dart';

@HiveType(typeId: 0)
class GameModel extends HiveObject {
  @HiveField(0)
  String answerWord;

  @HiveField(1)
  List<List<String>> currentGrid;

  @HiveField(2)
  int currentRow;

  @HiveField(3)
  int currentCol;

  @HiveField(4)
  String gameStatus;

  @HiveField(5)
  int timerRemaining;

  @HiveField(6)
  bool isTimeMode;

  @HiveField(7)
  DateTime? lastPlayed;

  @HiveField(8)
  List<String> letterEvaluations;

  GameModel({
    required this.answerWord,
    required this.currentGrid,
    this.currentRow = 0,
    this.currentCol = 0,
    this.gameStatus = 'playing',
    this.timerRemaining = 0,
    this.isTimeMode = false,
    this.lastPlayed,
    this.letterEvaluations = const [],
  });

  // Create a new game
  factory GameModel.newGame(String answerWord, bool isTimeMode) {
    return GameModel(
      answerWord: answerWord,
      currentGrid: List.generate(
        6,
        (row) => List.generate(5, (col) => ''),
      ),
      currentRow: 0,
      currentCol: 0,
      gameStatus: 'playing',
      timerRemaining: isTimeMode ? 120 : 0, // 2 minutes for time mode
      isTimeMode: isTimeMode,
      lastPlayed: DateTime.now(),
      letterEvaluations: [],
    );
  }

  // Check if game is finished
  bool get isGameFinished {
    return gameStatus == 'won' || 
           gameStatus == 'lost' || 
           gameStatus == 'time_up' ||
           currentRow >= 6;
  }

  // Check if current row is complete
  bool get isCurrentRowComplete {
    return currentCol >= 5;
  }

  // Get current word
  String get currentWord {
    if (currentRow < currentGrid.length) {
      return currentGrid[currentRow].join('');
    }
    return '';
  }

  // Get number of attempts made
  int get attemptsMade {
    if (gameStatus == 'won') {
      return currentRow + 1;
    } else if (gameStatus == 'lost' || gameStatus == 'time_up') {
      return 6;
    } else {
      return currentRow;
    }
  }

  // Add letter to current position
  void addLetter(String letter) {
    if (currentRow < currentGrid.length && 
        currentCol < currentGrid[currentRow].length &&
        gameStatus == 'playing') {
      currentGrid[currentRow][currentCol] = letter.toUpperCase();
      currentCol++;
    }
  }

  // Remove letter from current position
  void removeLetter() {
    if (currentCol > 0 && gameStatus == 'playing') {
      currentCol--;
      currentGrid[currentRow][currentCol] = '';
    }
  }

  // Submit current row
  void submitRow() {
    if (isCurrentRowComplete && gameStatus == 'playing') {
      // Check if word is correct
      if (currentWord == answerWord) {
        gameStatus = 'won';
        // Don't increment currentRow for winning row - keep it as the winning row
      } else if (currentRow >= 5) {
        gameStatus = 'lost';
        // Don't increment currentRow for losing row - keep it as the last played row
      } else {
        currentRow++;
        currentCol = 0;
      }
      lastPlayed = DateTime.now();
    }
  }

  // Pause game
  void pauseGame() {
    if (gameStatus == 'playing') {
      gameStatus = 'paused';
      lastPlayed = DateTime.now();
    }
  }

  // Resume game
  void resumeGame() {
    if (gameStatus == 'paused') {
      gameStatus = 'playing';
      lastPlayed = DateTime.now();
    }
  }

  // Update timer
  void updateTimer(int remainingSeconds) {
    timerRemaining = remainingSeconds;
    if (timerRemaining <= 0 && isTimeMode && gameStatus == 'playing') {
      gameStatus = 'time_up';
    }
  }

  // Get letter evaluation for a specific position
  String getLetterEvaluation(int row, int col) {
    if (row < letterEvaluations.length) {
      final rowEvaluations = letterEvaluations[row].split(',');
      if (col < rowEvaluations.length) {
        return rowEvaluations[col];
      }
    }
    return '';
  }

  // Set letter evaluations for a row
  void setRowEvaluations(int row, List<String> evaluations) {
    while (letterEvaluations.length <= row) {
      letterEvaluations.add('');
    }
    letterEvaluations[row] = evaluations.join(',');
  }

  // Copy game state
  GameModel copyWith({
    String? answerWord,
    List<List<String>>? currentGrid,
    int? currentRow,
    int? currentCol,
    String? gameStatus,
    int? timerRemaining,
    bool? isTimeMode,
    DateTime? lastPlayed,
    List<String>? letterEvaluations,
  }) {
    return GameModel(
      answerWord: answerWord ?? this.answerWord,
      currentGrid: currentGrid ?? this.currentGrid,
      currentRow: currentRow ?? this.currentRow,
      currentCol: currentCol ?? this.currentCol,
      gameStatus: gameStatus ?? this.gameStatus,
      timerRemaining: timerRemaining ?? this.timerRemaining,
      isTimeMode: isTimeMode ?? this.isTimeMode,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      letterEvaluations: letterEvaluations ?? this.letterEvaluations,
    );
  }
} 