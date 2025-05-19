import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../game/bracu_chicken_game.dart';
import 'package:flame/game.dart';

class WelcomeScreen extends StatefulWidget {
  final BracuChickenGame game;
  static const String id = 'WelcomeScreen';
  const WelcomeScreen({Key? key, required this.game}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // Add a list of available characters (key, image asset, label)
  final List<Map<String, String>> characters = [
    {
      'key': 'chickboy',
      'image': 'assets/images/ChickBoy/ChikBoy_run.png',
      'label': 'ChickBoy',
    },
    {
      'key': 'classic',
      'image': 'assets/images/chicken/Chicken_Sprite_Sheet.png',
      'label': 'Classic',
    },
    {
      'key': 'black',
      'image': 'assets/images/chicken/Chicken_Sprite_Sheet_Black.png',
      'label': 'Black',
    },
    {
      'key': 'dark_brown',
      'image': 'assets/images/chicken/Chicken_Sprite_Sheet_Dark_Brown.png',
      'label': 'Dark Brown',
    },
    // Add more characters here if needed
  ];
  String selectedCharacter = 'chickboy';

  @override
  Widget build(BuildContext context) {
    final double maxCardWidth = 400;
    final double minCardWidth = 220;
    final double minCardHeight = 180;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double maxCardHeight = math.max(screenHeight * 0.9, minCardHeight);

    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
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
                borderRadius: BorderRadius.circular(28),
                side: BorderSide(color: Colors.brown.shade700, width: 2),
              ),
              elevation: 14,
              color: Colors.yellow.shade100.withOpacity(0.95),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.egg, size: 40, color: Colors.orange.shade400),
                      const SizedBox(height: 8),
                      const Text(
                        'Welcome to Bracu Chicken!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.brown,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.05,
                        ),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade400,
                          foregroundColor: Colors.brown.shade900,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 1.08),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 4,
                          shadowColor: Colors.orange.shade200,
                        ),
                        onPressed: () async {
                          // Always reset the game before starting
                          await widget.game.reset();
                          widget.game.selectedCharacter = selectedCharacter;
                          widget.game.overlays.remove(WelcomeScreen.id);
                          widget.game.resumeEngine();
                          widget.game.overlays.add('PauseButton');
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_arrow, size: 24, color: Colors.brown.shade900),
                            SizedBox(width: 10),
                            Text('Play'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade500,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 8,
                          shadowColor: Colors.green.shade200,
                        ),
                        onPressed: () {
                          widget.game.overlays.add('SettingsMenuBracu');
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.settings, size: 24, color: Colors.white),
                            SizedBox(width: 10),
                            Text('Settings'),
                          ],
                        ),
                      ),
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
} 