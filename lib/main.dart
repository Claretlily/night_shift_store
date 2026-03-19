import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:night_shift_store/dialogues/clockin_dialogue.dart';
import 'package:night_shift_store/dialogues/opening_time_dialogue.dart';
import 'package:night_shift_store/dialogues/startshift_dialogue.dart';
import 'package:night_shift_store/night_shift.dart';
import 'package:night_shift_store/dialogues/intro_dialogue.dart';
import 'package:night_shift_store/util/interact_prompt.dart';
import 'package:night_shift_store/util/restock_progress.dart';
import 'package:night_shift_store/util/sales_task_panel.dart';
import 'package:night_shift_store/util/shift_completed.dart';
import 'package:night_shift_store/util/task_panel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  final game = NightShift();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget(
          game: kDebugMode ? NightShift() : game,
          overlayBuilderMap: {
            'IntroDialogue': (context, NightShift game) {
              return IntroDialogue(game: game);
            },
            'ClockInDialogue': (context, NightShift game) {
              return ClockInDialogue(game: game);
            },
            'StartshiftDialogue': (context, NightShift game) {
              return StartshiftDialogue(game: game);
            },
            'InteractPrompt': (context, NightShift game) {
              return InteractPrompt(game: game);
            },
            'RestockProgress': (context, NightShift game) {
              return RestockProgress(game: game);
            },
            'TaskPanel': (context, NightShift game) {
              return TaskPanel(game: game);
            },
            'ShiftComplete': (context, NightShift game) {
              return ShiftCompleted(game: game);
            },
            'OpeningTimeDialogue': (context, NightShift game) {
              return OpeningTimeDialogue(game: game);
            },
            'SalesTaskPanel': (context, NightShift game) {
              return SalesTaskPanel(game: game);
            },
            'CheckoutDialogue': (context, NightShift game) {
              return const SizedBox();
            },
          },
        ),
      ),
    ),
  );
}
