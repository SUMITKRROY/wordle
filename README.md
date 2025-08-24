# Lite Wordle

A Flutter implementation of the popular word guessing game Wordle with additional features like time-restricted mode and game persistence.

## Features

### 🎮 Core Game
- **Classic Wordle Gameplay**: Guess 5-letter words in 6 attempts
- **Color-coded Feedback**: Green (correct position), Yellow (correct letter, wrong position), Gray (not in word)
- **Online Word Validation**: Words checked against external dictionary API with offline fallback
- **Word Definitions**: Learn the meaning of answer words
- **On-screen Keyboard**: Visual keyboard with color-coded letter feedback

### ⏱️ Time-Restricted Mode
- **2-Minute Timer**: Challenge yourself with a countdown timer
- **Pause/Resume**: Pause the game and resume later
- **Timer Persistence**: Timer state is saved when app is closed

### 💾 Game Persistence
- **Hive Database**: Local storage using Hive for game state
- **Auto-Save**: Game progress is automatically saved
- **Resume Game**: Continue from where you left off after app restart
- **Settings Persistence**: User preferences and statistics are saved

### 🎨 User Interface
- **Light/Dark Theme**: Toggle between light and dark themes
- **Responsive Design**: Works on different screen sizes
- **Smooth Animations**: Tile flip animations and keyboard interactions
- **Modern UI**: Material Design 3 with custom theming

### 📊 Statistics & Sharing
- **Game Statistics**: Track games played, win rate, best score
- **Score Sharing**: Share results via system share sheet
- **Performance Tracking**: Average attempts and win percentage

### ⚙️ Settings
- **Theme Toggle**: Switch between light and dark themes
- **Game Mode Selection**: Choose between classic and time-restricted modes
- **Sound & Haptics**: Toggle sound effects and vibration
- **Statistics View**: View detailed game performance metrics

## Project Structure

```
lib/
├── core/                    # Core utilities and constants
│   ├── constants.dart       # App constants and configuration
│   ├── theme.dart          # Theme definitions
│   └── utils.dart          # Utility functions
├── data/                   # Data layer
│   ├── game_model.dart     # Hive model for game state
│   └── settings_model.dart # Hive model for settings
├── logic/                  # Business logic layer
│   ├── game_cubit.dart     # Game state management
│   ├── game_state.dart     # Game state definitions
│   └── settings_cubit.dart # Settings state management
├── service/                # Service layer
│   ├── game_repository.dart # Data repository
│   ├── word_validation_service.dart # Word validation service
│   ├── game_model.g.dart   # Generated Hive model
│   └── settings_model.g.dart # Generated Hive model
└── presentation/           # UI layer
    ├── screens/            # App screens
    │   ├── splash_screen.dart
    │   ├── home_screen.dart
    │   ├── game_screen.dart
    │   ├── results_screen.dart
    │   └── settings_screen.dart
    └── widgets/            # Reusable widgets
        ├── wordle_board.dart
        ├── wordle_keyboard.dart
        ├── wordle_tile.dart
        ├── timer_widget.dart
        └── custom_app_bar.dart
```

## Getting Started

### Prerequisites
- Flutter 3.24.0 or higher
- Dart 3.6.0 or higher

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd wordle
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Dependencies

- **flutter_bloc**: State management
- **dio**: HTTP client for API calls
- **hive**: Local database
- **hive_flutter**: Flutter integration for Hive
- **share_plus**: Share functionality
- **dio**: HTTP client for API calls
- **flutter_animate**: Animations
- **equatable**: Value equality

## How to Play

1. **Start a Game**: Choose between Classic Mode (unlimited time) or Time Mode (2-minute timer)
2. **Guess Words**: Type 5-letter words using the on-screen keyboard
3. **Get Feedback**: 
   - 🟩 Green tile: Letter is in correct position
   - 🟨 Yellow tile: Letter is in word but wrong position
   - ⬜ Gray tile: Letter is not in word
4. **Win or Lose**: Solve the word in 6 attempts or less

## Game Modes

### Classic Mode
- Unlimited time to solve
- Perfect for casual play
- Focus on strategy and word knowledge

### Time Mode
- 2-minute countdown timer
- Adds excitement and challenge
- Tests quick thinking and word recognition

## Features in Detail

### Game Persistence
The app uses Hive database to save:
- Current game state (grid, position, answer word)
- Game status (playing, paused, won, lost)
- Timer remaining (for time mode)
- Letter evaluations for keyboard coloring

### Pause/Resume
- Games can be paused at any time
- Timer stops when paused
- Resume exactly where you left off
- Works even after app restart

### Statistics Tracking
- Games played and won
- Win percentage
- Best score (fewest attempts)
- Average attempts for wins

### Theme Support
- Light and dark themes
- Automatic theme switching
- Persistent theme preference
- Material Design 3 styling

### API Integration
- **Free Dictionary API**: External word validation
- **Offline Fallback**: Local word list when internet unavailable
- **Word Definitions**: Get definitions for submitted words
- **Network Status**: Visual indicator for online/offline mode

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Inspired by the original Wordle game
- Built with Flutter and Dart
- Uses Material Design 3 guidelines
