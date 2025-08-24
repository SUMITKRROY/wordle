class AppConstants {
  // App Version
  static const String version = '1.0.0';
  
  // Game Configuration
  static const int wordLength = 5;
  static const int maxAttempts = 6;
  static const int timeRestrictedModeDuration = 120; // 2 minutes in seconds
  
  // Animation Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration tileFlipDuration = Duration(milliseconds: 500);
  static const Duration keyboardPressDuration = Duration(milliseconds: 100);
  
  // Hive Box Names
  static const String gameBoxName = 'game_box';
  static const String settingsBoxName = 'settings_box';
  
  // Game Status
  static const String gameStatusPlaying = 'playing';
  static const String gameStatusPaused = 'paused';
  static const String gameStatusWon = 'won';
  static const String gameStatusLost = 'lost';
  static const String gameStatusTimeUp = 'time_up';
}

class AppColors {
  // Light Theme Colors
  static const int lightBackground = 0xFFFFFFFF;
  static const int lightSurface = 0xFFF8F9FA;
  static const int lightPrimary = 0xFF1A73E8;
  static const int lightOnPrimary = 0xFFFFFFFF;
  static const int lightOnSurface = 0xFF202124;
  static const int lightOnSurfaceVariant = 0xFF5F6368;
  
  // Dark Theme Colors
  static const int darkBackground = 0xFF202124;
  static const int darkSurface = 0xFF303134;
  static const int darkPrimary = 0xFF8AB4F8;
  static const int darkOnPrimary = 0xFF202124;
  static const int darkOnSurface = 0xFFE8EAED;
  static const int darkOnSurfaceVariant = 0xFF9AA0A6;
  
  // Wordle Colors
  static const int correctGreen = 0xFF6AAA64;
  static const int presentYellow = 0xFFC9B458;
  static const int absentGray = 0xFF787C7E;
  static const int tileBorder = 0xFFD3D6DA;
  static const int keyboardKey = 0xFFD3D6DA;
  static const int keyboardText = 0xFF1A1A1B;
}

class AppText {
  static const String appName = 'Lite Wordle';
  static const String shareMessage = 'Wordle Lite – Solved in {attempts} tries 🎉';
  static const String shareMessageLost = 'Wordle Lite – Failed to solve 😔';
  static const String gameOver = 'Game Over!';
  static const String timeUp = 'Time\'s Up!';
  static const String congratulations = 'Congratulations!';
  static const String newGame = 'New Game';
  static const String pause = 'Pause';
  static const String resume = 'Resume';
  static const String settings = 'Settings';
  static const String timeMode = 'Time Mode';
  static const String classicMode = 'Classic Mode';
} 