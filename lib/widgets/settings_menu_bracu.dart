import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../game/asian_chicken_game.dart';
import '../providers/background_provider.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame/components.dart';
import '../main.dart';

class SettingsMenuBracu extends StatefulWidget {
  final AsianChickenGame game;
  static const String id = 'SettingsMenuBracu';
  const SettingsMenuBracu({Key? key, required this.game}) : super(key: key);

  @override
  State<SettingsMenuBracu> createState() => _SettingsMenuBracuState();
}

class _SettingsMenuBracuState extends State<SettingsMenuBracu> {
  ButtonStyle chickenButtonStyle({Color? color}) {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 340),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: Colors.brown.shade700, width: 3),
          ),
          elevation: 16,
          color: Colors.yellow.shade100.withOpacity(0.95),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.brown,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Consumer<BackgroundProvider>(
                    builder: (context, backgroundProvider, child) => const SizedBox.shrink(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: chickenButtonStyle(color: Colors.blue.shade300),
                        onPressed: () {
                          widget.game.overlays.add('CharacterSelectionScreen');
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.person, color: Colors.brown),
                            SizedBox(width: 8),
                            Text('Character'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: chickenButtonStyle(color: Colors.orange.shade300),
                        onPressed: () {
                          widget.game.overlays.add('LevelScreen');
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.layers, color: Colors.brown),
                            SizedBox(width: 8),
                            Text('Levels'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: chickenButtonStyle(color: Colors.green.shade300),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) => BackgroundSelectionDialog(
                              game: widget.game,
                              onBackgroundSelected: (String key) async {
                                final globalContext = navigatorKey.currentContext!;
                                await Provider.of<BackgroundProvider>(globalContext, listen: false).setBackground(key);
                                widget.game.buildContext = globalContext;
                                await widget.game.reloadParallax();
                              },
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.image, color: Colors.brown),
                            SizedBox(width: 8),
                            Text('Background'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: chickenButtonStyle(),
                        onPressed: () {
                          widget.game.overlays.remove(SettingsMenuBracu.id);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.arrow_back, color: Colors.brown),
                            SizedBox(width: 8),
                            Text('Back'),
                          ],
                        ),
                      ),
                    ],
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

class BackgroundSelectionDialog extends StatelessWidget {
  final AsianChickenGame game;
  final Future<void> Function(String) onBackgroundSelected;
  BackgroundSelectionDialog({required this.game, required this.onBackgroundSelected, Key? key}) : super(key: key);
  final List<Map<String, String>> backgrounds = const [
    {
      'key': 'PineForestParallax',
      'image': 'assets/images/parallax/PineForestParallax/MorningLayer1.png',
      'label': 'Pine Forest',
    },
    {
      'key': 'forest1',
      'image': 'assets/images/parallax/forest1/[CelesteHa]ForestP-front.png',
      'label': 'Forest 1',
    },
    {
      'key': 'classic',
      'image': 'assets/images/parallax/plx-5.png',
      'label': 'Classic',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final selectedBackground = Provider.of<BackgroundProvider>(context).selectedBackground;
    return Dialog(
      backgroundColor: Colors.yellow.shade100.withOpacity(0.95),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(color: Colors.brown.shade700, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Background',
              style: TextStyle(
                color: Colors.brown,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: backgrounds.map((bg) {
                final isSelected = selectedBackground == bg['key'];
                return GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                    await onBackgroundSelected(bg['key']!);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    padding: EdgeInsets.all(isSelected ? 4 : 0),
                    decoration: BoxDecoration(
                      border: isSelected ? Border.all(color: Colors.orange, width: 3) : null,
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected ? Colors.orange.shade100 : Colors.transparent,
                    ),
                    child: Column(
                      children: [
                        _backgroundFrame(bg['image']!),
                        SizedBox(height: 6),
                        Text(
                          bg['label']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected ? Colors.orange.shade900 : Colors.brown.shade700,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown.shade400,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _backgroundFrame(String imagePath) {
    final displaySize = 64.0;
    return FutureBuilder(
      future: Flame.images.load(imagePath.replaceFirst('assets/images/', '')),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(width: displaySize, height: displaySize);
        }
        final image = snapshot.data!;
        final sprite = Sprite(image);
        return SizedBox(
          width: displaySize,
          height: displaySize,
          child: CustomPaint(
            painter: _SpritePainter(sprite),
          ),
        );
      },
    );
  }
}

class _SpritePainter extends CustomPainter {
  final Sprite sprite;
  _SpritePainter(this.sprite);

  @override
  void paint(Canvas canvas, Size size) {
    sprite.render(canvas, position: Vector2.zero(), size: Vector2(size.width, size.height));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 