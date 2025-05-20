import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'game/asian_chicken_game.dart';
import 'screens/game_over_screen.dart';
import 'widgets/pause_button.dart';
import 'widgets/pause_menu_bracu.dart';
import 'widgets/settings_menu_bracu.dart';
import 'widgets/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'providers/score_provider.dart';
import 'providers/music_provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/level_screen.dart';
import 'screens/character_selection_screen.dart';
import 'providers/level_provider.dart';
import 'providers/background_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Create and load the background provider first
  final backgroundProvider = BackgroundProvider();
  await backgroundProvider.loadBackground();

  final game = AsianChickenGame();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScoreProvider()..loadHighScore()),
        ChangeNotifierProvider(create: (_) => MusicProvider()..loadMusicSetting()),
        ChangeNotifierProvider(create: (_) => LevelProvider()..loadLevel()),
        ChangeNotifierProvider<BackgroundProvider>.value(value: backgroundProvider),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        home: Scaffold(
          body: GameWidget(
            game: game,
            overlayBuilderMap: {
              'WelcomeScreen': (context, game) {
                return WelcomeScreen(game: game as AsianChickenGame);
              },
              'LevelScreen': (context, game) {
                return LevelScreen(game: game as AsianChickenGame);
              },
              'CharacterSelectionScreen': (context, game) {
                return CharacterSelectionScreen(game: game as AsianChickenGame);
              },
              'GameOver': (context, gameInstance) {
                final asianGame = gameInstance as AsianChickenGame;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Provider.of<ScoreProvider>(context, listen: false).setScore(asianGame.score);
                });
                return GameOverScreen(game: asianGame);
              },
              'PauseButton': (context, gameInstance) {
                return PauseButton(game: gameInstance as AsianChickenGame);
              },
              'PauseMenu': (context, gameInstance) {
                return PauseMenuBracu(game: gameInstance as AsianChickenGame);
              },
              'SettingsMenuBracu': (context, gameInstance) {
                return SettingsMenuBracu(game: gameInstance as AsianChickenGame);
              },
              'Loading': (_, __) => LoadingOverlay(),
            },
            initialActiveOverlays: const ['WelcomeScreen'],
          ),
        ),
      ),
    ),
  );
}
