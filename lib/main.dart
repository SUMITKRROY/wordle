import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme.dart';
import 'service/game_repository.dart';
import 'provider/game_cubit.dart';
import 'provider/settings_cubit.dart';
import 'presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  final repository = GameRepository();
  await repository.initialize();
  
  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final GameRepository repository;

  const MyApp({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>(
          create: (context) => SettingsCubit(repository)..loadSettings(),
        ),
        BlocProvider<GameCubit>(
          create: (context) => GameCubit(repository),
        ),
      ],
      child: BlocBuilder<SettingsCubit, dynamic>(
        builder: (context, settingsState) {
          bool isDarkMode = false;
          
          if (settingsState is SettingsLoaded) {
            isDarkMode = settingsState.settings.isDarkMode;
          }
          
          return MaterialApp(
            title: 'Lite Wordle',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
