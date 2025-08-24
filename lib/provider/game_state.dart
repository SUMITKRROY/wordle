import 'package:equatable/equatable.dart';
import '../data/game_model.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {}

class GameLoading extends GameState {}

class GameLoaded extends GameState {
  final GameModel game;
  final bool isPaused;
  final String? message;

  const GameLoaded({
    required this.game,
    this.isPaused = false,
    this.message,
  });

  @override
  List<Object?> get props => [game, isPaused, message];

  GameLoaded copyWith({
    GameModel? game,
    bool? isPaused,
    String? message,
  }) {
    return GameLoaded(
      game: game ?? this.game,
      isPaused: isPaused ?? this.isPaused,
      message: message ?? this.message,
    );
  }
}

class GameWon extends GameState {
  final GameModel game;
  final int attempts;

  const GameWon({
    required this.game,
    required this.attempts,
  });

  @override
  List<Object?> get props => [game, attempts];
}

class GameLost extends GameState {
  final GameModel game;
  final String answerWord;

  const GameLost({
    required this.game,
    required this.answerWord,
  });

  @override
  List<Object?> get props => [game, answerWord];
}

class GameTimeUp extends GameState {
  final GameModel game;
  final String answerWord;

  const GameTimeUp({
    required this.game,
    required this.answerWord,
  });

  @override
  List<Object?> get props => [game, answerWord];
}

class GameError extends GameState {
  final String message;

  const GameError(this.message);

  @override
  List<Object?> get props => [message];
} 