import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:night_shift_store/actor/player_animation.dart';
import 'package:night_shift_store/night_shift.dart';

enum PlayerState {
  idleDown,
  idleUp,
  idleLeft,
  idleRight,
  runDown,
  runUp,
  runLeft,
  runRight,
}

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameReference<NightShift>, KeyboardHandler, CollisionCallbacks {
  late final SpriteAnimation idleAnimation;
  final double stepTime = 0.05;
  final double moveSpeed = 200;
  Vector2 previousPosition = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  PlayerState lastDirection = PlayerState.idleDown;

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    velocity = Vector2.zero();

    if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      velocity.x = -1;
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      velocity.x = 1;
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      velocity.y = -1;
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      velocity.y = 1;
    }
    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is! Player) {
      position.setFrom(previousPosition);
    }
  }

  @override
  void update(double dt) {
    previousPosition = position.clone();
    if (velocity.length > 0) {
      position += velocity.normalized() * moveSpeed * dt;
    }
    super.update(dt);
    PlayerState newState = lastDirection;
    if (velocity.y != 0) {
      if (velocity.y > 0) {
        newState = PlayerState.runDown;
        lastDirection = PlayerState.idleDown;
      } else {
        newState = PlayerState.runUp;
        lastDirection = PlayerState.idleUp;
      }
    } else if (velocity.x != 0) {
      if (velocity.x > 0) {
        newState = PlayerState.runRight;
        lastDirection = PlayerState.idleRight;
      } else {
        newState = PlayerState.runLeft;
        lastDirection = PlayerState.idleLeft;
      }
    } else {
      newState = lastDirection;
    }
    if (current != newState) {
      current = newState;
    }
  }

  @override
  FutureOr<void> onLoad() {
    size = Vector2(32, 64);
    anchor = Anchor.center;
    add(
      RectangleHitbox(size: Vector2(20, 20), position: Vector2(10, 20))
        ..collisionType = CollisionType.active,
    );
    _loadAllAnimations();
    return super.onLoad();
  }

  void _loadAllAnimations() {
    final idleImage = game.images.fromCache(
      '2_Characters/Old/Single_Characters_Legacy/32x32/Dan_idle_anim_32x32.png',
    );
    final runImage = game.images.fromCache(
      '2_Characters/Old/Single_Characters_Legacy/32x32/Dan_run_32x32.png',
    );
    animations = PlayerAnimation.load(idleImage, runImage);
    current = PlayerState.idleDown;
  }
}
