import 'package:flutter/material.dart';

class EndScreen extends StatelessWidget {
  final VoidCallback onRestart;

  const EndScreen({super.key, required this.onRestart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'NIGHT SHIFT',
              style: TextStyle(
                color: Colors.white24,
                fontSize: 20,
                letterSpacing: 6,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Thanks for playing the demo.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'The night shift isn\'t over yet...',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 60),
            GestureDetector(
              onTap: onRestart,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'PLAY AGAIN',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
