import 'package:flame/game.dart';

class TitleScreen extends FlameGame {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    overlays.add('TitleOverlay');
  }
}
