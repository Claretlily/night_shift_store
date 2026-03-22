import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:night_shift_store/dialogues/checkout_dialogue.dart';
import 'package:night_shift_store/dialogues/clockin_dialogue.dart';
import 'package:night_shift_store/dialogues/opening_time_dialogue.dart';
import 'package:night_shift_store/dialogues/startshift_dialogue.dart';
import 'package:night_shift_store/night_shift.dart';
import 'package:night_shift_store/dialogues/intro_dialogue.dart';
import 'package:night_shift_store/util/end_screen.dart';
import 'package:night_shift_store/util/interact_prompt.dart';
import 'package:night_shift_store/util/restock_progress.dart';
import 'package:night_shift_store/util/sales_task_panel.dart';
import 'package:night_shift_store/util/shift_completed.dart';
import 'package:night_shift_store/util/task_panel.dart';
import 'package:night_shift_store/util/title_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  //Flame.device.setLandscape();
  runApp(const NightShiftApp());
}

class NightShiftApp extends StatefulWidget {
  const NightShiftApp({super.key});

  @override
  State<NightShiftApp> createState() => _NightShiftAppState();
}

class _NightShiftAppState extends State<NightShiftApp> {
  String _screen = 'title';
  NightShift? _game;

  void _startGame() {
    setState(() {
      _game = NightShift(onGameEnd: _showEndScreen);
      _screen = 'game';
    });
  }

  void _showEndScreen() {
    setState(() => _screen = 'end');
  }

  void _restart() {
    setState(() {
      _game = null;
      _screen = 'title';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_screen == 'title') {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TitleOverlay(onStart: _startGame),
      );
    }

    if (_screen == 'end') {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: EndScreen(onRestart: _restart),
      );
    }

    final game = _game!;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget(
          game: kDebugMode ? NightShift(onGameEnd: _showEndScreen) : game,
          overlayBuilderMap: {
            'IntroDialogue': (context, NightShift game) =>
                IntroDialogue(game: game),
            'ClockInDialogue': (context, NightShift game) =>
                ClockInDialogue(game: game),
            'StartshiftDialogue': (context, NightShift game) =>
                StartshiftDialogue(game: game),
            'OpeningTimeDialogue': (context, NightShift game) =>
                OpeningTimeDialogue(game: game),
            'InteractPrompt': (context, NightShift game) =>
                InteractPrompt(game: game),
            'RestockProgress': (context, NightShift game) =>
                RestockProgress(game: game),
            'TaskPanel': (context, NightShift game) => TaskPanel(game: game),
            'SalesTaskPanel': (context, NightShift game) =>
                SalesTaskPanel(game: game),
            'CheckoutDialogue': (context, NightShift game) =>
                CheckoutDialogue(game: game),
            'ShiftComplete': (context, NightShift game) =>
                ShiftCompleted(game: game),
          },
        ),
      ),
    );
  }
}
