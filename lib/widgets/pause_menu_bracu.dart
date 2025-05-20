import 'package:flutter/material.dart';
import '../game/asian_chicken_game.dart';
import 'package:flame_audio/flame_audio.dart';
import '../providers/music_provider.dart';
import 'package:provider/provider.dart';

class PauseMenuBracu extends StatelessWidget {
  final AsianChickenGame game;
  static const String id = 'PauseMenu';
  const PauseMenuBracu({Key? key, required this.game}) : super(key: key);

  ButtonStyle chickenButtonStyle({Color? color}) {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: Colors.brown.shade700, width: 2),
      ),
      backgroundColor: color ?? Colors.yellow.shade600,
      foregroundColor: Colors.brown.shade900,
      textStyle: const TextStyle(
        fontSize: 22,
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Paused',
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: chickenButtonStyle(color: Colors.orange.shade400),
                onPressed: () {
                  game.overlays.remove(PauseMenuBracu.id);
                  game.overlays.add('PauseButton');
                  game.resumeEngine();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.play_arrow, color: Colors.brown),
                    SizedBox(width: 8),
                    Text('Resume'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: chickenButtonStyle(color: Colors.green.shade400),
                onPressed: () {
                  // Remove all overlays except WelcomeScreen
                  game.overlays.clear();
                  game.pauseEngine();
                  game.overlays.add('WelcomeScreen');
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
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
    );
  }
} 