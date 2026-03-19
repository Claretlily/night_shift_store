import 'dart:ui';

import 'package:flame/components.dart';
import 'package:night_shift_store/actor/player.dart';

class PlayerAnimation {
  static Map<PlayerState, SpriteAnimation> load(
    Image idleImage,
    Image runImage,
  ) {
    final frameSize = Vector2(32, 64);

    SpriteAnimation anim(int startFrame) {
      return SpriteAnimation.fromFrameData(
        idleImage,
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.15,
          textureSize: frameSize,
          texturePosition: Vector2(startFrame * 32, 0),
        ),
      );
    }

    SpriteAnimation run(int startColumn) {
      return SpriteAnimation.fromFrameData(
        runImage,
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: frameSize,
          texturePosition: Vector2(startColumn * 32, 0),
        ),
      );
    }

    return {
      PlayerState.idleRight: anim(0),
      PlayerState.idleUp: anim(6),
      PlayerState.idleLeft: anim(12),
      PlayerState.idleDown: anim(18),
      PlayerState.runRight: run(0),
      PlayerState.runUp: run(6),
      PlayerState.runLeft: run(12),
      PlayerState.runDown: run(18),
    };
  }
}
