import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../service/game_repository.dart';
import '../data/settings_model.dart';

// Settings State
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final SettingsModel settings;

  const SettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];

  SettingsLoaded copyWith({
    SettingsModel? settings,
  }) {
    return SettingsLoaded(settings ?? this.settings);
  }
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Settings Cubit
class SettingsCubit extends Cubit<SettingsState> {
  final GameRepository _repository;

  SettingsCubit(this._repository) : super(SettingsInitial());

  // Load settings
  void loadSettings() {
    try {
      final settings = _repository.getSettings();
      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError('Failed to load settings: $e'));
    }
  }

  // Toggle dark mode
  void toggleDarkMode() {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final newSettings = currentState.settings.copyWith(
        isDarkMode: !currentState.settings.isDarkMode,
      );
      
      _repository.saveSettings(newSettings);
      emit(currentState.copyWith(settings: newSettings));
    }
  }

  // Toggle time mode
  void toggleTimeMode() {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final newSettings = currentState.settings.copyWith(
        isTimeModeEnabled: !currentState.settings.isTimeModeEnabled,
      );
      
      _repository.saveSettings(newSettings);
      emit(currentState.copyWith(settings: newSettings));
    }
  }

  // Toggle sound
  void toggleSound() {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final newSettings = currentState.settings.copyWith(
        isSoundEnabled: !currentState.settings.isSoundEnabled,
      );
      
      _repository.saveSettings(newSettings);
      emit(currentState.copyWith(settings: newSettings));
    }
  }

  // Toggle vibration
  void toggleVibration() {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final newSettings = currentState.settings.copyWith(
        isVibrationEnabled: !currentState.settings.isVibrationEnabled,
      );
      
      _repository.saveSettings(newSettings);
      emit(currentState.copyWith(settings: newSettings));
    }
  }

  // Get current settings
  SettingsModel? getCurrentSettings() {
    if (state is SettingsLoaded) {
      return (state as SettingsLoaded).settings;
    }
    return null;
  }
} 