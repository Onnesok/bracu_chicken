import 'package:flutter/material.dart';
import '../game/asian_chicken_game.dart';
import 'package:provider/provider.dart';
import '../providers/level_provider.dart';
import 'package:flame/game.dart';

class LevelScreen extends StatelessWidget {
  final AsianChickenGame game;
  static const String id = 'LevelScreen';
  const LevelScreen({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double maxCardWidth = 420;
    final double minCardWidth = 280;
    final double minCardHeight = 240;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double maxCardHeight = (screenHeight * 0.5).clamp(minCardHeight, double.infinity);
    final String selectedLevel = Provider.of<LevelProvider>(context).selectedLevel;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: minCardWidth,
              maxWidth: maxCardWidth,
              minHeight: minCardHeight,
              maxHeight: maxCardHeight,
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Colors.brown.shade700, width: 3),
              ),
              elevation: 16,
              color: Colors.yellow.shade100.withOpacity(0.95),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Select Level',
                        style: TextStyle(
                          color: Colors.brown,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _levelButton(context, 'Easy', Colors.green.shade400, Colors.brown, 'easy', selectedLevel),
                      const SizedBox(height: 8),
                      _levelButton(context, 'Medium', Colors.blue.shade400, Colors.brown, 'medium', selectedLevel),
                      const SizedBox(height: 8),
                      _levelButton(context, 'Hard', Colors.orange.shade400, Colors.brown, 'hard', selectedLevel),
                      const SizedBox(height: 8),
                      _levelButton(context, 'Asia', Colors.red.shade700, Colors.white, 'asia', selectedLevel),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _levelButton(BuildContext context, String label, Color bg, Color fg, String levelKey, String selectedLevel) {
    final bool isSelected = selectedLevel == levelKey;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: isSelected ? 10 : 2,
        shadowColor: isSelected ? Colors.green : null,
      ),
      onPressed: () {
        Provider.of<LevelProvider>(context, listen: false).setLevel(levelKey);
        game.setDifficulty(levelKey);
        game.overlays.remove(LevelScreen.id);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (isSelected) ...[
            const SizedBox(width: 10),
            Icon(Icons.check, color: Colors.green, size: 20),
          ],
        ],
      ),
    );
  }
} 