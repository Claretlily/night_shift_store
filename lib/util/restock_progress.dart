import 'package:flutter/material.dart';
import 'package:night_shift_store/night_shift.dart';

class RestockProgress extends StatelessWidget {
  final NightShift game;

  const RestockProgress({super.key, required this.game});
  @override
  Widget build(BuildContext context) {
    final progress = game.interactProgress / game.interactTime;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Container(
          width: 200,
          height: 20,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            color: Colors.black54,
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(color: Colors.green),
          ),
        ),
      ),
    );
  }
}
