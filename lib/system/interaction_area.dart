import 'package:flame/components.dart';

class InteractionArea {
  final Vector2 position;
  final Vector2 size;
  final String action;

  InteractionArea({
    required this.position,
    required this.action,
    required this.size,
  });

  bool contain(Vector2 point) {
    return point.x > position.x &&
        point.x < position.x + size.x &&
        point.y > position.y &&
        point.y < position.y + size.y;
  }
}
