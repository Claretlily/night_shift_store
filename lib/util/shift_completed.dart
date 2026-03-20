import 'package:flutter/material.dart';
import 'package:night_shift_store/night_shift.dart';

class ShiftCompleted extends StatelessWidget {
  final NightShift game;

  const ShiftCompleted({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.92),
          border: Border.all(color: Colors.amber, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.nightlife_rounded, color: Colors.amber, size: 48),
            const SizedBox(height: 16),
            const Text(
              "Your first opening shift is completed!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "You've restocked all the shelves. Good work.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                game.shiftStarted = false;
                game.restockTasks.clear();
                game.overlays.remove('ShiftComplete');
                game.onGameEnd();
              },
              child: const Text(
                'End Shift',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
