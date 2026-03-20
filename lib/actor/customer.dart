import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:night_shift_store/night_shift.dart';

enum CustomerState {
  idleDown,
  idleUp,
  idleLeft,
  idleRight,
  runDown,
  runUp,
  runLeft,
  runRight,
}

enum CustomerBehavior { walking, shopping, goingToCheckout, checkedOut }

class Customer extends SpriteAnimationGroupComponent<CustomerState>
    with HasGameReference<NightShift> {
  final String idleSheet;
  final String runSheet;
  final String bubbleKey;
  final double moveSpeed = 80;

  CustomerBehavior behavior = CustomerBehavior.walking;
  bool _speechVisible = false;
  double _speechTimer = 0;
  double _shopTimer = 0;
  final double _shopDuration = 4.0;
  int _shelvesVisited = 0;
  final int _maxShelves = 2;
  late TextComponent _bubble;

  // waypoint queue
  List<Vector2> _path = [];
  bool _hasTarget = false;
  Vector2 _target = Vector2.zero();

  Customer({
    required Vector2 position,
    required this.idleSheet,
    required this.runSheet,
    required this.bubbleKey,
  }) : super(position: position, size: Vector2(32, 64), anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() {
    _loadAnimations();
    current = CustomerState.idleDown;

    _bubble = TextComponent(
      text: '...',
      position: Vector2(16, -8),
      anchor: Anchor.bottomCenter,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFF000000),
          fontSize: 10,
          backgroundColor: Color(0xFFFFFFFF),
        ),
      ),
    );
    return super.onLoad();
  }

  void _loadAnimations() {
    final idleImg = game.images.fromCache(idleSheet);
    final runImg = game.images.fromCache(runSheet);
    final frameSize = Vector2(32, 64);

    SpriteAnimation idle(int startFrame) => SpriteAnimation.fromFrameData(
      idleImg,
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.15,
        textureSize: frameSize,
        texturePosition: Vector2(startFrame * 32, 0),
      ),
    );

    SpriteAnimation run(int startFrame) => SpriteAnimation.fromFrameData(
      runImg,
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.1,
        textureSize: frameSize,
        texturePosition: Vector2(startFrame * 32, 0),
      ),
    );

    animations = {
      CustomerState.idleRight: idle(0),
      CustomerState.idleUp: idle(6),
      CustomerState.idleLeft: idle(12),
      CustomerState.idleDown: idle(18),
      CustomerState.runRight: run(0),
      CustomerState.runUp: run(6),
      CustomerState.runLeft: run(12),
      CustomerState.runDown: run(18),
    };
  }

  void _nextWaypoint() {
    if (_path.isEmpty) {
      _hasTarget = false;
      return;
    }
    _target = _path.removeAt(0);
    _hasTarget = true;
  }

  void goShop() {
    final restocked = game.interactions
        .where((i) => i.action == 'Restock')
        .toList();
    if (restocked.isEmpty) return;

    // Pick random aisle to stand in
    final aisleX = [
      929.0,
      966.0,
      1035.0,
      1129.0,
      1202.0,
      1353.0,
    ][Random().nextInt(6)];

    _path = [
      ...game.npcShoppingPath,
      Vector2(aisleX, 580), // final shelf position
    ];
    behavior = CustomerBehavior.walking;
    _nextWaypoint();
  }

  void goToCheckout() {
    behavior = CustomerBehavior.goingToCheckout;
    _path = [...game.npcCheckoutPath, game.checkoutPoint];
    _nextWaypoint();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Speech bubble countdown
    if (_speechVisible) {
      _speechTimer -= dt;
      if (_speechTimer <= 0) {
        _speechVisible = false;
        if (_bubble.isMounted) remove(_bubble);
        _shelvesVisited++;
        if (_shelvesVisited >= _maxShelves) {
          goToCheckout();
        } else {
          goShop();
        }
      }
      return;
    }

    // Shopping timer
    if (behavior == CustomerBehavior.shopping) {
      _shopTimer -= dt;
      if (_shopTimer <= 0 && !_speechVisible) {
        _speechVisible = true;
        _speechTimer = 2.0;
        if (!_bubble.isMounted) add(_bubble);
      }
      return;
    }

    if (!_hasTarget) return;

    final diff = _target - position;

    // Reached current waypoint
    if (diff.length < 16) {
      position.setFrom(_target);
      _nextWaypoint();

      // If no more waypoints, we arrived at final destination
      if (!_hasTarget) {
        if (behavior == CustomerBehavior.walking) {
          behavior = CustomerBehavior.shopping;
          _shopTimer = _shopDuration;
          current = CustomerState.idleDown;
        } else if (behavior == CustomerBehavior.goingToCheckout) {
          behavior = CustomerBehavior.checkedOut;
          current = CustomerState.idleDown;
          game.triggerCheckout(this);
        }
      }
      return;
    }

    // Move
    final dir = diff.normalized();
    position += dir * moveSpeed * dt;

    // Animation
    if (diff.x.abs() > diff.y.abs()) {
      current = diff.x > 0 ? CustomerState.runRight : CustomerState.runLeft;
    } else {
      current = diff.y > 0 ? CustomerState.runDown : CustomerState.runUp;
    }
  }
}
