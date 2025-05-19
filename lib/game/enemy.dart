import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '/models/enemy_data.dart';
import 'bracu_chicken_game.dart';
import 'chicken.dart';

// This represents an enemy in the game world.
class Enemy extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameReference<BracuChickenGame> {
  // The data required for creation of this enemy.
  final EnemyData enemyData;

  Enemy(this.enemyData) {
    if (enemyData.name == 'witch') {
      animation = SpriteAnimation.fromFrameData(
        enemyData.image,
        SpriteAnimationData.sequenced(
          amount: enemyData.nFrames,
          stepTime: enemyData.stepTime,
          textureSize: enemyData.textureSize,
          amountPerRow: 1, // vertical strip
        ),
      );
    } else if (enemyData.name == 'knight') {
      animation = SpriteAnimation.fromFrameData(
        enemyData.image,
        SpriteAnimationData.sequenced(
          amount: enemyData.nFrames,
          stepTime: enemyData.stepTime,
          textureSize: enemyData.textureSize,
          amountPerRow: 8,
        ),
      );
    } else {
      animation = SpriteAnimation.fromFrameData(
        enemyData.image,
        SpriteAnimationData.sequenced(
          amount: enemyData.nFrames,
          stepTime: enemyData.stepTime,
          textureSize: enemyData.textureSize,
        ),
      );
    }
  }

  @override
  void onMount() {
    // Reduce the size of enemy as they look too
    // big compared to the dino.
    size *= 0.6;

    // Add a more accurate hitbox for this enemy.
    // 70% width, 75% height, centered horizontally, bottom-aligned
    if (enemyData.name == 'cat_girl') {
      // For cat_girl, use a larger, more centered hitbox
      add(
        RectangleHitbox.relative(
          Vector2(0.9, 0.9),
          parentSize: size,
          position: Vector2(0.05, 0.05),
        ),
      );
    } else {
      add(
        RectangleHitbox.relative(
          Vector2(0.7, 0.75),
          parentSize: size,
          position: Vector2(0.15, 0.25),
        ),
      );
    }
    super.onMount();
  }

  @override
  void update(double dt) {
    position.x -= enemyData.speedX * dt;

    // Remove the enemy if it has gone past left end of the screen.
    if (position.x < -enemyData.textureSize.x) {
      removeFromParent();
    }

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Chicken) {
      game.gameOver();
    }
    super.onCollision(intersectionPoints, other);
  }
}
