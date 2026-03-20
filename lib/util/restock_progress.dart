import 'package:flutter/material.dart';
import 'package:night_shift_store/night_shift.dart';

class RestockProgress extends StatefulWidget {
  final NightShift game;
  const RestockProgress({super.key, required this.game});

  @override
  State<RestockProgress> createState() => _RestockProgressState();
}

class _RestockProgressState extends State<RestockProgress> {
  void _scheduleRebuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
        _scheduleRebuild();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scheduleRebuild();
  }

  @override
  Widget build(BuildContext context) {
    final progress = (widget.game.interactProgress / widget.game.interactTime)
        .clamp(0.0, 1.0);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 200,
              height: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.black54,
                  color: Colors.green,
                  minHeight: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
