import 'package:flutter/material.dart';
import '../game/asian_chicken_game.dart';
import 'package:provider/provider.dart';
import '../providers/score_provider.dart';

class GameOverScreen extends StatelessWidget {
  final AsianChickenGame game;
  static const String id = 'GameOver';
  const GameOverScreen({Key? key, required this.game}) : super(key: key);

  ButtonStyle chickenButtonStyle({Color? color}) {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: Colors.brown.shade700, width: 2),
      ),
      backgroundColor: color ?? Colors.yellow.shade600,
      foregroundColor: Colors.brown.shade900,
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
      ),
      elevation: 8,
      shadowColor: Colors.brown.shade200,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.brown.shade700, width: 3),
        ),
        elevation: 16,
        color: Colors.yellow.shade100.withOpacity(0.95),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Consumer<ScoreProvider>(
            builder: (context, scoreProvider, child) => SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Game Over',
                    style: TextStyle(
                      color: Colors.brown,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Score: ${scoreProvider.score}',
                    style: const TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'High Score: ${scoreProvider.highScore}',
                    style: const TextStyle(fontSize: 16, color: Colors.brown, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: chickenButtonStyle(color: Colors.orange.shade400),
                    onPressed: () async {
                      game.overlays.remove(GameOverScreen.id);
                      await game.reset();
                      game.resumeEngine();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.refresh, color: Colors.brown),
                        SizedBox(width: 8),
                        Text('Restart'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: chickenButtonStyle(color: Colors.blue.shade300),
                    onPressed: () {
                      game.overlays.remove(GameOverScreen.id);
                      game.overlays.add('WelcomeScreen');
                      game.pauseEngine();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.home, color: Colors.brown),
                        SizedBox(width: 8),
                        Text('Main Menu'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
