import 'package:flutter/material.dart';
import '../game/bracu_chicken_game.dart';
import 'package:flame_audio/flame_audio.dart';

class PauseButton extends StatelessWidget {
  final BracuChickenGame game;
  static const String id = 'PauseButton';
  const PauseButton({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 20),
        child: ClipOval(
          child: Material(
            color: Colors.white.withOpacity(0.15),
            elevation: 10,
            child: InkWell(
              splashColor: Colors.orange.withOpacity(0.2),
              onTap: () {
                game.pauseEngine();
                game.overlays.add('PauseMenu');
                game.overlays.remove(PauseButton.id);
              },
              child: const SizedBox(
                width: 56,
                height: 56,
                child: Icon(Icons.pause, color: Colors.white, size: 32),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 