import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants.dart';
import '../core/utils.dart';
import '../data/game_model.dart';
import '../data/settings_model.dart';

class GameRepository {
  static const String _gameKey = 'current_game';
  static const String _settingsKey = 'user_settings';

  late Box<GameModel> _gameBox;
  late Box<SettingsModel> _settingsBox;

  // Initialize Hive boxes
  Future<void> initialize() async {
    await Hive.initFlutter();
    
    Hive.registerAdapter(GameModelAdapter());
    Hive.registerAdapter(SettingsModelAdapter());
    
    _gameBox = await Hive.openBox<GameModel>(AppConstants.gameBoxName);
    _settingsBox = await Hive.openBox<SettingsModel>(AppConstants.settingsBoxName);
  }

  // Game Management
  Future<void> saveGame(GameModel game) async {
    await _gameBox.put(_gameKey, game);
  }

  GameModel? getCurrentGame() {
    return _gameBox.get(_gameKey);
  }

  Future<void> deleteGame() async {
    await _gameBox.delete(_gameKey);
  }

  Future<GameModel> createNewGame(bool isTimeMode) async {
    final answerWord = AppUtils.getRandomWord();
    final game = GameModel.newGame(answerWord, isTimeMode);
    await saveGame(game);
    return game;
  }

  // Check if there's a saved game that can be resumed
  bool hasResumableGame() {
    final game = getCurrentGame();
    return game != null && 
           (game.gameStatus == 'playing' || game.gameStatus == 'paused') &&
           !game.isGameFinished;
  }

  // Settings Management
  Future<void> saveSettings(SettingsModel settings) async {
    await _settingsBox.put(_settingsKey, settings);
  }

  SettingsModel getSettings() {
    return _settingsBox.get(_settingsKey) ?? SettingsModel();
  }

  Future<void> updateSettings(SettingsModel settings) async {
    await saveSettings(settings);
  }

  // Update game statistics
  Future<void> updateGameStats(bool won, int attempts) async {
    final settings = getSettings();
    settings.updateGameStats(won, attempts);
    await saveSettings(settings);
  }

  // Close boxes
  Future<void> close() async {
    await _gameBox.close();
    await _settingsBox.close();
  }
} 