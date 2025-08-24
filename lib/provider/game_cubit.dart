import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/constants.dart';
import '../core/utils.dart';
import '../service/game_repository.dart';
import 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  final GameRepository _repository;
  Timer? _timer;

  GameCubit(this._repository) : super(GameInitial());

  // Initialize game
  Future<void> initializeGame() async {
    emit(GameLoading());
    
    try {
      if (_repository.hasResumableGame()) {
        final game = _repository.getCurrentGame()!;
        emit(GameLoaded(game: game));
        
        if (game.isTimeMode && game.gameStatus == 'playing') {
          _startTimer(game.timerRemaining);
        }
      } else {
        final settings = _repository.getSettings();
        final game = await _repository.createNewGame(settings.isTimeModeEnabled);
        emit(GameLoaded(game: game));
        
        if (game.isTimeMode) {
          _startTimer(game.timerRemaining);
        }
      }
    } catch (e) {
      emit(GameError('Failed to initialize game: $e'));
    }
  }

  void addLetter(String letter) {
    if (state is GameLoaded) {
      final game = (state as GameLoaded).game;

      if (game.currentCol < AppConstants.wordLength) {
        game.currentGrid[game.currentRow][game.currentCol] = letter;
        game.currentCol++;
        emit(GameLoaded(game: game.copyWith())); // emit updated state
      }
    }
  }

  void removeLetter() {
    if (state is GameLoaded) {
      final game = (state as GameLoaded).game;

      if (game.currentCol > 0) {
        game.currentCol--;
        game.currentGrid[game.currentRow][game.currentCol] = '';
        emit(GameLoaded(game: game.copyWith())); // emit updated state
      }
    }
  }




  // Submit current row
  void submitRow() {
    if (state is GameLoaded) {
      final currentState = state as GameLoaded;
      final game = currentState.game;

      if (game.gameStatus == 'playing' && game.isCurrentRowComplete) {
        final currentWord = game.currentWord;
        print('🎯 Submitting row: "$currentWord" vs answer: "${game.answerWord}"');

        // Evaluate letters
        final evaluations = <String>[];
        for (int i = 0; i < currentWord.length; i++) {
          final evaluation = AppUtils.getLetterEvaluation(
            currentWord[i],
            game.answerWord,
            i,
          );
          evaluations.add(evaluation);
          print('📝 Letter ${currentWord[i]} at position $i: $evaluation');
        }
        
        print('🎨 Setting evaluations for row ${game.currentRow}: ${evaluations.join(',')}');
        game.setRowEvaluations(game.currentRow, evaluations);

        // Submit row
        print('➡️ Moving to next row (current: ${game.currentRow})');
        game.submitRow();
        print('✅ New row: ${game.currentRow}, new col: ${game.currentCol}');
        
        _repository.saveGame(game);

        // Check game result
        if (game.gameStatus == 'won') {
          print('🏆 Game won!');
          _stopTimer();
          _repository.updateGameStats(true, game.attemptsMade);
          emit(GameWon(game: game, attempts: game.attemptsMade));
        } else if (game.gameStatus == 'lost') {
          print('💀 Game lost!');
          _stopTimer();
          _repository.updateGameStats(false, game.attemptsMade);
          emit(GameLost(game: game, answerWord: game.answerWord));
        } else {
          print('🔄 Continuing game, emitting updated state');
          print('📊 New game state - Row: ${game.currentRow}, Evaluations: ${game.letterEvaluations}');
          emit(GameLoaded(game: game));
        }
      } else {
        print('❌ Cannot submit row: status=${game.gameStatus}, complete=${game.isCurrentRowComplete}');
      }
    }
  }

  // Pause game
  void pauseGame() {
    if (state is GameLoaded) {
      final currentState = state as GameLoaded;
      final game = currentState.game;
      
      if (game.gameStatus == 'playing') {
        game.pauseGame();
        _repository.saveGame(game);
        _stopTimer();
        emit(currentState.copyWith(game: game, isPaused: true));
      }
    }
  }

  // Resume game
  void resumeGame() {
    if (state is GameLoaded) {
      final currentState = state as GameLoaded;
      final game = currentState.game;
      
      if (game.gameStatus == 'paused') {
        game.resumeGame();
        _repository.saveGame(game);
        
        if (game.isTimeMode) {
          _startTimer(game.timerRemaining);
        }
        
        emit(currentState.copyWith(game: game, isPaused: false));
      }
    }
  }

  // Start new game
  Future<void> startNewGame(bool isTimeMode) async {
    emit(GameLoading());
    
    try {
      _stopTimer();
      await _repository.deleteGame();
      final game = await _repository.createNewGame(isTimeMode);
      
      if (game.isTimeMode) {
        _startTimer(game.timerRemaining);
      }
      
      emit(GameLoaded(game: game));
    } catch (e) {
      emit(GameError('Failed to start new game: $e'));
    }
  }

  // Start timer for time-restricted mode
  void _startTimer(int initialSeconds) {
    _stopTimer();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state is GameLoaded) {
        final currentState = state as GameLoaded;
        final game = currentState.game;
        
        if (game.timerRemaining > 0) {
          game.updateTimer(game.timerRemaining - 1);
          _repository.saveGame(game);
          emit(currentState.copyWith(game: game));
        } else {
          _stopTimer();
          _repository.updateGameStats(false, game.attemptsMade);
          emit(GameTimeUp(game: game, answerWord: game.answerWord));
        }
      } else {
        _stopTimer();
      }
    });
  }

  // Stop timer
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // Clear message
  void clearMessage() {
    if (state is GameLoaded) {
      final currentState = state as GameLoaded;
      emit(currentState.copyWith(message: null));
    }
  }

  @override
  Future<void> close() {
    _stopTimer();
    return super.close();
  }
} 