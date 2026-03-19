import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:night_shift_store/actor/player.dart';
import 'package:night_shift_store/system/interaction_area.dart';
import 'package:night_shift_store/system/restock_shelf.dart';
import 'package:collection/collection.dart';

class NightShift extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late TiledComponent mapComponent;
  List<RestockTask> restockTasks = [];
  List<InteractionArea> interactions = [];
  InteractionArea? currentInteraction;
  int get completedTaskCount => restockTasks.where((t) => t.isCompleted).length;
  bool get allTaskDone =>
      restockTasks.isNotEmpty && restockTasks.every((t) => t.isCompleted);
  bool shiftStarted = false;
  bool isHoldingInteract = false;
  double interactProgress = 0;
  double interactTime = 2.0;
  String interactText = "";
  late Player player;

  @override
  Future<void> onLoad() async {
    //debugMode = true;
    await super.onLoad();
    // Loading all images into cache
    await images.loadAllImages();
    final world = World();
    add(world);

    mapComponent = await TiledComponent.load(
      'grocery-store.tmx',
      Vector2.all(32),
      atlasMaxX: 8192,
      atlasMaxY: 8192,
    );
    world.add(mapComponent);

    final interactionLayer = mapComponent.tileMap.getLayer<ObjectGroup>(
      'Interactions',
    );
    if (interactionLayer != null) {
      for (final obj in interactionLayer.objects) {
        final action = obj.properties.getValue('action');

        if (action != null) {
          interactions.add(
            InteractionArea(
              position: Vector2(obj.x, obj.y),
              action: action,
              size: Vector2(obj.width, obj.height),
            ),
          );
        }
      }
    }

    restockTasks = interactions
        .where((i) => i.action == 'Restock')
        .mapIndexed((index, i) => RestockTask(shelfID: 'Shelf ${index + 1}'))
        .toList();

    player = Player();
    player.position = Vector2(400, 100);
    world.add(player);

    //Adding camera to follow when the player moves
    camera = CameraComponent(world: world);
    camera.viewfinder.anchor = Anchor.center;
    add(camera);

    camera.follow(player);
    overlays.add('IntroDialogue');

    //Adding collisions so that the user won't walk through objects
    final collisionLayer = mapComponent.tileMap.getLayer<ObjectGroup>(
      'Collisions',
    );
    if (collisionLayer != null) {
      for (final obj in collisionLayer.objects) {
        final hitbox = PositionComponent(
          position: Vector2(obj.x, obj.y),
          size: Vector2(obj.width, obj.height),
        );
        hitbox.add(RectangleHitbox()..collisionType = CollisionType.passive);

        world.add(hitbox);
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    checkInteractions();

    if (isHoldingInteract && currentInteraction?.action == 'Restock') {
      interactProgress += dt;

      if (!overlays.isActive('RestockProgress')) {
        overlays.add('RestockProgress');
      }
      if (interactProgress >= interactTime) {
        startRestock();
        interactProgress = 0;
        isHoldingInteract = false;

        overlays.remove('RestockProgress');
      }
    }
  }

  void startRestock() {
    final index = interactions
        .where((i) => i.action == 'Restock')
        .toList()
        .indexOf(currentInteraction!);
    if (index != -1 && !restockTasks[index].isCompleted) {
      restockTasks[index].isCompleted = true;

      if (overlays.isActive('TaskPanel')) {
        overlays.remove('TaskPanel');
        overlays.add('TaskPanel');
      }
      if (allTaskDone) {
        overlays.remove('TaskPanel');
        overlays.add('ShiftCompleted');
      }
    }
    if (kDebugMode) {
      print('Restocking...');
    }
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    super.onKeyEvent(event, keysPressed);
    if (event.logicalKey == LogicalKeyboardKey.keyE) {
      if (event is KeyDownEvent) {
        final action = currentInteraction?.action;
        if (action == 'Clock In' && !shiftStarted) {
          if (!overlays.isActive('ClockInDialogue')) {
            overlays.add('ClockInDialogue');
          }
        }
        if (action == 'Restock' && shiftStarted) {
          isHoldingInteract = true;
        }
      }
      if (event is KeyUpEvent) {
        isHoldingInteract = false;
        interactProgress = 0;

        if (overlays.isActive('RestockProgress')) {
          overlays.remove('RestockProgress');
        }
      }
    }
    return KeyEventResult.handled;
  }

  //When the cashier is in Cashier zone, it will prompt the user to clock in
  void checkInteractions() {
    final playerPosition = player.center;
    InteractionArea? closest;
    double closestDistance = double.infinity;

    for (final area in interactions) {
      if (area.contain(playerPosition)) {
        final center = area.position + (area.size / 2);
        final distance = playerPosition.distanceTo(center);

        if (distance < closestDistance) {
          closestDistance = distance;
          closest = area;
        }
      }
    }

    currentInteraction = closest;
    bool show = false;
    if (currentInteraction != null) {
      final action = currentInteraction!.action;

      if (action == 'Clock In' && !shiftStarted) {
        interactText = 'Clock In';
        show = true;
      } else if (action == 'Restock' && shiftStarted) {
        interactText = 'Restock';
        show = true;
      }
    }
    if (show) {
      if (!overlays.isActive('InteractPrompt')) {
        overlays.add('InteractPrompt');
      } else {
        if (overlays.isActive('InteractPrompt')) {
          overlays.remove('InteractPrompt');
        }
      }
    }
  }
}
