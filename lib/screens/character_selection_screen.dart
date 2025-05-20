import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../game/asian_chicken_game.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';

class CharacterSelectionScreen extends StatefulWidget {
  final AsianChickenGame game;
  static const String id = 'CharacterSelectionScreen';
  const CharacterSelectionScreen({Key? key, required this.game}) : super(key: key);

  @override
  State<CharacterSelectionScreen> createState() => _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
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
  ];
  String selectedCharacter = 'chickboy';

  @override
  void initState() {
    super.initState();
    selectedCharacter = widget.game.selectedCharacter;
  }

  Future<void> _selectCharacter(String key) async {
    setState(() {
      selectedCharacter = key;
    });
    widget.game.selectedCharacter = key;
    await widget.game.changeCharacter(key);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCharacter', key);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(color: Colors.brown.shade700, width: 2),
          ),
          elevation: 14,
          color: Colors.yellow.shade100.withOpacity(0.95),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Your Chicken',
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
                  children: characters.map((character) {
                    final isSelected = selectedCharacter == character['key'];
                    return GestureDetector(
                      onTap: () => _selectCharacter(character['key']!),
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
                            _characterFrame(character['image']!, character['key']!),
                            SizedBox(height: 6),
                            Text(
                              character['label']!,
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
                    widget.game.overlays.remove(CharacterSelectionScreen.id);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _characterFrame(String imagePath, String characterKey) {
    // Show only the first frame (top-left 32x32) of the sprite sheet
    final frameSize = 32.0;
    final displaySize = 48.0;
    return FutureBuilder(
      future: Flame.images.load(imagePath.replaceFirst('assets/images/', '')),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(width: displaySize, height: displaySize);
        }
        final image = snapshot.data!;
        final sprite = Sprite(
          image,
          srcPosition: Vector2(0, 0),
          srcSize: Vector2(frameSize, frameSize),
        );
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