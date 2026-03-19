import 'package:flutter/material.dart';
import 'package:night_shift_store/util/dialogue_box.dart';
import '../night_shift.dart';
import 'dialogue_loader.dart';
import 'dialogue_template.dart';

class IntroDialogue extends StatefulWidget {
  final NightShift game;

  const IntroDialogue({super.key, required this.game});

  @override
  State<IntroDialogue> createState() => _IntroDialogueState();
}

class _IntroDialogueState extends State<IntroDialogue> {
  List<DialogueLine> dialogue = [];
  int currentIndex = 0;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadIntroDialogue();
  }

  Future<void> loadIntroDialogue() async {
    dialogue = await loadDialogue("intro");

    setState(() {
      isLoaded = true;
    });
  }

  void nextDialogue() {
    if (currentIndex < dialogue.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      widget.game.overlays.remove('IntroDialogue');
      //widget.game.startClockInObjective();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) return const SizedBox();

    final line = dialogue[currentIndex];

    return DialogueBox(line: line, onNext: nextDialogue);
  }
}
