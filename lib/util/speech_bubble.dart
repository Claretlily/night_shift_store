import 'package:flutter/material.dart';
import 'package:night_shift_store/night_shift.dart';

class SpeechBubble extends StatelessWidget {
  final NightShift game;
  final String text;
  final String customerKey;

  const SpeechBubble({
    super.key,
    required this.game,
    required this.text,
    required this.customerKey,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black26),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.black87, fontSize: 14),
        ),
      ),
    );
  }
}
