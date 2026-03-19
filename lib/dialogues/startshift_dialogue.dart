import 'package:flutter/material.dart';
import 'package:night_shift_store/dialogues/dialogue_loader.dart';
import 'package:night_shift_store/dialogues/dialogue_template.dart';
import 'package:night_shift_store/night_shift.dart';
import 'package:night_shift_store/util/dialogue_box.dart';

class StartshiftDialogue extends StatefulWidget {
  final NightShift game;
  const StartshiftDialogue({super.key, required this.game});

  @override
  State<StartshiftDialogue> createState() => _StartshiftDialogueState();
}

class _StartshiftDialogueState extends State<StartshiftDialogue> {
  List<DialogueLine> dialogue = [];
  int index = 0;

  @override
  void initState() {
    super.initState();
    loadStartShiftDialogue();
  }

  Future<void> loadStartShiftDialogue() async {
    dialogue = await loadDialogue("start_shift");
    setState(() {});
  }

  void nextLine() {
    if (index < dialogue.length - 1) {
      setState(() {
        index++;
      });
    } else {
      widget.game.overlays.remove(
        'StartshiftDialogue',
      ); //Closing Dialogue When Finished Loading
    }
  }

  @override
  Widget build(BuildContext context) {
    if (dialogue.isEmpty) {
      return const SizedBox();
    }
    final line = dialogue[index];
    return DialogueBox(line: line, onNext: nextLine);
  }
}
