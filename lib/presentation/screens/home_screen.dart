import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordle/data/settings_model.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../service/game_repository.dart';
import '../../provider/game_cubit.dart';
import '../../provider/game_state.dart';
import '../../provider/settings_cubit.dart';
import 'game_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize game if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameCubit = context.read<GameCubit>();
      if (gameCubit.state is GameInitial) {
        gameCubit.initializeGame();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            title: Text(AppText.appName),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: BlocBuilder<GameCubit, GameState>(
            builder: (context, gameState) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Statistics Card
                    if (settingsState is SettingsLoaded)
                      _buildStatisticsCard(settingsState.settings),

                    const SizedBox(height: 40),

                    // Game Mode Selection
                    _buildGameModeSelection(),

                    const SizedBox(height: 40),

                    // Resume Game Button
                    if (gameState is GameLoaded)
                      _buildResumeGameButton(),

                    const Spacer(),

                    // Instructions
                    _buildInstructions(),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildStatisticsCard(SettingsModel settings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Played', settings.gamesPlayed.toString()),
                _buildStatItem('Win %', '${settings.winPercentage.toStringAsFixed(0)}%'),
                _buildStatItem('Best', settings.bestScore > 0 ? settings.bestScore.toString() : '-'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildGameModeSelection() {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        if (settingsState is! SettingsLoaded) return const SizedBox.shrink();
        
        return Column(
          children: [
            Text(
              'Choose Game Mode',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildModeCard(
                    title: AppText.classicMode,
                    subtitle: 'Unlimited time',
                    icon: Icons.schedule,
                    isSelected: !settingsState.settings.isTimeModeEnabled,
                    onTap: () {
                      context.read<SettingsCubit>().toggleTimeMode();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildModeCard(
                    title: AppText.timeMode,
                    subtitle: '2 minutes',
                    icon: Icons.timer,
                    isSelected: settingsState.settings.isTimeModeEnabled,
                    onTap: () {
                      context.read<SettingsCubit>().toggleTimeMode();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _startNewGame(settingsState.settings.isTimeModeEnabled),
                child: const Text('Start New Game'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildModeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: isSelected 
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline.withOpacity(0.3),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumeGameButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const GameScreen(),
            ),
          );
        },
        child: const Text('Resume Game'),
      ),
    );
  }

  Widget _buildInstructions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How to Play',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '• Guess the 5-letter word in 6 tries\n'
              '• Green tile: Letter is in correct position\n'
              '• Yellow tile: Letter is in word but wrong position\n'
              '• Gray tile: Letter is not in word',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startNewGame(bool isTimeMode) {
    context.read<GameCubit>().startNewGame(isTimeMode);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const GameScreen(),
      ),
    );
  }
} 