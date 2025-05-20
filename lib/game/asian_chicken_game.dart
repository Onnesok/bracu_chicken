import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame/flame.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:core';
import '../screens/game_over_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chicken.dart';
import 'enemy_manager.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:provider/provider.dart';
import '../providers/score_provider.dart';
import '../providers/music_provider.dart';
import 'dart:ui' as ui;
import '../providers/level_provider.dart';
import '../providers/background_provider.dart';

class AsianChickenGame extends FlameGame with PanDetector, HasCollisionDetection {
  BuildContext? buildContext;
  Chicken? chicken;
  ParallaxComponent? parallax;
  late Vector2 parallaxBaseVelocity;
  final TextComponent scoreText = TextComponent(
    text: 'Score: 0',
    position: Vector2(10, 10),
    anchor: Anchor.topLeft,
    textRenderer: TextPaint(style: TextStyle(color: Colors.white, fontSize: 24)),
  );
  int score = 0;
  int _highScore = 0;
  bool isGameOver = false;
  EnemyManager? enemyManager;
  Vector2? _swipeStart;
  Vector2? _swipeEnd;
  bool isMusicMuted = false;
  double _scoreAccumulator = 0;
  String difficulty = 'easy';
  String _selectedLevel = 'easy';
  String selectedCharacter = 'chickboy';
  double speedMultiplier = 1.0;
  late Vector2 velocityMultiplierDelta;
  bool isLoaded = false;

  int get highScore => _highScore;

  Future<void> loadMusicSetting() async {
    final prefs = await SharedPreferences.getInstance();
    isMusicMuted = prefs.getBool('isMusicMuted') ?? false;
  }

