import 'dart:math';

import 'package:flame/components.dart';

import '/game/enemy.dart';
import '/models/enemy_data.dart';
import 'asian_chicken_game.dart';

// This class is responsible for spawning random enemies at certain
// interval of time depending upon players current score.
class EnemyManager extends Component with HasGameReference<AsianChickenGame> {
  // A list to hold data for all the enemies.
  final List<EnemyData> _data = [];

  // Random generator required for randomly selecting enemy type.
  final Random _random = Random();

  // Timer to decide when to spawn next enemy.
  late Timer _timer;
  double _minInterval = 1.0;
  double _maxInterval = 1.5;
  double _enemySpeedMultiplier = 1.0;

  EnemyManager() {
    _timer = Timer(_minInterval, repeat: false, onTick: spawnRandomEnemy);
  }

  void setDifficulty(String difficulty, {double enemySpeedMultiplier = 1.0}) {
    _enemySpeedMultiplier = enemySpeedMultiplier;
    // Adjust spawn interval based on difficulty
    if (difficulty == 'easy') {
      _minInterval = 1.2;
      _maxInterval = 2.0;
    } else if (difficulty == 'medium') {
      _minInterval = 0.9;
      _maxInterval = 1.5;
    } else if (difficulty == 'hard') {
      _minInterval = 0.6;
      _maxInterval = 1.1;
    } else if (difficulty == 'asia') {
      _minInterval = 0.4;
      _maxInterval = 0.8;
    } else {
      _minInterval = 1.0;
      _maxInterval = 1.5;
    }
    _timer.stop();
    _timer = Timer(_randomInterval(), repeat: false, onTick: spawnRandomEnemy);
    _timer.start();
  }

  double _randomInterval() {
    return _minInterval + _random.nextDouble() * (_maxInterval - _minInterval);
  }

  // This method is responsible for spawning a random enemy.
  void spawnRandomEnemy() {
    /// Generate a random index within [_data] and get an [EnemyData].
    final randomIndex = _random.nextInt(_data.length);
    final baseData = _data.elementAt(randomIndex);

    // Adjust enemy speed based on game speedMultiplier
    final gameSpeed = game.speedMultiplier;
    final enemyData = EnemyData(
      name: baseData.name,
      image: baseData.image,
      nFrames: baseData.nFrames,
      stepTime: baseData.stepTime,
      textureSize: baseData.textureSize,
      speedX: baseData.speedX * gameSpeed * _enemySpeedMultiplier,
      canFly: baseData.canFly,
    );
    final enemy = Enemy(enemyData);

    // Randomly scale enemy size between 1.0x and 1.5x
    double scale = 1.0 + _random.nextDouble() * 0.5;
    // Make cat_girl and witch enemies bigger and on the ground
    if (enemyData.name == 'cat_girl' || enemyData.name == 'witch') {
      scale = 1.5 + _random.nextDouble() * 0.3; // 1.5x to 1.8x
      enemy.size = enemyData.textureSize * scale;
      enemy.anchor = Anchor.bottomLeft;
      enemy.position.y = game.size.y - 48 + 60; // Place even lower to ground
    } else {
      enemy.size = enemyData.textureSize * scale;
    }

    // Help in setting all enemies on ground.
    enemy.anchor = Anchor.bottomLeft;
    enemy.position = Vector2(
      game.size.x - 100,
      game.size.y - 60,
    );

    // If this enemy can fly, set its y position randomly.
    if (enemyData.canFly) {
      // Place bat at a random height between 1/4 and 3/4 of the screen height
      enemy.position.y = game.size.y * (0.25 + _random.nextDouble() * 0.5);
    }

    // Due to the size of our viewport, we can
    // use textureSize as size for the components.
    game.add(enemy);

    // After spawning, randomize the next interval and restart timer
    _timer.stop();
    _timer = Timer(_randomInterval(), repeat: false, onTick: spawnRandomEnemy);
    _timer.start();
  }

  @override
  void onMount() {
    if (isMounted) {
      removeFromParent();
    }

    // Don't fill list again and again on every mount.
    if (_data.isEmpty) {
      // As soon as this component is mounted, initilize all the data.
      _data.addAll([
        EnemyData(
          name: 'witch',
          image: game.images.fromCache('witch/B_witch_run.png'),
          nFrames: 8,
          stepTime: 0.12,
          textureSize: Vector2(32, 48),
          speedX: 200,
          canFly: false,
        ),
        EnemyData(
          name: 'bat',
          image: game.images.fromCache('Bat/Flying (46x30).png'),
          nFrames: 7,
          stepTime: 0.1,
          textureSize: Vector2(46, 30),
          speedX: 250,
          canFly: true,
        ),
        EnemyData(
          name: 'cat_girl',
          image: game.images.fromCache('cat_girl/cat_Run.png'),
          nFrames: 8,
          stepTime: 0.09,
          textureSize: Vector2(48, 40),
          speedX: 375,
          canFly: false,
        ),
      ]);
    }
    setDifficulty(game.difficulty);
    super.onMount();
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    super.update(dt);
  }

  void removeAllEnemies() {
    final enemies = game.children.whereType<Enemy>();
    for (var enemy in enemies) {
      enemy.removeFromParent();
    }
  }
}
