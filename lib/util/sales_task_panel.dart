import 'package:flutter/material.dart';
import 'package:night_shift_store/night_shift.dart';

class SalesTaskPanel extends StatelessWidget {
  final NightShift game;
  const SalesTaskPanel({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: game.salesNotifier,
      builder: (context, _, _) {
        final sold = game.itemsSold;
        final quota = game.itemQuota;

        return Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: 220,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8),
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sales Quota',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Items sold: $sold / $quota',
                    style: const TextStyle(color: Colors.amber, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: sold / quota,
                      minHeight: 6,
                      backgroundColor: Colors.white24,
                      color: Colors.amber,
                    ),
                  ),
                  SizedBox(height: 12),
                  const Divider(color: Colors.white24, height: 1),
                  SizedBox(height: 8),
                  // Quota checklist
                  ...List.generate(
                    quota,
                    (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Icon(
                            i < sold
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: i < sold ? Colors.green : Colors.white54,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Customer ${i + 1}',
                            style: TextStyle(
                              color: i < sold ? Colors.white38 : Colors.white,
                              fontSize: 13,
                              decoration: i < sold
                                  ? TextDecoration.lineThrough
                                  : null,
                              decorationColor: Colors.white38,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
