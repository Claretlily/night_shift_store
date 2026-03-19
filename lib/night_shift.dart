import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:night_shift_store/actor/customer.dart';
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
  Customer? activeCheckoutCustomer;

  int itemsSold = 0;
  int itemQuota = 2;
  bool shiftStarted = false;
  bool isHoldingInteract = false;
  double interactProgress = 0;
  double interactTime = 2.0;
  String interactText = '';

  Vector2 spawnPoint = Vector2.zero();
  Vector2 checkoutPoint = Vector2.zero();

  List<Vector2> get npcShoppingPath => [
    Vector2(397, 332), // down from spawn
    Vector2(897, 332), // bottom of left section
    Vector2(918, 719), // bottom corridor rightward
    Vector2(901, 410), // up into first aisle
    Vector2(461, 410),
  ];

  List<Vector2> get npcCheckoutPath => [
    Vector2(891, 410), // back down to corridor
    Vector2(891, 934), // right along bottom
    Vector2(1544, 934), // up to cashier
    Vector2(1544, 574),
  ];

  final restockNotifier = ValueNotifier<int>(0);
  final salesNotifier = ValueNotifier<int>(0);

  late Player player;

  int get completedTaskCount => restockTasks.where((t) => t.isCompleted).length;
  bool get allTaskDone =>
      restockTasks.isNotEmpty && restockTasks.every((t) => t.isCompleted);
  bool get quotaMet => itemsSold >= itemQuota;

  @override
  Future<void> onLoad() async {
    //debugMode = true;
    await super.onLoad();
    await images.loadAllImages();

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
        if (action == null) continue;

        if (action == 'Spawn') {
          spawnPoint = Vector2(obj.x, obj.y);
        } else if (action == 'Check_Out') {
          checkoutPoint = Vector2(obj.x, obj.y);
        } else {
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

    camera = CameraComponent(world: world);
    camera.viewfinder.anchor = Anchor.center;
    add(camera);
    camera.follow(player);

    overlays.add('IntroDialogue');

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
    final restockInteractions = interactions
        .where((i) => i.action == 'Restock')
        .toList();
    final index = restockInteractions.indexOf(currentInteraction!);

    if (index != -1 &&
        index < restockTasks.length &&
        !restockTasks[index].isCompleted) {
      restockTasks[index].isCompleted = true;
      restockNotifier.value++;

      if (allTaskDone) {
        overlays.remove('TaskPanel');
        overlays.add('OpeningTimeDialogue');
      }
    }
  }

  void startCustomerPhase() {
    itemsSold = 0;
    overlays.add('SalesTaskPanel');
    spawnCustomers();
  }

  void spawnCustomers() {
    final adam = Customer(
      position: spawnPoint.clone(),
      idleSheet:
          '2_Characters/Old/Single_Characters_Legacy/32x32/Adam_idle_anim_32x32.png',
      runSheet:
          '2_Characters/Old/Single_Characters_Legacy/32x32/Adam_run_32x32.png',
      bubbleKey: 'BubbleAdam',
    );
    world.add(adam);
    Future.delayed(const Duration(seconds: 1), () => adam.goShop());

    Future.delayed(const Duration(seconds: 5), () {
      final alex = Customer(
        position: spawnPoint.clone(),
        idleSheet:
            '2_Characters/Old/Single_Characters_Legacy/32x32/Alex_idle_anim_32x32.png',
        runSheet:
            '2_Characters/Old/Single_Characters_Legacy/32x32/Alex_run_32x32.png',
        bubbleKey: 'BubbleAlex',
      );
      world.add(alex);
      Future.delayed(const Duration(seconds: 1), () => alex.goShop());
    });
  }

  void triggerCheckout(Customer customer) {
    // Don't show dialogue immediately — wait for Dan to press E
    activeCheckoutCustomer = customer;
    // Optional: show a notification that a customer is waiting
  }

  void onItemSold() {
    itemsSold++;
    salesNotifier.value++;
    if (quotaMet) {
      overlays.remove('SalesTaskPanel');
      overlays.add('ShiftComplete');
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

        if (action == 'Clock In') {
          if (!shiftStarted) {
            if (!overlays.isActive('ClockInDialogue')) {
              overlays.add('ClockInDialogue');
            }
          } else if (shiftStarted &&
              activeCheckoutCustomer != null &&
              !overlays.isActive('CheckoutDialogue')) {
            overlays.add('CheckoutDialogue');
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
      } else if (action == 'Clock In' &&
          shiftStarted &&
          activeCheckoutCustomer != null) {
        // Dan is at cashier and customer is waiting
        interactText = 'Checkout';
        show = true;
      } else if (action == 'Restock' && shiftStarted) {
        interactText = 'Restock';
        show = true;
      }
    }

    if (show) {
      if (!overlays.isActive('InteractPrompt')) overlays.add('InteractPrompt');
    } else {
      if (overlays.isActive('InteractPrompt')) {
        overlays.remove('InteractPrompt');
      }
    }
  }
}
