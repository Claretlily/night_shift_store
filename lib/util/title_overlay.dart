import 'package:flutter/material.dart';

class TitleOverlay extends StatelessWidget {
  final VoidCallback onStart;

  const TitleOverlay({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/title_bg.png',
              fit: BoxFit.cover,
              color: Colors.black.withValues(alpha: 0.5),
              colorBlendMode: BlendMode.darken,
              errorBuilder: (_, _, _) =>
                  Container(color: const Color(0xFF0a0a0a)),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'NIGHT SHIFT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'A grocery store at night.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 60),

                // Start button
                GestureDetector(
                  onTap: onStart,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white54),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'START',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
