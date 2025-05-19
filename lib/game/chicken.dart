import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import '../providers/music_provider.dart';

// Enum for chicken animation states
enum ChickenAnimationStates {
  idle,
  run,
  jump,
  hit,
}

class Chicken extends SpriteAnimationGroupComponent<ChickenAnimationStates>
    with CollisionCallbacks, HasGameRef<FlameGame> {
  final String characterKey;

  static final _animationMapChickBoy = {
    ChickenAnimationStates.idle: SpriteAnimationData.sequenced(
      amount: 10,
      stepTime: 0.12,
      textureSize: Vector2(32, 32),
      amountPerRow: 1,
    ),
    ChickenAnimationStates.run: SpriteAnimationData.sequenced(
      amount: 10,
      stepTime: 0.12,
      textureSize: Vector2(32, 32),
      amountPerRow: 1,
      texturePosition: Vector2(0, 0),
    ),
    ChickenAnimationStates.jump: SpriteAnimationData.sequenced(
      amount: 1,
      stepTime: 0.12,
      textureSize: Vector2(32, 32),
      amountPerRow: 1,
      texturePosition: Vector2(0, 0),
    ),
    ChickenAnimationStates.hit: SpriteAnimationData.sequenced(
      amount: 1,
      stepTime: 0.12,
      textureSize: Vector2(32, 32),
      amountPerRow: 1,
      texturePosition: Vector2(0, 0),
    ),
  };

  // For the classic sprite sheet (4x4 grid, 128x128, each frame 32x32)
  // Now, running animation is all columns of the last row (y=96)
  static final _animationMapClassic = {
    ChickenAnimationStates.idle: SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.12,
      textureSize: Vector2(32, 32),
      amountPerRow: 4,
      texturePosition: Vector2(0, 96), // last row (run)
    ),
    ChickenAnimationStates.run: SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.12,
      textureSize: Vector2(32, 32),
      amountPerRow: 4,
      texturePosition: Vector2(0, 96), // last row (run)
    ),
    ChickenAnimationStates.jump: SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.12,
      textureSize: Vector2(32, 32),
      amountPerRow: 4,
      texturePosition: Vector2(0, 96), // last row (run)
    ),
    ChickenAnimationStates.hit: SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.12,
      textureSize: Vector2(32, 32),
      amountPerRow: 4,
      texturePosition: Vector2(0, 96), // last row (run)
    ),
  };

  double yMax = 0.0;
  double speedY = 0.0;
  static const double gravity = 800;
  bool isHit = false;

  Chicken(Image image, {required this.characterKey})
      : super.fromFrameData(
          image,
          (characterKey == 'classic' || characterKey == 'black' || characterKey == 'dark_brown')
              ? _animationMapClassic
              : _animationMapChickBoy,
        ) {
    if (characterKey == 'classic' || characterKey == 'black' || characterKey == 'dark_brown') {
      size = Vector2(48, 48);
      anchor = Anchor.bottomCenter;
    } else {
      size = Vector2(64, 64);
      anchor = Anchor.bottomLeft;
    }
    debugMode = false; // Hide the hitbox for production
    print('Chicken created with characterKey: '
          '\u001b[33m$characterKey\u001b[0m, '
          'image size: \u001b[36m\u001b[1m\u001b[4m\u001b[7m'
          '\u001b[0m');
    print('Chicken image width: \u001b[32m\u001b[1m\u001b[4m\u001b[7m${image.width}\u001b[0m, height: \u001b[32m\u001b[1m\u001b[4m\u001b[7m${image.height}\u001b[0m');
    current = ChickenAnimationStates.run;
  }

  @override
  void onMount() {
    yMax = y;
    // Add a smaller hitbox (50% of size, centered)
    add(RectangleHitbox.relative(
      Vector2(0.5, 0.5),
      parentSize: size,
    ));
    super.onMount();
  }

  @override
  void update(double dt) {
    // Debug print for current animation state
    // print('Chicken animation state: $current');
    speedY += gravity * dt;
    y += speedY * dt;
    if (isOnGround) {
      y = yMax;
      speedY = 0.0;
      if (current != ChickenAnimationStates.hit && current != ChickenAnimationStates.run) {
        current = ChickenAnimationStates.run;
      }
    }
    super.update(dt);
  }

  bool get isOnGround => (y >= yMax);

  void jump() {
    if (isOnGround) {
      speedY = -450;
      current = ChickenAnimationStates.jump;
      // Only play jump sound if enabled in MusicProvider
      final context = (gameRef as dynamic).buildContext;
      bool playJump = true;
      if (context != null) {
        try {
          final provider = context.read<MusicProvider>();
          playJump = provider.jumpSoundEnabled;
        } catch (_) {}
      }
      if (playJump) {
        FlameAudio.play('jump14.wav');
      }
    }
  }

  void hit() {
    isHit = true;
    current = ChickenAnimationStates.hit;
    // Only play hit sound if enabled in MusicProvider
    final context = (gameRef as dynamic).buildContext;
    bool playSfx = true;
    if (context != null) {
      try {
        final provider = context.read<MusicProvider>();
        playSfx = provider.jumpSoundEnabled;
      } catch (_) {}
    }
    if (playSfx) {
      FlameAudio.play('hit.wav');
    }
  }

  void reset() {
    if (characterKey == 'classic' || characterKey == 'black' || characterKey == 'dark_brown') {
      anchor = Anchor.bottomCenter;
      position = Vector2(32 + 24, gameRef.size.y - 60 + 16); // move slightly under ground to hide extra pixels
      size = Vector2(48, 48);
      yMax = position.y;
    } else if (characterKey == 'chickboy') {
      anchor = Anchor.bottomLeft;
      position = Vector2(32, gameRef.size.y - 48); // feet on the ground
      size = Vector2(64, 64);
      yMax = position.y;
    }
    current = ChickenAnimationStates.run;
    isHit = false;
    speedY = 0.0;
  }

  void moveRight() {
    // Move right by 40 pixels, but not off the screen
    final maxX = gameRef.size.x - size.x;
    x = (x + 40).clamp(0, maxX);
  }

  void moveLeft() {
    // Move left by 40 pixels, but not off the screen
    x = (x - 40).clamp(0, gameRef.size.x - size.x);
  }

  void groundPound() {
    print('Ground pound activated!');
    if (!isOnGround) {
      y = yMax;
      speedY = 0.0;
      if (current != ChickenAnimationStates.hit) {
        current = ChickenAnimationStates.run;
      }
    }
  }
} 