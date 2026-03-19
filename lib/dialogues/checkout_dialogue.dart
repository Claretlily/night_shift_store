import 'package:flutter/material.dart';
import 'package:night_shift_store/dialogues/dialogue_loader.dart';
import 'package:night_shift_store/dialogues/dialogue_template.dart';
import 'package:night_shift_store/night_shift.dart';
import 'package:night_shift_store/util/dialogue_box.dart';

class CheckoutDialogue extends StatefulWidget {
  final NightShift game;
  const CheckoutDialogue({super.key, required this.game});

  @override
  State<CheckoutDialogue> createState() => _CheckoutDialogueState();
}

class _CheckoutDialogueState extends State<CheckoutDialogue> {
  List<DialogueLine> dialogue = [];
  int index = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // Pick dialogue based on which customer is checking out
    final customer = widget.game.activeCheckoutCustomer;
    final key = customer?.bubbleKey == 'BubbleAdam'
        ? 'checkout_adam'
        : 'checkout_alex';
    dialogue = await loadDialogue(key);
    setState(() {});
  }

  void _next() {
    if (index < dialogue.length - 1) {
      setState(() => index++);
    } else {
      // Dialogue finished
      widget.game.overlays.remove('CheckoutDialogue');
      widget.game.onItemSold();

      // Remove the customer from the world
      widget.game.activeCheckoutCustomer?.removeFromParent();
      widget.game.activeCheckoutCustomer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (dialogue.isEmpty) return const SizedBox();
    return DialogueBox(line: dialogue[index], onNext: _next);
  }
}
