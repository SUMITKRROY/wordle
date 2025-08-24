import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants.dart';
import '../../provider/settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(AppText.settings),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoaded) {
            return _buildSettingsList(context, state.settings);
          } else if (state is SettingsError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context, settings) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Appearance Section
        _buildSectionHeader('Appearance'),
        _buildSwitchTile(
          context: context,
          title: 'Dark Mode',
          subtitle: 'Use dark theme',
          value: settings.isDarkMode,
          onChanged: (value) {
            context.read<SettingsCubit>().toggleDarkMode();
          },
          icon: Icons.dark_mode,
        ),
        
        const SizedBox(height: 24),
        
        // Game Settings Section
        _buildSectionHeader('Game Settings'),
        _buildSwitchTile(
          context: context,
          title: 'Time Mode',
          subtitle: 'Enable 2-minute timer mode',
          value: settings.isTimeModeEnabled,
          onChanged: (value) {
            context.read<SettingsCubit>().toggleTimeMode();
          },
          icon: Icons.timer,
        ),
        
        const SizedBox(height: 24),
        
        // Sound & Haptics Section
        _buildSectionHeader('Sound & Haptics'),
        _buildSwitchTile(
          context: context,
          title: 'Sound Effects',
          subtitle: 'Play sound effects',
          value: settings.isSoundEnabled,
          onChanged: (value) {
            context.read<SettingsCubit>().toggleSound();
          },
          icon: Icons.volume_up,
        ),
        _buildSwitchTile(
          context: context,
          title: 'Vibration',
          subtitle: 'Vibrate on key press',
          value: settings.isVibrationEnabled,
          onChanged: (value) {
            context.read<SettingsCubit>().toggleVibration();
          },
          icon: Icons.vibration,
        ),
        
        const SizedBox(height: 24),
        
        // Statistics Section
        _buildSectionHeader('Statistics'),
        _buildStatisticsCard(context, settings),
        
        const SizedBox(height: 24),
        
        // About Section
        _buildSectionHeader('About'),
        _buildAboutCard(context),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Card(
      child: SwitchListTile(
        title: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Text(title),
          ],
        ),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildStatisticsCard(BuildContext context, settings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bar_chart, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                const Text(
                  'Game Statistics',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Games Played', settings.gamesPlayed.toString()),
                _buildStatItem('Games Won', settings.gamesWon.toString()),
                _buildStatItem('Win Rate', '${settings.winPercentage.toStringAsFixed(0)}%'),
              ],
            ),
            if (settings.bestScore > 0) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Best Score', settings.bestScore.toString()),
                  _buildStatItem('Avg Attempts', settings.averageAttempts.toString()),
                ],
              ),
            ],
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
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                const Text(
                  'About Lite Wordle',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'A Flutter implementation of the popular word guessing game Wordle. '
              'Guess the 5-letter word in 6 tries with color-coded feedback.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Version: ${AppConstants.version}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 