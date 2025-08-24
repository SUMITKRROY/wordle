import 'package:hive/hive.dart';

part '../service/settings_model.g.dart';

@HiveType(typeId: 1)
class SettingsModel extends HiveObject {
  @HiveField(0)
  bool isDarkMode;

  @HiveField(1)
  bool isTimeModeEnabled;

  @HiveField(2)
  bool isSoundEnabled;

  @HiveField(3)
  bool isVibrationEnabled;

  @HiveField(4)
  int gamesPlayed;

  @HiveField(5)
  int gamesWon;

  @HiveField(6)
  int bestScore;

  @HiveField(7)
  int averageAttempts;

  SettingsModel({
    this.isDarkMode = false,
    this.isTimeModeEnabled = false,
    this.isSoundEnabled = true,
    this.isVibrationEnabled = true,
    this.gamesPlayed = 0,
    this.gamesWon = 0,
    this.bestScore = 0,
    this.averageAttempts = 0,
  });

  // Get win percentage
  double get winPercentage {
    if (gamesPlayed == 0) return 0.0;
    return (gamesWon / gamesPlayed) * 100;
  }

  // Update game statistics
  void updateGameStats(bool won, int attempts) {
    gamesPlayed++;
    if (won) {
      gamesWon++;
      if (bestScore == 0 || attempts < bestScore) {
        bestScore = attempts;
      }
    }
    
    // Update average attempts
    if (gamesWon > 0) {
      averageAttempts = ((averageAttempts * (gamesWon - 1)) + attempts) ~/ gamesWon;
    }
  }

  // Copy settings
  SettingsModel copyWith({
    bool? isDarkMode,
    bool? isTimeModeEnabled,
    bool? isSoundEnabled,
    bool? isVibrationEnabled,
    int? gamesPlayed,
    int? gamesWon,
    int? bestScore,
    int? averageAttempts,
  }) {
    return SettingsModel(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isTimeModeEnabled: isTimeModeEnabled ?? this.isTimeModeEnabled,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      isVibrationEnabled: isVibrationEnabled ?? this.isVibrationEnabled,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      gamesWon: gamesWon ?? this.gamesWon,
      bestScore: bestScore ?? this.bestScore,
      averageAttempts: averageAttempts ?? this.averageAttempts,
    );
  }
} 