import 'package:flutter/material.dart';
import '../night_shift.dart';

class ClockInDialogue extends StatelessWidget {
  final NightShift game;

  const ClockInDialogue({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: .85),
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "CLOCK IN",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Start your night shift?",
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    game.overlays.remove('ClockInDialogue');
                  },
                  child: const Text("No"),
                ),

                ElevatedButton(
                  onPressed: () {
                    // Remove dialogue
                    game.overlays.remove('ClockInDialogue');

                    // Start shift logic
                    game.shiftStarted = true;
                    game.overlays.add('TaskPanel');

                    //showing next dialogue
                    game.overlays.add('StartshiftDialogue');
                  },
                  child: const Text("Yes"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
