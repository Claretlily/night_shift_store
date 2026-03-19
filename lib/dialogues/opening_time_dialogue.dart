import 'package:flutter/material.dart';
import 'package:night_shift_store/dialogues/dialogue_loader.dart';
import 'package:night_shift_store/dialogues/dialogue_template.dart';
import 'package:night_shift_store/night_shift.dart';
import 'package:night_shift_store/util/dialogue_box.dart';

class OpeningTimeDialogue extends StatefulWidget {
  final NightShift game;
  const OpeningTimeDialogue({super.key, required this.game});

  @override
  State<OpeningTimeDialogue> createState() => _OpeningTimeDialogueState();
}

class _OpeningTimeDialogueState extends State<OpeningTimeDialogue> {
  List<DialogueLine> dialogue = [];
  int index = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    dialogue = await loadDialogue('opening_time');
    setState(() {});
  }

  void _next() {
    if (index < dialogue.length - 1) {
      setState(() => index++);
    } else {
      widget.game.overlays.remove('OpeningTimeDialogue');
      widget.game.startCustomerPhase();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (dialogue.isEmpty) return const SizedBox();
    return DialogueBox(line: dialogue[index], onNext: _next);
  }
}