  Future<void> saveMusicSetting() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isMusicMuted', isMusicMuted);
  }

  // Load high score from storage
  Future<void> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    _highScore = prefs.getInt('highScore') ?? 0;
  }

  // Save high score to storage
  Future<void> saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highScore', _highScore);
  }

  @override
  Future<void> onLoad() async {
    // print('onLoad started');
    await super.onLoad();
    await loadHighScore();
    // Load saved character selection
    final prefs = await SharedPreferences.getInstance();
    selectedCharacter = prefs.getString('selectedCharacter') ?? 'chickboy';
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();
    await ready();

    parallaxBaseVelocity = Vector2(36 * speedMultiplier, 0);
    velocityMultiplierDelta = Vector2(1.4, 0);
    // Determine background from provider
    String background = 'PineForestParallax';
    if (buildContext != null) {
      await Provider.of<BackgroundProvider>(buildContext!, listen: false).loadBackground();
      background = Provider.of<BackgroundProvider>(buildContext!, listen: false).selectedBackground;
    } else {
      // Load directly from SharedPreferences if no context yet
      background = prefs.getString('selectedBackground') ?? 'PineForestParallax';
    }
    // Adjust parallax speed for forest1
    double enemySpeedMultiplier = 1.0;
    if (background == 'forest1') {
      parallaxBaseVelocity = Vector2(36 * speedMultiplier, 0);
      velocityMultiplierDelta = Vector2(1.7, 0);
      enemySpeedMultiplier = 1.44;
    } else {
      parallaxBaseVelocity = Vector2(25 * speedMultiplier, 0);
      velocityMultiplierDelta = Vector2(1.4, 0);
      enemySpeedMultiplier = 1.0;
    }
    List<ParallaxImageData> parallaxLayers;
    if (background == 'PineForestParallax') {
      parallaxLayers = [
        ParallaxImageData('parallax/PineForestParallax/MorningLayer6.png'),
        ParallaxImageData('parallax/PineForestParallax/MorningLayer5.png'),
        ParallaxImageData('parallax/PineForestParallax/MorningLayer4.png'),
        ParallaxImageData('parallax/PineForestParallax/MorningLayer3.png'),
        ParallaxImageData('parallax/PineForestParallax/MorningLayer2.png'),
        ParallaxImageData('parallax/PineForestParallax/MorningLayer1.png'),
        ParallaxImageData('parallax/PineForestParallax/ground.png'),
      ];
    } else if (background == 'forest1') {
      parallaxLayers = [
        ParallaxImageData('parallax/forest1/[CelesteHa]ForestP-back.png'),
        ParallaxImageData('parallax/forest1/[CelesteHa]ForestP-middle.png'),
        ParallaxImageData('parallax/forest1/[CelesteHa]ForestP-front.png'),
        ParallaxImageData('parallax/forest1/[CelesteHa]ForestP-foreground.png'),
      ];
      // Move the forest1 ground up by applying a y offset to the parallax
      // (Assume the last layer is the ground)
      // We'll set the parallax position after creation
    } else if (background == 'classic') {
      parallaxLayers = [
        ParallaxImageData('parallax/plx-1.png'),
        ParallaxImageData('parallax/plx-2.png'),
        ParallaxImageData('parallax/plx-3.png'),
        ParallaxImageData('parallax/plx-4.png'),
        ParallaxImageData('parallax/plx-5.png'),
        ParallaxImageData('parallax/plx-6.png'),
      ];
    } else {
      parallaxLayers = [
        ParallaxImageData('parallax/PineForestParallax/MorningLayer6.png'),
        ParallaxImageData('parallax/PineForestParallax/MorningLayer5.png'),
        ParallaxImageData('parallax/PineForestParallax/MorningLayer4.png'),
        ParallaxImageData('parallax/PineForestParallax/MorningLayer3.png'),
        ParallaxImageData('parallax/PineForestParallax/MorningLayer2.png'),
        ParallaxImageData('parallax/PineForestParallax/MorningLayer1.png'),
        ParallaxImageData('parallax/PineForestParallax/ground.png'),
      ];
    }
    parallax = await loadParallaxComponent(
      parallaxLayers,
      baseVelocity: parallaxBaseVelocity,
      velocityMultiplierDelta: velocityMultiplierDelta,
      alignment: Alignment.bottomCenter,
    );
    parallax!.anchor = Anchor.topLeft;
    // Apply a y offset if forest1 is selected
    if (background == 'forest1') {
      parallax!.y -= 10; //(adjust as needed)
    }
    add(parallax!);

    // Load and add the chicken character based on selectedCharacter
    ui.Image chickenImage;
    if (selectedCharacter == 'classic') {
      chickenImage = await images.load('chicken/Chicken_Sprite_Sheet.png');
    } else if (selectedCharacter == 'black') {
      chickenImage = await images.load('chicken/Chicken_Sprite_Sheet_Black.png');
    } else if (selectedCharacter == 'dark_brown') {
      chickenImage = await images.load('chicken/Chicken_Sprite_Sheet_Dark_Brown.png');
    } else {
      chickenImage = await images.load('ChickBoy/ChikBoy_run.png');
    }
    chicken = Chicken(chickenImage, characterKey: selectedCharacter);
    if (selectedCharacter == 'classic' || selectedCharacter == 'black' || selectedCharacter == 'dark_brown') {
      chicken!.position = Vector2(32 + 24, size.y - 60 + 16);
      chicken!.yMax = chicken!.position.y;
    } else if (selectedCharacter == 'chickboy') {
      chicken!.position = Vector2(32, size.y - 48);
      chicken!.yMax = chicken!.position.y;
    }
    add(chicken!);

    // Preload enemy images before adding the enemy manager
    await images.loadAll([
      'witch/B_witch_run.png',
      'Bat/Flying (46x30).png',
      'cat_girl/cat_Run.png',
    ]);

    // Initialize and add the enemy manager
    enemyManager = EnemyManager();
    add(enemyManager!);

    // Now call setDifficulty after enemyManager is initialized
    if (buildContext != null) {
      final providerLevel = Provider.of<LevelProvider>(buildContext!, listen: false).selectedLevel;
      setDifficulty(providerLevel, enemySpeedMultiplier: enemySpeedMultiplier);
    } else {
      await loadSelectedLevel();
      setDifficulty(_selectedLevel, enemySpeedMultiplier: enemySpeedMultiplier);
    }

    add(scoreText);
    overlays.remove('Loading');
    pauseEngine();
    // print('onLoad finished');
    if (buildContext != null) {
      Provider.of<ScoreProvider>(buildContext!, listen: false).setScore(0);
    }
    isLoaded = true;
  }

  @override
  void update(double dt) {
    // print('update called');
    super.update(dt);
    if (isGameOver) return;
    _scoreAccumulator += dt * 1;
    int newScore = _scoreAccumulator.floor();
    if (newScore != score) {
      score = newScore;
      scoreText.text = 'Score: $score';
      if (buildContext != null) {
        Provider.of<ScoreProvider>(buildContext!, listen: false).setScore(score);
      }
    }
  }

  void gameOver() {
    isGameOver = true;
    if (score > _highScore) {
      _highScore = score;
      saveHighScore();
    }
    if (buildContext != null) {
      Provider.of<ScoreProvider>(buildContext!, listen: false).setScore(score);
    }
    // Remove all obstacles on game over
    final obstacles = children.whereType<Obstacle>().toList();
    for (var obstacle in obstacles) {
      obstacle.removeFromParent();
    }
    FlameAudio.bgm.pause();
    overlays.add('GameOver');
    pauseEngine();
    overlays.remove('PauseButton');
    overlays.remove('ControlButtons');
  }

  Future<void> reset() async {
    // Remove all enemies
    enemyManager?.removeAllEnemies();

    // Remove all obstacles
    final obstacles = children.whereType<Obstacle>().toList();
    for (var obstacle in obstacles) {
      obstacle.removeFromParent();
    }

    // Wait for removals to process
    await Future.delayed(Duration.zero);

    // Reset chicken
    chicken?.reset();

    // Reset score and state
    score = 0;
    _scoreAccumulator = 0;
    scoreText.text = 'Score: 0';
    isGameOver = false;

    if (buildContext != null) {
      Provider.of<ScoreProvider>(buildContext!, listen: false).resetScore();
    }

    // Resume the engine
    resumeEngine();
    overlays.add('PauseButton');
    overlays.add('ControlButtons');
  }

  @override
  void onPanStart(DragStartInfo info) {
    _swipeStart = info.eventPosition.global;
    _swipeEnd = null;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _swipeEnd = info.eventPosition.global;
  }

  @override
  void onPanEnd(DragEndInfo info) {
    if (_swipeStart != null && _swipeEnd != null) {
      final delta = _swipeEnd! - _swipeStart!;
      // print('Swipe delta: dx=${delta.x}, dy=${delta.y}, length=${delta.length}');
      // Upward swipe: y decreases upwards in Flame
      if (delta.y < -30 && delta.length > 30) {
        // print('Detected: UP');
        chicken?.jump();
      } else if (delta.x > 30 && delta.x.abs() > delta.y.abs()) {
        // print('Detected: RIGHT');
        chicken?.moveRight();
      } else if (delta.x < -30 && delta.x.abs() > delta.y.abs()) {
        // print('Detected: LEFT');
        chicken?.moveLeft();
      } else if (delta.y > 30 && delta.y.abs() > delta.x.abs()) {
        // print('Detected: DOWN');
        chicken?.groundPound();
      } else {
        // print('Detected: NONE');
      }
    }
    _swipeStart = null;
    _swipeEnd = null;
  }

  void playSfx(String file) {
    if (buildContext != null && !Provider.of<MusicProvider>(buildContext!, listen: false).isMusicMuted) {
      FlameAudio.play(file);
    }
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    if (parallax != null) {
      parallax!.size = canvasSize;
    }
  }

  void setDifficulty(String value, {double enemySpeedMultiplier = 1.0}) {
    difficulty = value;
    _selectedLevel = value;
    saveSelectedLevel(value);
    // print('Difficulty set to: $difficulty');
    double parallaxSpeed = 16;
    if (difficulty == 'easy') {
      speedMultiplier = 0.7;
      parallaxSpeed = 16;
    } else if (difficulty == 'medium') {
      speedMultiplier = 0.85;
      parallaxSpeed = 22;
    } else if (difficulty == 'hard') {
      speedMultiplier = 1.0;
      parallaxSpeed = 28;
    } else if (difficulty == 'asia') {
      speedMultiplier = 1.2;
      parallaxSpeed = 36;
    }
    if (parallax != null) {
      parallaxBaseVelocity = Vector2(parallaxSpeed, 0);
      // Update the parallax base velocity
      if (parallax!.parallax != null) {
        parallax!.parallax!.baseVelocity.setFrom(parallaxBaseVelocity);
      }
    }
    enemyManager?.setDifficulty(difficulty, enemySpeedMultiplier: enemySpeedMultiplier);
  }

  Future<void> changeCharacter(String characterKey) async {
    selectedCharacter = characterKey;
    // Remove the current chicken from the game
    chicken?.removeFromParent();
    // Load the new sprite
    ui.Image chickenImage;
    if (selectedCharacter == 'classic') {
      chickenImage = await images.load('chicken/Chicken_Sprite_Sheet.png');
    } else if (selectedCharacter == 'black') {
      chickenImage = await images.load('chicken/Chicken_Sprite_Sheet_Black.png');
    } else if (selectedCharacter == 'dark_brown') {
      chickenImage = await images.load('chicken/Chicken_Sprite_Sheet_Dark_Brown.png');
    } else {
      chickenImage = await images.load('ChickBoy/ChikBoy_run.png');
    }
    chicken = Chicken(chickenImage, characterKey: selectedCharacter);
    if (selectedCharacter == 'classic' || selectedCharacter == 'black' || selectedCharacter == 'dark_brown') {
      chicken!.position = Vector2(32 + 24, size.y - 60 + 16);
      chicken!.yMax = chicken!.position.y;
    } else if (selectedCharacter == 'chickboy') {
      chicken!.position = Vector2(32, size.y - 48);
      chicken!.yMax = chicken!.position.y;
    }
    add(chicken!);
  }

  Future<void> saveSelectedLevel(String level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLevel', level);
    _selectedLevel = level;
  }

  Future<void> loadSelectedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedLevel = prefs.getString('selectedLevel') ?? 'easy';
    difficulty = _selectedLevel;
  }

  String get selectedLevel => _selectedLevel;

  Future<void> reloadParallax() async {
    // Remove the old parallax if it exists
    parallax?.removeFromParent();

    // Remove and re-add the chicken to ensure it is above the parallax
    chicken?.removeFromParent();

    // Get the selected background
    String background = 'PineForestParallax';
    if (buildContext != null) {
      await Provider.of<BackgroundProvider>(buildContext!, listen: false).loadBackground();
      background = Provider.of<BackgroundProvider>(buildContext!, listen: false).selectedBackground;
    } else {
      // Load directly from SharedPreferences if no context yet
      final prefs = await SharedPreferences.getInstance();
      background = prefs.getString('selectedBackground') ?? 'PineForestParallax';
    }
    // Adjust parallax speed for forest1
    double enemySpeedMultiplier = 1.0;
    if (background == 'forest1') {
      parallaxBaseVelocity = Vector2(36 * speedMultiplier, 0);
      velocityMultiplierDelta = Vector2(1.7, 0);
      enemySpeedMultiplier = 1.44;
    } else {
      parallaxBaseVelocity = Vector2(25 * speedMultiplier, 0);
      velocityMultiplierDelta = Vector2(1.4, 0);
      enemySpeedMultiplier = 1.0;
    }
    List<ParallaxImageData> parallaxLayers;
    if (background == 'PineForestParallax') {
      parallaxLayers = [
        ParallaxImageData('parallax/PineForestParallax/MorningLayer6.png'),
        ParallaxImageData('parallax/PineForestParallax/MorningLayer5.png'),
        ParallaxImageData('parallax/PineForestParallax/MorningLayer4.png'),
        ParallaxImageData('parallax/PineForestParallax/MorningLayer3.png'),
        ParallaxImageData('parallax/PineForestParallax/MorningLayer2.png'),
        ParallaxImageData('parallax/PineForestParallax/MorningLayer1.png'),
        ParallaxImageData('parallax/PineForestParallax/ground.png'),
      ];
    } else if (background == 'forest1') {
      parallaxLayers = [
        ParallaxImageData('parallax/forest1/[CelesteHa]ForestP-back.png'),
        ParallaxImageData('parallax/forest1/[CelesteHa]ForestP-middle.png'),
        ParallaxImageData('parallax/forest1/[CelesteHa]ForestP-front.png'),
        ParallaxImageData('parallax/forest1/[CelesteHa]ForestP-foreground.png'),
      ];
    } else if (background == 'classic') {
      parallaxLayers = [
        ParallaxImageData('parallax/plx-1.png'),
        ParallaxImageData('parallax/plx-2.png'),
        ParallaxImageData('parallax/plx-3.png'),
        ParallaxImageData('parallax/plx-4.png'),
        ParallaxImageData('parallax/plx-5.png'),
        ParallaxImageData('parallax/plx-6.png'),
      ];
    } else {
      parallaxLayers = [
        ParallaxImageData('parallax/PineForestParallax/MorningLayer6.png'),
        ParallaxImageData('parallax/PineForestParallax/MorningLayer5.png'),
        ParallaxImageData('parallax/PineForestParallax/MorningLayer4.png'),
        ParallaxImageData('parallax/PineForestParallax/MorningLayer3.png'),
        ParallaxImageData('parallax/PineForestParallax/MorningLayer2.png'),
        ParallaxImageData('parallax/PineForestParallax/MorningLayer1.png'),
        ParallaxImageData('parallax/PineForestParallax/ground.png'),
      ];
    }
    parallax = await loadParallaxComponent(
      parallaxLayers,
      baseVelocity: parallaxBaseVelocity,
      velocityMultiplierDelta: velocityMultiplierDelta,
      alignment: Alignment.bottomCenter,
    );
    parallax!.anchor = Anchor.topLeft;
    // Apply a y offset if forest1 is selected
    if (background == 'forest1') {
      parallax!.y -= 10; //(adjust as needed)
    }
    add(parallax!);

    // Re-add the chicken so it appears above the parallax
    if (chicken != null) {
      add(chicken!);
    }
    // Remove and re-add the scoreText so it appears above the parallax and chicken
    scoreText.removeFromParent();
    add(scoreText);
    // Adjust enemy speed if needed
    enemyManager?.setDifficulty(difficulty, enemySpeedMultiplier: enemySpeedMultiplier);
  }

  void handleAddButton() {
    // Example: Add an obstacle at a fixed position
    final obstacle = Obstacle(
      position: Vector2(size.x - 100, size.y - 60),
      size: Vector2(48, 48),
      speed: 200,
    );
    add(obstacle);
  }
}

class Obstacle extends PositionComponent with HasGameRef<AsianChickenGame>, CollisionCallbacks {
  double speed;
  Obstacle({required Vector2 position, required Vector2 size, required this.speed}) {
    this.position = position;
    this.size = size;
    anchor = Anchor.bottomLeft;
    debugMode = false;
  }

  @override
  Future<void> onLoad() async {
    // Use a simple colored box for now, or load a sprite if you have one
    add(RectangleHitbox());
    add(
      RectangleComponent(
        size: size,
        paint: Paint()..color = Colors.brown,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.isGameOver) return;
    x -= speed * dt;
    if (x < -size.x) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Chicken) {
      gameRef.gameOver();
    }
    super.onCollision(intersectionPoints, other);
  }
}
