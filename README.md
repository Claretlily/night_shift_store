# NightShift
#### Video Demo: <URL HERE>
#### Description:

NightShift is a 2D top-down grocery store simulation game built with Flutter and the Flame game engine. You play as Dan, a worker assigned to the late night shift at a grocery store. The store feels a little too quiet. The customers feel a little too strange. But the shelves still need restocking, and the till still needs manning.

## How to Play

To start, press START on the title screen. Use W/A/S/D or arrow keys to move Dan around the store. Press E to interact with objects and zones. Hold E near a shelf to restock it — a progress bar shows your progress.

The game follows this flow: first, walk to the cashier register and press E to clock in and start your shift. Then walk to each shelf in the store and hold E to restock them all. Once every shelf is restocked, the store opens for business. Two customers — Adam and Alex — will enter the store, browse the shelves, and make their way to the checkout counter. Walk to the cashier register and press E when a customer is waiting to serve them. Each customer has a brief conversation with Dan during checkout. Once both customers have been served, your shift is complete.

## Files

- `night_shift.dart` — The main game class. Handles game state, player interaction detection, restock logic, customer spawning, checkout queue, and the overall game loop.
- `player.dart` — The player character Dan. Handles keyboard input, movement, animation states, and collision detection.
- `player_animation.dart` — Loads and maps Dan's sprite sheet into directional idle and run animations.
- `customer.dart` — The NPC customer class. Handles waypoint-based pathfinding, shopping behaviour, speech bubbles, and checkout triggering.
- `interaction_area.dart` — Represents an interaction zone loaded from the Tiled map. Contains the contain() method for checking if the player is inside the zone.
- `restock_shelf.dart` — The data model for a restock task, tracking shelf ID and completion status.
- `dialogue_loader.dart` — Loads dialogue lines from the JSON file by key.
- `dialogue_template.dart` — The DialogueLine data model parsed from JSON.
- `intro_dialogue.dart` — The opening dialogue shown when the game starts.
- `clockin_dialogue.dart` — The confirmation dialogue shown when Dan clocks in.
- `startshift_dialogue.dart` — The dialogue shown after clocking in.
- `opening_time_dialogue.dart` — The dialogue shown when all shelves are restocked and the store opens.
- `checkout_dialogue.dart` — The checkout dialogue between Dan and each customer. Picks different dialogue depending on which customer is checking out.
- `game_dialogues.json` — All game dialogue stored as JSON, keyed by dialogue name.
- `task_panel.dart` — The HUD overlay showing the restock task list and progress bar.
- `sales_task_panel.dart` — The HUD overlay showing the sales quota during the customer phase.
- `interact_prompt.dart` — The on-screen prompt showing the player what E will do in the current zone.
- `restock_progress.dart` — The progress bar shown while holding E to restock a shelf.
- `shift_completed.dart` — The shift complete screen shown after serving all customers.
- `title_overlay.dart` — The title screen shown when the game first launches.
- `end_screen.dart` — The end screen shown after completing the shift.
- `grocery-store.tmx` — The Tiled map file for the grocery store, including tile layers, collision objects, and interaction zones.

## Design Choices

I chose Flutter and Flame because I wanted to build a game that runs on both mobile and desktop. Flutter handles all the UI overlays like dialogue boxes and task panels, while Flame handles the game world, sprites, and game loop. Having both in one project meant I could use proper Flutter widgets for text-heavy UI rather than drawing everything on a canvas.

All game dialogue is stored in a single JSON file rather than hardcoded in Dart. This made it easy to write and edit dialogue without touching code, and keeps content separate from logic.

Interaction zones are defined in Tiled as objects with a custom action property. This meant I could design the whole interaction system visually in Tiled and have the game read it automatically at load time, rather than hardcoding positions in code.

The task panel uses a ValueNotifier to trigger UI rebuilds when a shelf is restocked, rather than removing and re-adding the overlay. This avoids a freeze bug that occurred when toggling overlays rapidly during gameplay.

NPC customers follow a waypoint path rather than using collision-based pathfinding. After attempting collision-aware movement, the waypoint approach proved more reliable and predictable for the scope of this project. NPCs do not collide with world objects — they follow a fixed corridor route through the store.

The checkout system uses a queue. When an NPC reaches the checkout zone it is added to a list. If no customer is currently being served, the next customer in the queue becomes active immediately. This handles the case where both customers arrive at checkout at the same time without breaking the dialogue flow.